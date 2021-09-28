import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:xproject_app/models/walking_tracker_models.dart';

part 'walking_tracker_session_server_log_event.dart';
part 'walking_tracker_session_server_log_state.dart';

class WalkingTrackerSessionServerLogBloc extends HydratedBloc<WalkingTrackerSessionServerLogEvent, WalkingTrackerSessionServerLogState> {
  WalkingTrackerSessionServerLogBloc() : super(WalkingTrackerSessionServerLogState.initial());

  @override
  Stream<WalkingTrackerSessionServerLogState> mapEventToState(
    WalkingTrackerSessionServerLogEvent event,
  ) async* {
    if (event is AddWalkingTrackerSession) {
      final sessions = List<WalkingTrackerSession>.from(state.sessions);
      if(event is AddWalkingTrackerSession) {
        sessions.add(event.session);
      }
      for(var i = 0; i < sessions.length; i++) {
        // TODO send sessions to server
      }
      yield WalkingTrackerSessionServerLogState(sessions: sessions);
    }
  }


  @override
  WalkingTrackerSessionServerLogState? fromJson(Map<String, dynamic> json) {
    try {
      final sessions = (json['sessions'] as List).map((e) =>
        WalkingTrackerSession.fromJson(e)
      ).toList().cast<WalkingTrackerSession>();
      return WalkingTrackerSessionServerLogState(
        sessions: sessions,
      );
    } catch (err) {
      print("WalkingTrackerSession fromJson err");
      print(err);
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(WalkingTrackerSessionServerLogState state) {
    if(state is WalkingTrackerSessionServerLogState) {
      return {
        'sessions': state.sessions.map((e) => e.toJson()).toList()
      };
    } else {
      return {};
    }
  }
}
