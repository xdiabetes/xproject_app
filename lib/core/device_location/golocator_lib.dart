import 'package:xproject_app/core/device_location/device_location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:xproject_app/core/device_location/models.dart';

class DeviceLocationServiceGeolocatorLibImpl implements DeviceLocationService {
  DeviceLocationServiceGeolocatorLibImpl();

  Future<bool> deviceLocationAvailable() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      // return Future.error('Location services are disabled.');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        // return Future.error('Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      // return Future.error(
      //     'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    return true;
  }

  @override
  Future<DeviceLocation> getDeviceLocation() async {
    Position _locationData = await Geolocator.getCurrentPosition();
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