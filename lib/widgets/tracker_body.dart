
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

class TrackerBody extends StatefulWidget {
  @override
  _TrackerBodyState createState() => _TrackerBodyState();
}

class _TrackerBodyState extends State<TrackerBody> with AutomaticKeepAliveClientMixin<TrackerBody> {

  // int trackerInterval = sl<UserContext>().getTrackerInterval();
  int trackerInterval = 2;
  bool trackerRunning = false;
  void runTracker(DateTime startDateTime) async {
    if(!trackerRunning) {
      setState(() {
        trackerRunning = true;
      });
      int seconds = 0;
      while(trackerRunning) {
        bool isOnLogInterval = seconds % trackerInterval == 0;
        DeviceLocation? locationData;
        if(isOnLogInterval){
          locationData = await sl<DeviceLocationService>().getDeviceLocation();
        }
        BlocProvider.of<WalkingTrackerBloc>(context).add(
          AddTrackingSnapshot(
            WalkingSnapshot(
              healthApiSteps: await sl<HealthApiService>().getSteps(startDateTime),
              pedometerSteps: await sl<PedometerService>().getPedometerSteps(),
              locationData: locationData,
              logOnServer: isOnLogInterval
            )
          ),
        );
        await Future.delayed(Duration(seconds: 1));
        seconds += 1;
      }
    }
  }
  
  void initiateTracking() async {
    BlocProvider.of<WalkingTrackerBloc>(context).add(
        StartTrackingSession(
            pedometerStepsBeforeSession: await sl<PedometerService>().getPedometerSteps(),
      ),
    );
  }

  void stopTracker(WalkingTrackerSession session) async {
    if(trackerRunning) {
      setState(() {
        trackerRunning = false;
      });
      BlocProvider.of<WalkingTrackerSessionServerLogBloc>(context).add(
        AddWalkingTrackerSession(session.copyWith(
          endDateTime: DateTime.now()
        ))
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
            runTracker(state.walkingTrackerSession.startDateTime);
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
                onPressed: () => runTracker(session.startDateTime),
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
  void initState() {
    super.initState();
    print('TrackerBody initState');
  }

  @override
  void dispose() {
    super.dispose();
    print("TrackerBody dispose");
  }
}