import 'package:equatable/equatable.dart';
import 'package:xproject_app/core/date_time_utils.dart';
import 'package:xproject_app/core/device_location/models.dart';

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
      'datetime': DateTimeUtils.dateTimeToJson(this.datetime),
    };
  }

  factory WalkingSnapshot.fromJson(Map<String, dynamic> map) {
    return WalkingSnapshot(
      healthApiSteps: map['health_api_steps'] as int,
      pedometerSteps: map['pedometer_steps'] as int,
      locationData: DeviceLocation.fromJsonOrNull(map['location_data']),
      logOnServer: map['log_on_server'] as bool,
      datetime: DateTimeUtils.dateTimeFromJson(map['datetime']),
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
    return snapshotsWithLocation.length > 0 ? snapshotsWithLocation.map((m) => (m.locationData!.speed ?? 0)).reduce((a, b) => a + b) / snapshotsWithLocation.length : 0;
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
      'pedometer_steps_before_session': this.pedometerStepsBeforeSession,
      'start_date_time': DateTimeUtils.dateTimeToJson(this.startDateTime),
      'end_date_time': DateTimeUtils.dateTimeToJsonOrNull(this.endDateTime),
      'synced_with_server': this.syncedWithServer,
    };
  }

  factory WalkingTrackerSession.fromJson(Map<String, dynamic> map) {
    return WalkingTrackerSession(
      snapshots: (map['snapshots'] as List<dynamic>)
        .map((snapshotData) => WalkingSnapshot.fromJson(snapshotData))
        .toList().cast<WalkingSnapshot>(),
      pedometerStepsBeforeSession: map['pedometer_steps_before_session'] as int,
      startDateTime: DateTimeUtils.dateTimeFromJson(map['start_date_time']),
      endDateTime: DateTimeUtils.dateTimeFromJsonOrNull(map['end_date_time']),
      syncedWithServer: map['synced_with_server'],
    );
  }
}