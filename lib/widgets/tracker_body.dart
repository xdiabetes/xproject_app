
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xproject_app/blocs/walking_tracker/walking_tracker_bloc.dart';
import 'package:xproject_app/blocs/walking_tracker_session_server_log/walking_tracker_session_server_log_bloc.dart';
import 'package:xproject_app/core/device_location/device_location_service.dart';
import 'package:xproject_app/core/device_location/models.dart';
import 'package:xproject_app/core/google_fit/health_api_service.dart';
import 'package:xproject_app/core/pedometer/pedometer_service.dart';
import 'package:xproject_app/core/user_context.dart';
import 'package:xproject_app/injection_container.dart';
import 'package:xproject_app/models/walking_tracker_models.dart';
import 'package:xproject_app/widgets/walking_tracker_session_display.dart';

class TrackerBody extends StatefulWidget {
  @override
  _TrackerBodyState createState() => _TrackerBodyState();
}

class _TrackerBodyState extends State<TrackerBody> with AutomaticKeepAliveClientMixin<TrackerBody> {
  Timer? _timer;
  int _seconds = 0;
  int trackerInterval = 1;
  bool get trackerRunning => _timer != null;
  late WalkingTrackerSession _currentSession;

  Future<void> _getSnapshot() async {
    bool isOnLogInterval = _seconds % trackerInterval == 0;
    DeviceLocation? locationData;
    if(isOnLogInterval){
      locationData = await sl<DeviceLocationService>().getDeviceLocation();
    }
    BlocProvider.of<WalkingTrackerBloc>(context).add(
      AddTrackingSnapshot(
        WalkingSnapshot(
          healthApiSteps: await sl<HealthApiService>().getSteps(_currentSession.startDateTime),
          pedometerSteps: await sl<PedometerService>().getPedometerSteps(),
          locationData: locationData,
          logOnServer: isOnLogInterval
        )
      ),
    );
  }

  void runTracker(WalkingTrackerSession session) async {
    _currentSession = session;
    if(!trackerRunning) {
      _seconds = 0;
      setState(() {
        _timer = Timer.periodic(
          const Duration(seconds: 1),
          (timer) async {
            _getSnapshot();
            _seconds += 1;
          },
        );
      });
    }
  }

  void initiateTracking() async {
    BlocProvider.of<WalkingTrackerBloc>(context).add(
        StartTrackingSession(
            pedometerStepsBeforeSession: await sl<PedometerService>().getPedometerSteps(),
      ),
    );
  }
  void _stopTrackerTimer() {
    setState(() {
      _seconds = 0;
      if(_timer != null) {
        _timer!.cancel();
        _timer = null;
      }
    });
  }

  void stopTracker(WalkingTrackerSession session) async {
    if(trackerRunning) {
      await _getSnapshot();
      _stopTrackerTimer();
      BlocProvider.of<WalkingTrackerSessionServerLogBloc>(context).add(
        AddWalkingTrackerSession(
          session.copyWith(
            endDateTime: DateTime.now(),
            snapshots: session.snapshotsWithLocation
          ),
        )
      );
      BlocProvider.of<WalkingTrackerBloc>(context).add(
        StopTrackingSession(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<WalkingTrackerBloc, WalkingTrackerState>(
      listener: (context, state) {
        if(state is WalkingTrackerSessionState) {
          if(state.runTracker) {
            runTracker(state.walkingTrackerSession);
          }
        }
      },
      builder: (context, state) {
        if(state is WalkingTrackerInitial) {
          return buildStartTrackerButton();
        } else if(state is WalkingTrackerSessionState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TrackerSessionDataDisplay(
                session: state.walkingTrackerSession
              ),
              buildTrackerActions(
                state.walkingTrackerSession
              ),
            ],
          );
        } else {
          return Text("Unhandled State for WalkingTracker");
        }
      }
    );
  }

  Widget buildTrackerActions(WalkingTrackerSession session) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          trackerRunning ? SizedBox.shrink() : Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => runTracker(session),
                child: Text("Resume"),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => stopTracker(session),
                child: Text("Stop"),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildStartTrackerButton() {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () => initiateTracking(),
          child: Text("Start"),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => trackerRunning;

  @override
  void dispose() {
    _stopTrackerTimer();
    super.dispose();
  }

}