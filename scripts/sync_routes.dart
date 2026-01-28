// DCBus Route Sync Script
// Uploads all routes from local JSON files to Supabase
//
// Usage:
//   dart run scripts/sync_routes.dart
//
// Make sure to set environment variables:
//   SUPABASE_URL=https://your-project.supabase.co
//   SUPABASE_SERVICE_KEY=your-service-role-key

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const routeFiles = [
  'routes/R102-AM.json', 'routes/R102-PM.json',
  'routes/R103-AM.json', 'routes/R103-PM.json',
  'routes/R402-AM.json', 'routes/R402-PM.json',
  'routes/R403-AM.json', 'routes/R403-PM.json',
  'routes/R503-AM.json', 'routes/R503-PM.json',
  'routes/R603-AM.json', 'routes/R603-PM.json',
  'routes/R763-AM.json', 'routes/R763-PM.json',
  'routes/R783-AM.json', 'routes/R783-PM.json',
  'routes/R793-AM.json', 'routes/R793-PM.json',
  'routes/Z999-AM.json',
];

Future<void> main() async {
  final supabaseUrl = Platform.environment['SUPABASE_URL'] ?? 
      'https://nqgadkpkxqvshdavbajx.supabase.co';
  final supabaseKey = Platform.environment['SUPABASE_SERVICE_KEY'];
  
  if (supabaseKey == null) {
    print('ERROR: Set SUPABASE_SERVICE_KEY environment variable');
    print('You need the SERVICE ROLE key (not anon key) from Supabase dashboard');
    exit(1);
  }
  
  print('Syncing routes to Supabase...');
  print('URL: $supabaseUrl\n');
  
  int routeCount = 0;
  int stopCount = 0;
  
  for (final filePath in routeFiles) {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        print('  SKIP: $filePath (not found)');
        continue;
      }
      
      final jsonStr = await file.readAsString();
      final route = jsonDecode(jsonStr) as Map<String, dynamic>;
      
      // Extract route data
      final routeId = route['id'] as String;
      final routeNumber = route['route_number'] as String;
      final name = route['name'] as String;
      final area = route['area'] as String;
      final timePeriod = route['time_period'] as String;
      final color = route['color'] as String;
      final startTime = route['start_time'] as String;
      final endTime = route['end_time'] as String;
      final points = route['points'] as List<dynamic>;
      
      // Build route line from all points (for geofencing)
      final lineCoords = points.map((p) => 
        [p['longitude'], p['latitude']]
      ).toList();
      final routeLine = 'LINESTRING(${lineCoords.map((c) => '${c[0]} ${c[1]}').join(', ')})';
      
      // Upsert route
      final routeResponse = await http.post(
        Uri.parse('$supabaseUrl/rest/v1/routes'),
        headers: {
          'apikey': supabaseKey,
          'Authorization': 'Bearer $supabaseKey',
          'Content-Type': 'application/json',
          'Prefer': 'resolution=merge-duplicates',
        },
        body: jsonEncode({
          'id': routeId,
          'route_number': routeNumber,
          'name': name,
          'area': area,
          'time_period': timePeriod,
          'color': color,
          'start_time': startTime,
          'end_time': endTime,
          'route_line': routeLine,
        }),
      );
      
      if (routeResponse.statusCode >= 200 && routeResponse.statusCode < 300) {
        print('  ✓ Route: $routeNumber-$timePeriod ($name)');
        routeCount++;
      } else {
        print('  ✗ Route $routeNumber: ${routeResponse.body}');
        continue;
      }
      
      // Extract and insert stops (only named stops, not waypoints)
      final stops = points.where((p) => 
        p['kind'] == 'stop' && (p['name'] as String).isNotEmpty
      ).toList();
      
      for (int i = 0; i < stops.length; i++) {
        final stop = stops[i];
        final stopResponse = await http.post(
          Uri.parse('$supabaseUrl/rest/v1/stops'),
          headers: {
            'apikey': supabaseKey,
            'Authorization': 'Bearer $supabaseKey',
            'Content-Type': 'application/json',
            'Prefer': 'resolution=merge-duplicates',
          },
          body: jsonEncode({
            'id': stop['id'],
            'route_id': routeId,
            'name': stop['name'],
            'location': 'POINT(${stop['longitude']} ${stop['latitude']})',
            'heading': stop['heading'],
            'sequence_order': i + 1,
          }),
        );
        
        if (stopResponse.statusCode >= 200 && stopResponse.statusCode < 300) {
          stopCount++;
        } else {
          print('    ✗ Stop ${stop['name']}: ${stopResponse.body}');
        }
      }
      
    } catch (e) {
      print('  ERROR: $filePath - $e');
    }
  }
  
  print('\n========================================');
  print('Sync complete!');
  print('  Routes: $routeCount');
  print('  Stops:  $stopCount');
  print('========================================');
}
