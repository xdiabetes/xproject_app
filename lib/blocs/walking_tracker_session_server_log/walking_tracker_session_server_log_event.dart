part of 'walking_tracker_session_server_log_bloc.dart';

@immutable
abstract class WalkingTrackerSessionServerLogEvent extends Equatable {
  const WalkingTrackerSessionServerLogEvent();
}

class AddWalkingTrackerSession extends WalkingTrackerSessionServerLogEvent {
  final WalkingTrackerSession session;

  const AddWalkingTrackerSession(this.session);

  @override
  List<Object?> get props => [
    session
  ];
}

class SyncSessions extends WalkingTrackerSessionServerLogEvent {
  const SyncSessions();

  @override
  List<Object?> get props => [];
}
