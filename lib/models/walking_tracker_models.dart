import 'package:equatable/equatable.dart';

class WalkingSnapshot extends Equatable {
  final int healthApiSteps;
  final int pedometerSteps;
  final double? latitude; // Latitude, in degrees
  final double? longitude; // Longitude, in degrees
  final double? accuracy; // Estimated horizontal accuracy of this location, radial, in meters
  final double? altitude; // In meters above the WGS 84 reference ellipsoid
  final double? speed; // In meters/second
  final double? speedAccuracy; // In meters/second, always 0 on iOS
  final double? heading; // Heading is the horizontal direction of travel of this device, in degrees
  final double? time; // timestamp of the LocationData

  WalkingSnapshot({
    required this.healthApiSteps,
    required this.pedometerSteps,
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
  // TODO: implement props
  List<Object?> get props => [
    healthApiSteps,
    pedometerSteps,
    latitude,
    longitude,
    accuracy,
    altitude,
    speed,
    speedAccuracy,
    heading,
    time,
  ];

  Map<String, dynamic> toJson() {
    return {
      'healthApiSteps': this.healthApiSteps,
      'pedometerSteps': this.pedometerSteps,
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

  factory WalkingSnapshot.fromJson(Map<String, dynamic> map) {
    return WalkingSnapshot(
      healthApiSteps: map['healthApiSteps'] as int,
      pedometerSteps: map['pedometerSteps'] as int,
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

class WalkingTrackerSession extends Equatable{
  final List<WalkingSnapshot> snapshots;
  final int pedometerStepsBeforeSession;
  final DateTime startDateTime;
  final DateTime? endDateTime;

  double get averageSpeedMetersPerSecond {
    return snapshots.length > 0 ? snapshots.map((m) => (m.speed ?? 0)).reduce((a, b) => a + b) / snapshots.length : 0;
  }

  double get speedMetersPerSecond {
    return snapshots.length > 0 ? (snapshots.last.speed ?? 0) : 0;
  }

  int get snapshotsCount {
    return snapshots.length;
  }

  int get healthApiSteps {
    return snapshots.length > 0 ? snapshots.last.healthApiSteps : 0;
  }

  int get pedometerSteps {
    return snapshots.length > 0 ? (snapshots.last.pedometerSteps - pedometerStepsBeforeSession): 0;
  }

  WalkingTrackerSession({
    required this.startDateTime,
    required this.snapshots,
    required this.pedometerStepsBeforeSession,
    this.endDateTime,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    startDateTime,
    endDateTime,
    snapshots
  ];

  WalkingTrackerSession copyWith({
    DateTime? createDateTime,
    DateTime? endDateTime,
    List<WalkingSnapshot>? snapshots,
    int? pedometerStepsBeforeSession,
  }) {
    return WalkingTrackerSession(
      startDateTime: createDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      snapshots: snapshots ?? this.snapshots,
      pedometerStepsBeforeSession: pedometerStepsBeforeSession ?? this.pedometerStepsBeforeSession,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'snapshots': this.snapshots.map((snapshot) => snapshot.toJson()).toList(),
      'pedometerStepsBeforeSession': this.pedometerStepsBeforeSession,
      'createDateTime': this.startDateTime.toIso8601String(),
      'endDateTime': this.endDateTime != null ? this.endDateTime!.toIso8601String() : null,
    };
  }

  static DateTime? dateTimeFromJson(String? json) {
    if(json == null) {
      return null;
    }
    if (json.contains(".")) {
      json = json.substring(0, json.length - 1);
    }
    return DateTime.parse(json);
  }

  static String dateTimeToJson(DateTime json) => json.toIso8601String();

  factory WalkingTrackerSession.fromJson(Map<String, dynamic> map) {
    return WalkingTrackerSession(
      snapshots: (map['snapshots'] as List<dynamic>)
        .map((snapshotData) => WalkingSnapshot.fromJson(snapshotData))
        .toList().cast<WalkingSnapshot>(),
      pedometerStepsBeforeSession: map['pedometerStepsBeforeSession'] as int,
      startDateTime: dateTimeFromJson(map['createDateTime'])!,
      endDateTime: dateTimeFromJson(map['endDateTime']),
    );
  }
}