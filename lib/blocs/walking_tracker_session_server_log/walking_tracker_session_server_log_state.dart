part of 'walking_tracker_session_server_log_bloc.dart';

@immutable
class WalkingTrackerSessionServerLogState {
  final List<WalkingTrackerSession> sessions;

  WalkingTrackerSessionServerLogState({
    required this.sessions,
  });

  @override
  List<Object> get props => [
    sessions
  ];

  factory WalkingTrackerSessionServerLogState.initial(){
    return WalkingTrackerSessionServerLogState(
      sessions: [],
    );
  }

  WalkingTrackerSessionServerLogState copyWith({
    List<WalkingTrackerSession>? sessions,
  }) {
    return WalkingTrackerSessionServerLogState(
      sessions: sessions ?? this.sessions,
    );
  }
}
