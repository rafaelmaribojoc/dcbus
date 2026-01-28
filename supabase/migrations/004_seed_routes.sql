-- DCBus Route Data Seed
-- Run this after the initial schema to populate routes and stops

-- NOTE: This file contains sample data for R102-AM route.
-- For production, use the sync_routes.dart script to upload all routes.

-- ============================================================================
-- ROUTE: R102-AM (Toril to GE Torres)
-- ============================================================================

INSERT INTO routes (id, route_number, name, area, time_period, color, start_time, end_time, route_line)
VALUES (
    '019b4a3c-ce3e-78d5-b27f-413f021bf8b9',
    'R102',
    'Toril to GE Torres',
    'Toril',
    'AM',
    '#430dac',
    '06:00',
    '10:00',
    NULL  -- Route line will be computed from stops
) ON CONFLICT (id) DO UPDATE SET
    route_number = EXCLUDED.route_number,
    name = EXCLUDED.name,
    area = EXCLUDED.area,
    time_period = EXCLUDED.time_period,
    color = EXCLUDED.color,
    start_time = EXCLUDED.start_time,
    end_time = EXCLUDED.end_time;

-- Sample stops for R102-AM (first 5 stops)
INSERT INTO stops (id, route_id, name, location, heading, sequence_order)
VALUES 
    ('019b54ee-65d3-7537-8033-22aacfe11ac2', '019b4a3c-ce3e-78d5-b27f-413f021bf8b9', 'Toril District Hall Station', ST_SetSRID(ST_MakePoint(125.4971863491636, 7.0185982627843515), 4326)::geography, 42.3, 1),
    ('019b54ee-65d4-7bbd-ac76-7bbe39ac9cba', '019b4a3c-ce3e-78d5-b27f-413f021bf8b9', 'Fusion GTH Station', ST_SetSRID(ST_MakePoint(125.50455798503901, 7.025727019244613), 4326)::geography, 53.9, 2),
    ('019b54ee-65d5-7c43-8849-ca826482e4a2', '019b4a3c-ce3e-78d5-b27f-413f021bf8b9', 'Pepsi Dumoy Station', ST_SetSRID(ST_MakePoint(125.51250960187735, 7.03108432722513), 4326)::geography, 52.0, 3),
    ('019b54ee-65d6-7140-99a5-bc1d62e7cbf4', '019b4a3c-ce3e-78d5-b27f-413f021bf8b9', 'Bago Aplaya Crossing Station', ST_SetSRID(ST_MakePoint(125.52965333752059, 7.042767110472454), 4326)::geography, 52.3, 4),
    ('019b54ee-65d7-7dcc-b50a-62e787fefb22', '019b4a3c-ce3e-78d5-b27f-413f021bf8b9', 'Gulf View Station', ST_SetSRID(ST_MakePoint(125.53470440995284, 7.046205699183545), 4326)::geography, 52.4, 5)
ON CONFLICT (id) DO NOTHING;

-- ============================================================================
-- For full route data, use the Dart sync script below
-- ============================================================================
