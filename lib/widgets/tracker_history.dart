
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xproject_app/blocs/walking_tracker/walking_tracker_bloc.dart';
import 'package:xproject_app/blocs/walking_tracker_session_server_log/walking_tracker_session_server_log_bloc.dart';
import 'package:xproject_app/core/device_location/device_location_service.dart';
import 'package:xproject_app/core/device_location/models.dart';
import 'package:xproject_app/core/google_fit/health_api_service.dart';
import 'package:xproject_app/core/pedometer_service.dart';
import 'package:xproject_app/core/user_context.dart';
import 'package:xproject_app/injection_container.dart';
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  ...state.sessions.map(
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