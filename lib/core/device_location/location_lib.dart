import 'package:xproject_app/core/device_location/device_location_service.dart';
import 'package:location/location.dart' as location;
import 'package:xproject_app/core/device_location/models.dart';

class DeviceLocationServiceLocationLibImpl implements DeviceLocationService {
  final location.Location _location = new location.Location();

  DeviceLocationServiceLocationLibImpl();

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
  Future<DeviceLocation> getDeviceLocation() async {
    location.LocationData _locationData = await _location.getLocation();
    return DeviceLocation(
      latitude: _locationData.latitude,
      longitude: _locationData.longitude,
      accuracy: _locationData.accuracy,
      altitude: _locationData.altitude,
      speed: _locationData.speed,
      speedAccuracy: _locationData.speedAccuracy,
      heading: _locationData.heading,
      time: _locationData.time,
    );
  }

}