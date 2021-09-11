part of 'walking_tracker_bloc.dart';

abstract class WalkingTrackerEvent extends Equatable {
  const WalkingTrackerEvent();
}

class StartTrackingSession extends WalkingTrackerEvent {
  final int pedometerStepsBeforeSession;

  const StartTrackingSession({
    required this.pedometerStepsBeforeSession,
  });

  @override
  List<Object?> get props => [
    pedometerStepsBeforeSession
  ];
}

class AddTrackingSnapshot extends WalkingTrackerEvent {
  final WalkingSnapshot walkingSnapshot;

  const AddTrackingSnapshot(this.walkingSnapshot);

  @override
  List<Object?> get props => [
    walkingSnapshot
  ];
}

class StopTrackingSession extends WalkingTrackerEvent {
  const StopTrackingSession();

  @override
  List<Object?> get props => [];
}