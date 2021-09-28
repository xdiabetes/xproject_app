import 'package:equatable/equatable.dart';
import 'package:xproject_app/core/device_location/models.dart';


DateTime? dateTimeFromJson(String? json) {
  if(json == null) {
    return null;
  }
  if (json.contains(".")) {
    json = json.substring(0, json.length - 1);
  }
  return DateTime.parse(json);
}

String dateTimeToJson(DateTime json) => json.toIso8601String();

class WalkingSnapshot extends Equatable {
  final int healthApiSteps;
  final int pedometerSteps;
  final DeviceLocation? locationData;
  final DateTime datetime;
  final bool logOnServer;

  WalkingSnapshot({
    required this.healthApiSteps,
    required this.pedometerSteps,
    required this.locationData,
    required this.logOnServer,
    DateTime? datetime
  }) : datetime = datetime ?? DateTime.now();

  @override
  // TODO: implement props
  List<Object?> get props => [
    healthApiSteps,
    pedometerSteps,
    locationData,
    logOnServer
  ];

  Map<String, dynamic> toJson() {
    return {
      'health_api_steps': this.healthApiSteps,
      'pedometer_steps': this.pedometerSteps,
      'location_data': this.locationData != null ?
          this.locationData!.toJson() : null,
      'log_on_server': this.logOnServer,
      'datetime': this.datetime.toIso8601String(),
    };
  }

  factory WalkingSnapshot.fromJson(Map<String, dynamic> map) {
    return WalkingSnapshot(
      healthApiSteps: map['health_api_steps'] as int,
      pedometerSteps: map['pedometer_steps'] as int,
      locationData: (map.containsKey('location_data') && map['location_data'] != null) ?
        DeviceLocation.fromJson(map['location_data']) : null,
      logOnServer: map['log_on_server'] as bool,
      datetime: dateTimeFromJson(map['datetime'])!,
    );
  }
}

class WalkingTrackerSession extends Equatable{
  final List<WalkingSnapshot> snapshots;
  final int pedometerStepsBeforeSession;
  final DateTime startDateTime;
  final DateTime? endDateTime;
  final bool syncedWithServer;

  Duration get duration => (endDateTime ?? DateTime.now()).difference(startDateTime);
  String get durationString => duration.toString().split('.').first.padLeft(8, "0");

  List<WalkingSnapshot> get snapshotsWithLocation {
    return snapshots.where((element) => element.locationData != null).toList();
  }
  double get averageSpeedMetersPerSecond {
    return snapshotsWithLocation.length > 0 ? snapshotsWithLocation.map((m) => (m.locationData!.speed ?? 0)).reduce((a, b) => a + b) / snapshots.length : 0;
  }

  double get speedMetersPerSecond {
    return snapshotsWithLocation.length > 0 ? (snapshotsWithLocation.last.locationData!.speed ?? 0) : 0;
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
    this.syncedWithServer = false,
    this.endDateTime,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    pedometerStepsBeforeSession,
    syncedWithServer,
    startDateTime,
    endDateTime,
    snapshots
  ];

  WalkingTrackerSession copyWith({
    DateTime? createDateTime,
    DateTime? endDateTime,
    List<WalkingSnapshot>? snapshots,
    int? pedometerStepsBeforeSession,
    bool? syncedWithServer
  }) {
    return WalkingTrackerSession(
      startDateTime: createDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      snapshots: snapshots ?? this.snapshots,
      pedometerStepsBeforeSession: pedometerStepsBeforeSession ?? this.pedometerStepsBeforeSession,
      syncedWithServer: syncedWithServer ?? this.syncedWithServer
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'snapshots': this.snapshots.map((snapshot) => snapshot.toJson()).toList(),
      'pedometerStepsBeforeSession': this.pedometerStepsBeforeSession,
      'createDateTime': this.startDateTime.toIso8601String(),
      'endDateTime': this.endDateTime != null ? this.endDateTime!.toIso8601String() : null,
      'syncedWithServer': this.syncedWithServer,
    };
  }

  factory WalkingTrackerSession.fromJson(Map<String, dynamic> map) {
    return WalkingTrackerSession(
      snapshots: (map['snapshots'] as List<dynamic>)
        .map((snapshotData) => WalkingSnapshot.fromJson(snapshotData))
        .toList().cast<WalkingSnapshot>(),
      pedometerStepsBeforeSession: map['pedometerStepsBeforeSession'] as int,
      startDateTime: dateTimeFromJson(map['createDateTime'])!,
      endDateTime: dateTimeFromJson(map['endDateTime']),
      syncedWithServer: map['syncedWithServer'],
    );
  }
}