
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xproject_app/blocs/walking_tracker_session_server_log/walking_tracker_session_server_log_bloc.dart';
import 'package:xproject_app/models/walking_tracker_models.dart';
import 'package:xproject_app/widgets/walking_tracker_session_display.dart';

class TrackerHistory extends StatefulWidget {
  @override
  _TrackerHistoryState createState() => _TrackerHistoryState();
}

class _TrackerHistoryState extends State<TrackerHistory> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WalkingTrackerSessionServerLogBloc, WalkingTrackerSessionServerLogState>(
        listener: (context, state) {
        },
        builder: (context, state) {
          if(state is WalkingTrackerSessionServerLogState) {
            final sessionsSorted = List<WalkingTrackerSession>.from(state.sessions);
            sessionsSorted.sort((a, b) => b.startDateTime.compareTo(a.startDateTime));
            return SingleChildScrollView(
              child: Column(
                children: [
                  ...sessionsSorted.map(
                    (el) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: TrackerSessionDataDisplay(
                          session: el
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Text("Unhandled State for WalkingTrackerLogs");
          }
        }
    );
  }
}