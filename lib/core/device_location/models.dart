
import 'package:equatable/equatable.dart';

class DeviceLocation extends Equatable {
  final double? latitude; // Latitude, in degrees
  final double? longitude; // Longitude, in degrees
  final double? accuracy; // Estimated horizontal accuracy of this location, radial, in meters
  final double? altitude; // In meters above the WGS 84 reference ellipsoid
  final double? speed; // In meters/second
  final double? speedAccuracy; // In meters/second, always 0 on iOS
  final double? heading; // Heading is the horizontal direction of travel of this device, in degrees
  final double? time; // timestamp of the LocationData

  const DeviceLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.altitude,
    required this.speed,
    required this.speedAccuracy,
    required this.heading,
    required this.time,
  });

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    accuracy,
    altitude,
    speed,
    speedAccuracy,
    heading,
    time
  ];

  Map<String, dynamic> toMap() {
    return {
      'latitude': this.latitude,
      'longitude': this.longitude,
      'accuracy': this.accuracy,
      'altitude': this.altitude,
      'speed': this.speed,
      'speedAccuracy': this.speedAccuracy,
      'heading': this.heading,
      'time': this.time,
    };
  }

  factory DeviceLocation.fromMap(Map<String, dynamic> map) {
    return DeviceLocation(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      accuracy: map['accuracy'] as double,
      altitude: map['altitude'] as double,
      speed: map['speed'] as double,
      speedAccuracy: map['speedAccuracy'] as double,
      heading: map['heading'] as double,
      time: map['time'] as double,
    );
  }
}
