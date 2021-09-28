
import 'package:equatable/equatable.dart';
import 'package:xproject_app/core/date_time_utils.dart';

class DeviceLocation extends Equatable {
  final double? latitude; // Latitude, in degrees
  final double? longitude; // Longitude, in degrees
  final double? accuracy; // Estimated horizontal accuracy of this location, radial, in meters
  final double? altitude; // In meters above the WGS 84 reference ellipsoid
  final double? speed; // In meters/second
  final double? speedAccuracy; // In meters/second, always 0 on iOS
  final double? heading; // Heading is the horizontal direction of travel of this device, in degrees
  final DateTime? datetime; // timestamp of the LocationData

  const DeviceLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.altitude,
    required this.speed,
    required this.speedAccuracy,
    required this.heading,
    required this.datetime,
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
    datetime
  ];

  Map<String, dynamic> toJson() {
    return {
      'latitude': this.latitude,
      'longitude': this.longitude,
      'accuracy': this.accuracy,
      'altitude': this.altitude,
      'speed': this.speed,
      'speed_accuracy': this.speedAccuracy,
      'heading': this.heading,
      'datetime': DateTimeUtils.dateTimeToJsonOrNull(this.datetime),
    };
  }

  factory DeviceLocation.fromJson(Map<String, dynamic> map) {
    return DeviceLocation(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      accuracy: map['accuracy'] as double,
      altitude: map['altitude'] as double,
      speed: map['speed'] as double,
      speedAccuracy: map['speed_accuracy'] as double,
      heading: map['heading'] as double,
      datetime: DateTimeUtils.dateTimeFromJsonOrNull(map['datetime']),
    );
  }

  static DeviceLocation? fromJsonOrNull(Map<String, dynamic>? map) {
    if(map != null) {
      return DeviceLocation.fromJson(map);
    }
    return null;
  }
}
