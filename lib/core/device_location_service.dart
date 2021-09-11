import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart' as location;

abstract class DeviceLocationService {
  Future<location.LocationData> getDeviceLocation();
  Future<bool> deviceLocationAvailable();
}

class DeviceLocationServiceImpl implements DeviceLocationService {
  final location.Location _location = new location.Location();

  DeviceLocationServiceImpl();

  Future<bool> deviceLocationAvailable() async {
    bool _serviceEnabled;
    location.PermissionStatus _permissionGranted;
    bool _gpsStatus = true;
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        _gpsStatus = false;
      }
    }
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != location.PermissionStatus.granted) {
        _gpsStatus = false;
      }
    }
    return _gpsStatus;
  }

  @override
  Future<location.LocationData> getDeviceLocation() async {
    location.LocationData _locationData = await _location.getLocation();
    return _locationData;
  }

}

class MockDeviceLocationService implements DeviceLocationService {
  final location.Location _location = new location.Location();

  @override
  Future<bool> deviceLocationAvailable() async {
    bool _serviceEnabled;
    location.PermissionStatus _permissionGranted;
    bool _gpsStatus = true;
    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        _gpsStatus = false;
      }
    }
    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == location.PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != location.PermissionStatus.granted) {
        _gpsStatus = false;
      }
    }
    return _gpsStatus;
  }

  @override
  Future<location.LocationData> getDeviceLocation() async {
    location.LocationData _locationData = new location.LocationData.fromMap({
      'latitude': double.parse(dotenv.get('MOCK_LOCATION_LAT', fallback: '53.367024331403826')),
      'longitude': double.parse(dotenv.get('MOCK_LOCATION_LON', fallback: '-1.489205076229423'))
    });
    return _locationData;
  }
}