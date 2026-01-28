-- 005_tracking_sessions.sql

-- Bus Sessions: Represents a physical bus trip
CREATE TABLE IF NOT EXISTS bus_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  route_id TEXT NOT NULL,
  broadcaster_id TEXT, -- The device_id currently providing GPS
  current_location GEOMETRY(POINT), -- Last known location
  heading DOUBLE PRECISION,
  speed DOUBLE PRECISION,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Passengers: Users joined in a session
CREATE TABLE IF NOT EXISTS session_passengers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID REFERENCES bus_sessions(id) ON DELETE CASCADE,
  device_id TEXT NOT NULL,
  destination_stop_id TEXT, -- Where they get off
  is_broadcaster BOOLEAN DEFAULT FALSE,
  joined_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index for spatial queries
CREATE INDEX IF NOT EXISTS bus_sessions_location_idx ON bus_sessions USING GIST (current_location);

-- ENABLE RLS
ALTER TABLE bus_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE session_passengers ENABLE ROW LEVEL SECURITY;

-- Allow public read access (for real-time tracking)
CREATE POLICY "Public read bus_sessions" 
ON bus_sessions FOR SELECT 
TO anon, authenticated 
USING (true);

CREATE POLICY "Public read session_passengers" 
ON session_passengers FOR SELECT 
TO anon, authenticated 
USING (true);

-- Function to handle session joining/creation
-- SECURITY DEFINER: Runs with owner privileges, allowing writes bypassing RLS for the user
CREATE OR REPLACE FUNCTION join_bus_session(
    p_device_id TEXT,
    p_route_id TEXT,
    p_lat DOUBLE PRECISION,
    p_lng DOUBLE PRECISION,
    p_destination_stop_id TEXT
)
RETURNS TABLE (
    session_id UUID,
    is_broadcaster BOOLEAN
) 
LANGUAGE plpgsql
SECURITY DEFINER 
AS $$
DECLARE
    existing_session_id UUID;
    v_is_broadcaster BOOLEAN := FALSE;
BEGIN
    -- 1. Try to find an active session for this route nearby (within 200m)
    -- We look for sessions updated in the last 10 minutes to avoid dead sessions
    SELECT id INTO existing_session_id
    FROM bus_sessions
    WHERE route_id = p_route_id
      AND updated_at > NOW() - INTERVAL '10 minutes'
      AND ST_DWithin(
          current_location,
          ST_SetSRID(ST_MakePoint(p_lng, p_lat), 4326),
          0.002 -- Approx 200m in degrees
      )
    LIMIT 1;

    -- 2. If no session found, create one
    IF existing_session_id IS NULL THEN
        INSERT INTO bus_sessions (route_id, broadcaster_id, current_location)
        VALUES (
            p_route_id, 
            p_device_id, 
            ST_SetSRID(ST_MakePoint(p_lng, p_lat), 4326)
        )
        RETURNING id INTO existing_session_id;
        
        v_is_broadcaster := TRUE;
    END IF;

    -- 3. Add user to session passengers
    -- Remove any existing entry for this device first to be safe
    DELETE FROM session_passengers WHERE device_id = p_device_id;
    
    INSERT INTO session_passengers (session_id, device_id, destination_stop_id, is_broadcaster)
    VALUES (existing_session_id, p_device_id, p_destination_stop_id, v_is_broadcaster);

    RETURN QUERY SELECT existing_session_id, v_is_broadcaster;
END;
$$;

-- Function to update location (only by broadcaster)
CREATE OR REPLACE FUNCTION update_session_location(
    p_session_id UUID,
    p_device_id TEXT,
    p_lat DOUBLE PRECISION,
    p_lng DOUBLE PRECISION,
    p_heading DOUBLE PRECISION DEFAULT NULL,
    p_speed DOUBLE PRECISION DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    UPDATE bus_sessions
    SET 
        current_location = ST_SetSRID(ST_MakePoint(p_lng, p_lat), 4326),
        heading = p_heading,
        speed = p_speed,
        updated_at = NOW()
    WHERE id = p_session_id AND broadcaster_id = p_device_id;
END;
$$;

-- Function to leave session and handle handoff
CREATE OR REPLACE FUNCTION leave_bus_session(
    p_device_id TEXT
)
RETURNS TABLE (
    old_session_id UUID,
    new_broadcaster_id TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_session_id UUID;
    v_is_broadcaster BOOLEAN;
    v_next_candidate TEXT;
BEGIN
    -- Get current session info
    SELECT session_id, is_broadcaster INTO v_session_id, v_is_broadcaster
    FROM session_passengers
    WHERE device_id = p_device_id;

    IF v_session_id IS NULL THEN
        RETURN;
    END IF;

    -- Remove passenger
    DELETE FROM session_passengers WHERE device_id = p_device_id;

    -- If was broadcaster, elect new one
    IF v_is_broadcaster THEN
        -- Find longest waiting passenger
        SELECT device_id INTO v_next_candidate
        FROM session_passengers
        WHERE session_id = v_session_id
        ORDER BY joined_at ASC
        LIMIT 1;

        IF v_next_candidate IS NOT NULL THEN
            -- Promote candidate
            UPDATE bus_sessions 
            SET broadcaster_id = v_next_candidate 
            WHERE id = v_session_id;
            
            UPDATE session_passengers 
            SET is_broadcaster = TRUE 
            WHERE device_id = v_next_candidate AND session_id = v_session_id;
            
            old_session_id := v_session_id;
            new_broadcaster_id := v_next_candidate;
        ELSE
            -- No passengers left, delete session
            DELETE FROM bus_sessions WHERE id = v_session_id;
        END IF;
    END IF;

    RETURN QUERY SELECT v_session_id, v_next_candidate;
END;
$$;
