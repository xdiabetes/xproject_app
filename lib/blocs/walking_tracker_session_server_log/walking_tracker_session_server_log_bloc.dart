import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:xproject_app/models/walking_tracker_models.dart';
import 'package:xproject_app/repositories/walking_tracker_repository.dart';

part 'walking_tracker_session_server_log_event.dart';
part 'walking_tracker_session_server_log_state.dart';

class WalkingTrackerSessionServerLogBloc extends HydratedBloc<WalkingTrackerSessionServerLogEvent, WalkingTrackerSessionServerLogState> {
  WalkingTrackerRepository walkingTrackerRepository;

  WalkingTrackerSessionServerLogBloc({
    required this.walkingTrackerRepository,
  }) : super(WalkingTrackerSessionServerLogState.initial()) {
    add(SyncSessionsWithServer());
  }

  @override
  Stream<WalkingTrackerSessionServerLogState> mapEventToState(
    WalkingTrackerSessionServerLogEvent event,
  ) async* {
    final sessions = List<WalkingTrackerSession>.from(state.sessions);
    if (event is AddWalkingTrackerSession) {
      sessions.add(event.session);
      yield* _mapSyncSessionsWithServerToState(sessions);
    } else if (event is SyncSessionsWithServer) {
      yield* _mapSyncSessionsWithServerToState(sessions);
    }
  }


  Stream<WalkingTrackerSessionServerLogState> _mapSyncSessionsWithServerToState(
    List<WalkingTrackerSession> copyOfSessions
  ) async* {
    for(int i = 0; i < copyOfSessions.length; i++) {
      final session = copyOfSessions[i];
      if(!session.syncedWithServer) {
        bool syncedWithServer = false;
        try {
          await walkingTrackerRepository.createSession(session);
          syncedWithServer = true;
        } catch (err) {
          print("walkingTrackerRepository.createSession err");
          print(err);
        }
        copyOfSessions[i] = session.copyWith(
          syncedWithServer: syncedWithServer
        );
      }
    }
    yield WalkingTrackerSessionServerLogState(sessions: copyOfSessions);
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
