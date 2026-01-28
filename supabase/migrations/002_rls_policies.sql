-- DCBus Row Level Security Policies
-- Enables anonymous crowdsourced tracking with device-based access control

-- ============================================================================
-- ENABLE RLS ON ALL TABLES
-- ============================================================================

ALTER TABLE routes ENABLE ROW LEVEL SECURITY;
ALTER TABLE stops ENABLE ROW LEVEL SECURITY;
ALTER TABLE active_trackers ENABLE ROW LEVEL SECURITY;
ALTER TABLE clustered_buses ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- ROUTES: Public read-only access (static data)
-- ============================================================================

CREATE POLICY "Routes are publicly readable"
    ON routes
    FOR SELECT
    TO anon, authenticated
    USING (true);

-- Admin-only write (service role bypasses RLS)
CREATE POLICY "Routes writable by service role only"
    ON routes
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

-- ============================================================================
-- STOPS: Public read-only access (static data)
-- ============================================================================

CREATE POLICY "Stops are publicly readable"
    ON stops
    FOR SELECT
    TO anon, authenticated
    USING (true);

CREATE POLICY "Stops writable by service role only"
    ON stops
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

-- ============================================================================
-- CLUSTERED BUSES: Public read for map display
-- ============================================================================

CREATE POLICY "Clustered buses publicly readable"
    ON clustered_buses
    FOR SELECT
    TO anon, authenticated
    USING (true);

-- Only server functions can manage clusters
CREATE POLICY "Buses managed by service role"
    ON clustered_buses
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

-- ============================================================================
-- ACTIVE TRACKERS: Device-based access control
-- ============================================================================

-- Anyone can read trackers (for debugging/admin; production may restrict)
CREATE POLICY "Trackers readable for monitoring"
    ON active_trackers
    FOR SELECT
    TO anon, authenticated
    USING (true);

-- Anonymous users can insert their tracker
-- Device ID is passed via request headers: x-device-id
CREATE POLICY "Trackers can insert their location"
    ON active_trackers
    FOR INSERT
    TO anon, authenticated
    WITH CHECK (true);

-- Device can only update its own tracker
-- Client must set: supabase.rpc('set_device_context', {device_id: '...'})
CREATE POLICY "Trackers can update own location"
    ON active_trackers
    FOR UPDATE
    TO anon, authenticated
    USING (
        device_id = COALESCE(
            current_setting('request.headers', true)::json->>'x-device-id',
            current_setting('app.device_id', true)
        )
    )
    WITH CHECK (
        device_id = COALESCE(
            current_setting('request.headers', true)::json->>'x-device-id',
            current_setting('app.device_id', true)
        )
    );

-- Device can delete its own tracker (stop tracking)
CREATE POLICY "Trackers can delete own record"
    ON active_trackers
    FOR DELETE
    TO anon, authenticated
    USING (
        device_id = COALESCE(
            current_setting('request.headers', true)::json->>'x-device-id',
            current_setting('app.device_id', true)
        )
    );

-- Service role can manage all trackers (for cleanup functions)
CREATE POLICY "Service role manages all trackers"
    ON active_trackers
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

-- ============================================================================
-- HELPER: Set device context for RLS
-- ============================================================================

CREATE OR REPLACE FUNCTION set_device_context(p_device_id TEXT)
RETURNS void AS $$
BEGIN
    PERFORM set_config('app.device_id', p_device_id, true);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION set_device_context IS 'Set device ID for RLS policies. Call before update/delete operations.';
