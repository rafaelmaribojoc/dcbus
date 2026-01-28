-- DCBus Database Schema
-- Crowdsourced bus tracking for Davao City Interim Bus System
-- Requires PostGIS extension

-- Enable PostGIS for geographic operations
CREATE EXTENSION IF NOT EXISTS postgis;

-- ============================================================================
-- STATIC ROUTE DATA (synced from local JSON files)
-- ============================================================================

CREATE TABLE routes (
    id UUID PRIMARY KEY,
    route_number TEXT NOT NULL,
    name TEXT NOT NULL,
    area TEXT NOT NULL CHECK (area IN ('Toril', 'Mintal', 'Bangkal', 'Buhangin', 'Panacan')),
    time_period TEXT NOT NULL CHECK (time_period IN ('AM', 'PM')),
    color TEXT NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    -- PostGIS line for geofencing validation
    route_line GEOGRAPHY(LINESTRING, 4326),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE routes IS 'Static bus route definitions synced from local JSON files';
COMMENT ON COLUMN routes.route_line IS 'PostGIS linestring for geofence validation of tracker positions';

-- ============================================================================
-- BUS STOPS (extracted from route points where kind='stop')
-- ============================================================================

CREATE TABLE stops (
    id UUID PRIMARY KEY,
    route_id UUID NOT NULL REFERENCES routes(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    heading REAL,
    sequence_order INTEGER NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    
    UNIQUE(route_id, sequence_order)
);

COMMENT ON TABLE stops IS 'Named bus stops along each route, ordered by sequence';
COMMENT ON COLUMN stops.heading IS 'Expected bus heading when approaching this stop (degrees, 0=North)';

-- Index for spatial queries
CREATE INDEX idx_stops_location ON stops USING GIST(location);
CREATE INDEX idx_stops_route ON stops(route_id);

-- ============================================================================
-- ACTIVE TRACKERS (passengers with "I am on the bus" enabled)
-- ============================================================================

CREATE TABLE active_trackers (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    device_id TEXT NOT NULL UNIQUE,  -- Anonymous device identifier (hashed)
    route_id UUID NOT NULL REFERENCES routes(id) ON DELETE CASCADE,
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    heading REAL,  -- Device heading in degrees
    speed REAL,    -- Speed in m/s
    accuracy REAL, -- GPS accuracy in meters
    cluster_id UUID,  -- Assigned cluster (virtual bus)
    is_valid BOOLEAN DEFAULT TRUE,  -- False if deviated from route
    last_updated TIMESTAMPTZ DEFAULT NOW(),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE active_trackers IS 'Real-time location of passengers tracking their bus journey';
COMMENT ON COLUMN active_trackers.device_id IS 'Anonymous device identifier, no PII stored';
COMMENT ON COLUMN active_trackers.cluster_id IS 'UUID of cluster leader for grouping nearby trackers';
COMMENT ON COLUMN active_trackers.is_valid IS 'False if tracker deviated from route or is stationary too long';

-- Performance indexes
CREATE INDEX idx_trackers_route ON active_trackers(route_id);
CREATE INDEX idx_trackers_location ON active_trackers USING GIST(location);
CREATE INDEX idx_trackers_updated ON active_trackers(last_updated);
CREATE INDEX idx_trackers_cluster ON active_trackers(cluster_id);
CREATE INDEX idx_trackers_device ON active_trackers(device_id);

-- ============================================================================
-- CLUSTERED BUSES (aggregated view of nearby trackers)
-- ============================================================================

CREATE TABLE clustered_buses (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    route_id UUID NOT NULL REFERENCES routes(id) ON DELETE CASCADE,
    centroid GEOGRAPHY(POINT, 4326) NOT NULL,
    avg_heading REAL,
    avg_speed REAL,
    tracker_count INTEGER DEFAULT 1,
    last_updated TIMESTAMPTZ DEFAULT NOW()
);

COMMENT ON TABLE clustered_buses IS 'Virtual bus positions computed by clustering nearby trackers';
COMMENT ON COLUMN clustered_buses.centroid IS 'Geographic center of all trackers in this cluster';
COMMENT ON COLUMN clustered_buses.tracker_count IS 'Number of passengers currently tracking this bus';

-- Indexes
CREATE INDEX idx_buses_route ON clustered_buses(route_id);
CREATE INDEX idx_buses_location ON clustered_buses USING GIST(centroid);
CREATE INDEX idx_buses_updated ON clustered_buses(last_updated);

-- ============================================================================
-- TRIGGERS: Auto-update timestamps
-- ============================================================================

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER routes_updated_at
    BEFORE UPDATE ON routes
    FOR EACH ROW EXECUTE FUNCTION update_updated_at();

-- Enable Realtime for live bus tracking
ALTER PUBLICATION supabase_realtime ADD TABLE clustered_buses;
ALTER PUBLICATION supabase_realtime ADD TABLE active_trackers;
