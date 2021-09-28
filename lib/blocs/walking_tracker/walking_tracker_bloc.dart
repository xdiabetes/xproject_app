import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:xproject_app/models/walking_tracker_models.dart';

part 'walking_tracker_event.dart';
part 'walking_tracker_state.dart';

class WalkingTrackerBloc extends HydratedBloc<WalkingTrackerEvent, WalkingTrackerState> {
  WalkingTrackerBloc() : super(WalkingTrackerInitial());

  @override
  Stream<WalkingTrackerState> mapEventToState(
    WalkingTrackerEvent event,
  ) async* {
    if(event is StartTrackingSession) {
      yield WalkingTrackerSessionState.initial(event.pedometerStepsBeforeSession);
    } else if (event is AddTrackingSnapshot) {
      if(state is WalkingTrackerSessionState) {
        final currentState = state as WalkingTrackerSessionState;
        final newSnapshots = List<WalkingSnapshot>.from(
            currentState.walkingTrackerSession.snapshots
        )..add(event.walkingSnapshot);
        yield WalkingTrackerSessionState(
          walkingTrackerSession: currentState.walkingTrackerSession.copyWith(
            snapshots: newSnapshots
          )
        );
      }
    } else if (event is StopTrackingSession) {
      yield WalkingTrackerInitial();
    }
  }

  @override
  WalkingTrackerState? fromJson(Map<String, dynamic> json) {
    try {
      final walkingTrackerSession = WalkingTrackerSession.fromJson(json);
      return WalkingTrackerSessionState(
        walkingTrackerSession: walkingTrackerSession,
      );
    } catch (err) {
      print("WalkingTrackerSession fromJson err");
      print(err);
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(WalkingTrackerState state) {
    if(state is WalkingTrackerSessionState) {
      final walkingTrackerSessionJson = state.walkingTrackerSession.toJson();
      return walkingTrackerSessionJson;
    } else {
      return {};
    }
  }
}
