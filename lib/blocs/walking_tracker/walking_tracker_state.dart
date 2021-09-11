part of 'walking_tracker_bloc.dart';

abstract class WalkingTrackerState extends Equatable {
  const WalkingTrackerState();
}

class WalkingTrackerInitial extends WalkingTrackerState {
  const WalkingTrackerInitial();

  @override
  List<Object> get props => [];
}

class WalkingTrackerSessionState extends WalkingTrackerState {
  final WalkingTrackerSession walkingTrackerSession;
  bool _runTracker = false;

  get runTracker => _runTracker;
  
  void _setRunTracker(bool val) {
    _runTracker = val;
  }

  WalkingTrackerSessionState({
    required this.walkingTrackerSession,
  });

  @override
  List<Object> get props => [
    walkingTrackerSession
  ];

  factory WalkingTrackerSessionState.initial(int pedometerStepsBeforeSession){
    return WalkingTrackerSessionState(
      walkingTrackerSession: WalkingTrackerSession(
        startDateTime: DateTime.now(),
        snapshots: [],
        pedometerStepsBeforeSession: pedometerStepsBeforeSession,
      )
    ).._setRunTracker(true);
  }
}