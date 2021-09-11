
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';
import 'package:xproject_app/blocs/walking_tracker/walking_tracker_bloc.dart';
import 'package:xproject_app/core/device_location_service.dart';
import 'package:xproject_app/core/health_api_service.dart';
import 'package:xproject_app/core/pedometer_service.dart';
import 'package:xproject_app/core/user_context.dart';
import 'package:xproject_app/injection_container.dart';
import 'package:xproject_app/models/walking_tracker_models.dart';

class TrackerBody extends StatefulWidget {
  @override
  _TrackerBodyState createState() => _TrackerBodyState();
}

class _TrackerBodyState extends State<TrackerBody> {

  int trackerInterval = sl<UserContext>().getTrackerInterval();
  bool trackerRunning = false;
  void runTracker(DateTime startDateTime) async {
    if(!trackerRunning) {
      setState(() {
        trackerRunning = true;
      });
      while(trackerRunning) {
        LocationData locationData = await sl<DeviceLocationService>().getDeviceLocation();
        BlocProvider.of<WalkingTrackerBloc>(context).add(
          AddTrackingSnapshot(
            WalkingSnapshot(
              healthApiSteps: await sl<HealthApiService>().getSteps(startDateTime),
              pedometerSteps: await sl<PedometerService>().getPedometerSteps(),
              latitude: locationData.latitude,
              longitude: locationData.longitude,
              accuracy: locationData.accuracy,
              altitude: locationData.altitude,
              speed: locationData.speed,
              speedAccuracy: locationData.speedAccuracy,
              heading: locationData.heading,
              time: locationData.time,
            )
          ),
        );
        await Future.delayed(Duration(seconds: 1));
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

  void stopTracker() async {
    if(trackerRunning) {
      setState(() {
        trackerRunning = false;
      });
      BlocProvider.of<WalkingTrackerBloc>(context).add(
        StopTrackingSession(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
          return Center(
            child: ElevatedButton(
              onPressed: () => initiateTracking(),
              child: Text("Start"),
            ),
          );
        } else if(state is WalkingTrackerSessionState) {
          return Column(
            children: [
              Text("pedometerSteps: " + state.walkingTrackerSession.pedometerSteps.toString()),
              Text("healthApiSteps: " + state.walkingTrackerSession.healthApiSteps.toString()),
              Text("speedMetersPerSecond: " + state.walkingTrackerSession.speedMetersPerSecond.toString()),
              Text("averageSpeedMetersPerSecond: " + state.walkingTrackerSession.averageSpeedMetersPerSecond.toString()),
              trackerRunning ? SizedBox.shrink() : Center(
                child: ElevatedButton(
                  onPressed: () => runTracker(state.walkingTrackerSession.startDateTime),
                  child: Text("Resume"),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () => stopTracker(),
                  child: Text("Stop"),
                ),
              )
            ],
          );
        } else {
          return Text("Unhandled State for WalkingTracker");
        }
      }
    );
  }

}