import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

/// Service for managing anonymous device identification
/// Uses a locally stored UUID that persists across sessions
class DeviceIdService {
  static const String _boxName = 'device_settings';
  static const String _deviceIdKey = 'device_id';
  
  Box? _box;
  String? _cachedDeviceId;
  
  /// Get or create a unique device ID
  Future<String> getDeviceId() async {
    // Return cached if available
    if (_cachedDeviceId != null) return _cachedDeviceId!;
    
    // Open box if needed
    _box ??= await Hive.openBox(_boxName);
    
    // Check for existing ID
    String? deviceId = _box?.get(_deviceIdKey);
    
    if (deviceId == null) {
      // Generate new UUID
      deviceId = const Uuid().v4();
      await _box?.put(_deviceIdKey, deviceId);
    }
    
    _cachedDeviceId = deviceId;
    return deviceId;
  }
  
  /// Reset device ID (for testing/debugging)
  Future<void> resetDeviceId() async {
    _box ??= await Hive.openBox(_boxName);
    await _box?.delete(_deviceIdKey);
    _cachedDeviceId = null;
  }
}

/// Provider for DeviceIdService
final deviceIdServiceProvider = Provider<DeviceIdService>((ref) {
  return DeviceIdService();
});
