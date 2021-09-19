import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'walking_tracker_session_server_log_event.dart';
part 'walking_tracker_session_server_log_state.dart';

class WalkingTrackerSessionServerLogBloc extends Bloc<WalkingTrackerSessionServerLogEvent, WalkingTrackerSessionServerLogState> {
  WalkingTrackerSessionServerLogBloc() : super(WalkingTrackerSessionServerLogInitial());

  @override
  Stream<WalkingTrackerSessionServerLogState> mapEventToState(
    WalkingTrackerSessionServerLogEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
