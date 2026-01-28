import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../config/app_config.dart';

class RouteService {
  /// Fetch a route between two points using Mapbox Directions API
  static Future<List<Position>> getRoute(
    double startLat, 
    double startLng, 
    double endLat, 
    double endLng,
  ) async {
    // Choose profile based on distance (simplified)
    // For now, default to driving to stick to roads reliably
    const profile = 'mapbox/driving';
    
    final url = Uri.parse(
      'https://api.mapbox.com/directions/v5/$profile/$startLng,$startLat;$endLng,$endLat?geometries=geojson&access_token=${AppConfig.mapboxAccessToken}',
    );

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final routes = data['routes'] as List;
        
        if (routes.isNotEmpty) {
          final geometry = routes[0]['geometry'];
          final coordinates = geometry['coordinates'] as List;
          
          return coordinates.map((coord) {
            final point = coord as List;
            return Position(point[0].toDouble(), point[1].toDouble());
          }).toList();
        }
      }
      print('Error fetching route: ${response.statusCode} ${response.body}');
    } catch (e) {
      print('Exception fetching route: $e');
    }
    
    // Fallback: Return straight line
    return [
      Position(startLng, startLat),
      Position(endLng, endLat),
    ];
  }
}
