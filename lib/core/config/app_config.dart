/// DCBus Application Configuration
/// 
/// Contains Supabase and Mapbox configuration.
/// For production, use environment variables or --dart-define.
class AppConfig {
  // Supabase Configuration
  // TODO: Replace with your Supabase project URL
  static const String supabaseUrl = 'https://idkydzzvcooetbothfha.supabase.co';
  
  // TODO: Replace with your Supabase anon key
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imlka3lkenp2Y29vZXRib3RoZmhhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg1NDk2NDMsImV4cCI6MjA4NDEyNTY0M30.Pz25vu67m5b6vFBHWSA18O9793PBBxA-AfLXU6NHqSo';
  
  // Mapbox Configuration
  // TODO: Replace with your Mapbox access token
  static const String mapboxAccessToken = 'pk.eyJ1IjoicmFmYWVsbWFyaWJvam9jIiwiYSI6ImNtamNlOG12ZzByYzQzZW9nOGZxZ3dyZnMifQ.xYsxk8ef76cTzdVX6qLUfQ';
  
  // Davao City bounds for map
  static const double davaoCenterLat = 7.0731;
  static const double davaoCenterLng = 125.6128;
  static const double defaultZoom = 12.0;
  
  // Tracking configuration
  static const int locationUpdateDistanceMeters = 20;
  static const int staleTrackerTimeoutMinutes = 5;
  static const double clusterRadiusMeters = 50;
  static const double maxRouteDeviationMeters = 100;
  static const double stationarySpeedThreshold = 2.0; // m/s (~7 km/h)
}
