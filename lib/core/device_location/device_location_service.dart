import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xproject_app/core/device_location/models.dart';

abstract class DeviceLocationService {
  Future<DeviceLocation> getDeviceLocation();
  Future<bool> deviceLocationAvailable();
}


class MockDeviceLocationService implements DeviceLocationService {
  @override
  Future<bool> deviceLocationAvailable() async {
    return true;
  }

  @override
  Future<DeviceLocation> getDeviceLocation() async {
    DeviceLocation _locationData = new DeviceLocation.fromJson({
      'latitude': double.parse(dotenv.get('MOCK_LOCATION_LAT', fallback: '53.367024331403826')),
      'longitude': double.parse(dotenv.get('MOCK_LOCATION_LON', fallback: '-1.489205076229423'))
    });
    return _locationData;
  }
}