-- DCBus Server-side Functions
-- Clustering, validation, and cleanup logic

-- ============================================================================
-- CLUSTERING: Group nearby trackers into virtual buses
-- ============================================================================

CREATE OR REPLACE FUNCTION cluster_trackers()
RETURNS void AS $$
DECLARE
    cluster_radius_meters CONSTANT REAL := 50;  -- 50m clustering radius
BEGIN
    -- Reset all cluster assignments
    UPDATE active_trackers SET cluster_id = NULL WHERE is_valid = true;
    
    -- Assign cluster IDs using leader-follower approach
    -- Each tracker joins the cluster of the nearest valid tracker ahead of it
    WITH ordered_trackers AS (
        SELECT 
            t.id,
            t.route_id,
            t.location,
            ROW_NUMBER() OVER (PARTITION BY t.route_id ORDER BY t.created_at) as seq
        FROM active_trackers t
        WHERE t.is_valid = true
    ),
    cluster_assignments AS (
        SELECT 
            t1.id,
            COALESCE(
                -- Find the first tracker within radius that was created before this one
                (SELECT t2.id 
                 FROM ordered_trackers t2 
                 WHERE t2.route_id = t1.route_id 
                   AND t2.seq < t1.seq
                   AND ST_DWithin(t1.location, t2.location, cluster_radius_meters)
                 ORDER BY t2.seq
                 LIMIT 1),
                -- No nearby tracker found, this is a cluster leader
                t1.id
            ) as cluster_leader
        FROM ordered_trackers t1
    )
    UPDATE active_trackers t
    SET cluster_id = c.cluster_leader
    FROM cluster_assignments c
    WHERE t.id = c.id;
    
    -- Rebuild clustered_buses table with centroids
    DELETE FROM clustered_buses;
    
    INSERT INTO clustered_buses (id, route_id, centroid, avg_heading, avg_speed, tracker_count, last_updated)
    SELECT 
        cluster_id,
        route_id,
        ST_Centroid(ST_Collect(location::geometry))::geography,
        AVG(heading) FILTER (WHERE heading IS NOT NULL),
        AVG(speed) FILTER (WHERE speed IS NOT NULL),
        COUNT(*),
        MAX(last_updated)
    FROM active_trackers
    WHERE cluster_id IS NOT NULL AND is_valid = true
    GROUP BY cluster_id, route_id;
    
    RAISE NOTICE 'Clustering complete. % clusters created.', (SELECT COUNT(*) FROM clustered_buses);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION cluster_trackers IS 'Groups nearby trackers (within 50m) into virtual buses. Run periodically via pg_cron.';

-- ============================================================================
-- VALIDATION: Check if tracker is on route
-- ============================================================================

CREATE OR REPLACE FUNCTION validate_tracker_position(
    p_tracker_id UUID,
    p_max_distance_meters REAL DEFAULT 100
)
RETURNS BOOLEAN AS $$
DECLARE
    v_distance REAL;
    v_is_valid BOOLEAN;
    v_route_id UUID;
BEGIN
    -- Get distance from tracker to route line
    SELECT 
        t.route_id,
        ST_Distance(t.location, r.route_line)
    INTO v_route_id, v_distance
    FROM active_trackers t
    JOIN routes r ON t.route_id = r.id
    WHERE t.id = p_tracker_id;
    
    IF v_route_id IS NULL THEN
        RAISE NOTICE 'Tracker % not found', p_tracker_id;
        RETURN FALSE;
    END IF;
    
    -- Check if within allowed distance
    v_is_valid := (v_distance <= p_max_distance_meters);
    
    -- Update tracker validity
    UPDATE active_trackers 
    SET is_valid = v_is_valid 
    WHERE id = p_tracker_id;
    
    IF NOT v_is_valid THEN
        RAISE NOTICE 'Tracker % is % meters from route (max: %)', 
            p_tracker_id, v_distance, p_max_distance_meters;
    END IF;
    
    RETURN v_is_valid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION validate_tracker_position IS 'Validates tracker is within 100m of route line. Marks invalid if deviated.';

-- ============================================================================
-- VALIDATION: Batch validate all trackers
-- ============================================================================

CREATE OR REPLACE FUNCTION validate_all_trackers()
RETURNS TABLE(tracker_id UUID, is_valid BOOLEAN, distance_meters REAL) AS $$
BEGIN
    RETURN QUERY
    WITH validations AS (
        SELECT 
            t.id,
            ST_Distance(t.location, r.route_line) as dist,
            ST_Distance(t.location, r.route_line) <= 100 as valid
        FROM active_trackers t
        JOIN routes r ON t.route_id = r.id
    )
    UPDATE active_trackers t
    SET is_valid = v.valid
    FROM validations v
    WHERE t.id = v.id
    RETURNING t.id, t.is_valid, v.dist;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- CLEANUP: Remove stale trackers
-- ============================================================================

CREATE OR REPLACE FUNCTION cleanup_stale_trackers()
RETURNS INTEGER AS $$
DECLARE
    v_deleted INTEGER;
    v_invalidated INTEGER;
BEGIN
    -- Delete trackers inactive for >5 minutes
    WITH deleted AS (
        DELETE FROM active_trackers 
        WHERE last_updated < NOW() - INTERVAL '5 minutes'
        RETURNING id
    )
    SELECT COUNT(*) INTO v_deleted FROM deleted;
    
    -- Mark stationary trackers as invalid (likely got off bus)
    -- Speed < 2 m/s (~7 km/h) for >2 minutes
    WITH invalidated AS (
        UPDATE active_trackers 
        SET is_valid = false 
        WHERE speed IS NOT NULL 
          AND speed < 2
          AND last_updated < NOW() - INTERVAL '2 minutes'
          AND is_valid = true
        RETURNING id
    )
    SELECT COUNT(*) INTO v_invalidated FROM invalidated;
    
    RAISE NOTICE 'Cleanup: % deleted, % invalidated (stationary)', v_deleted, v_invalidated;
    
    -- Re-run clustering after cleanup
    PERFORM cluster_trackers();
    
    RETURN v_deleted;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION cleanup_stale_trackers IS 'Removes inactive trackers and invalidates stationary ones. Run every minute via pg_cron.';

-- ============================================================================
-- UPSERT: Insert or update tracker location (called by Flutter app)
-- ============================================================================

CREATE OR REPLACE FUNCTION upsert_tracker_location(
    p_device_id TEXT,
    p_route_id UUID,
    p_longitude DOUBLE PRECISION,
    p_latitude DOUBLE PRECISION,
    p_heading REAL DEFAULT NULL,
    p_speed REAL DEFAULT NULL,
    p_accuracy REAL DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    v_tracker_id UUID;
    v_location GEOGRAPHY;
BEGIN
    -- Create geography point
    v_location := ST_SetSRID(ST_MakePoint(p_longitude, p_latitude), 4326)::geography;
    
    -- Upsert tracker
    INSERT INTO active_trackers (device_id, route_id, location, heading, speed, accuracy, last_updated)
    VALUES (p_device_id, p_route_id, v_location, p_heading, p_speed, p_accuracy, NOW())
    ON CONFLICT (device_id) 
    DO UPDATE SET
        route_id = EXCLUDED.route_id,
        location = EXCLUDED.location,
        heading = EXCLUDED.heading,
        speed = EXCLUDED.speed,
        accuracy = EXCLUDED.accuracy,
        last_updated = NOW()
    RETURNING id INTO v_tracker_id;
    
    -- Validate position (async would be better for production)
    PERFORM validate_tracker_position(v_tracker_id);
    
    RETURN v_tracker_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

COMMENT ON FUNCTION upsert_tracker_location IS 'Main function called by Flutter app to stream location updates.';

-- ============================================================================
-- HELPER: Get buses on route with ETA calculations
-- ============================================================================

CREATE OR REPLACE FUNCTION get_buses_on_route(p_route_id UUID)
RETURNS TABLE(
    bus_id UUID,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    heading REAL,
    speed REAL,
    tracker_count INTEGER,
    last_updated TIMESTAMPTZ
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        cb.id,
        ST_Y(cb.centroid::geometry),
        ST_X(cb.centroid::geometry),
        cb.avg_heading,
        cb.avg_speed,
        cb.tracker_count,
        cb.last_updated
    FROM clustered_buses cb
    WHERE cb.route_id = p_route_id
      AND cb.last_updated > NOW() - INTERVAL '5 minutes'
    ORDER BY cb.last_updated DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================================
-- TRIGGER: Auto-validate and cluster on tracker update
-- ============================================================================

CREATE OR REPLACE FUNCTION on_tracker_update()
RETURNS TRIGGER AS $$
BEGIN
    -- Debounce clustering (only run every 5 seconds based on tracker count)
    IF (SELECT COUNT(*) FROM active_trackers WHERE is_valid = true) > 0 THEN
        -- In production, use pg_cron instead of trigger-based clustering
        -- This is here for development/testing
        NULL; -- PERFORM cluster_trackers();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Uncomment to enable auto-clustering (may impact performance with many trackers)
-- CREATE TRIGGER tracker_update_trigger
--     AFTER INSERT OR UPDATE ON active_trackers
--     FOR EACH STATEMENT EXECUTE FUNCTION on_tracker_update();
