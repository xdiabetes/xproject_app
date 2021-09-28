import 'package:flutter/material.dart';
import 'package:xproject_app/models/walking_tracker_models.dart';
import 'package:intl/intl.dart';
import 'package:xproject_app/widgets/walking_tracker_prop_value.dart';

class TrackerSessionDataDisplay extends StatelessWidget {
  final WalkingTrackerSession session;
  const TrackerSessionDataDisplay({
    Key? key,
    required this.session,
  }) : super(key: key);

  Widget buildPropValue(String property, String value) {
    return WalkingTrackerPropValue(
      property: property,
      value: value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WalkingTrackerPropValue(
            property: "Start Time:" ,
            value: DateFormat("yyyy-MM-dd HH:mm").format(session.startDateTime),
        ),
        WalkingTrackerPropValue(
            property: "Duration:" ,
            value: session.durationString,
        ),
        WalkingTrackerPropValue(
            property: "Pedometer Steps:" ,
            value: (session.pedometerSteps).toString(),
        ),
        WalkingTrackerPropValue(
            property: "Health Api Steps:" ,
            value: session.healthApiSteps.toString(),
        ),
        WalkingTrackerPropValue(
            property: "Current Speed (MPS):" ,
            value: session.speedMetersPerSecond.toString(),
        ),
        WalkingTrackerPropValue(
            property: "Average Speed (MPS):" ,
            value: session.averageSpeedMetersPerSecond.toString(),
        ),
        WalkingTrackerPropValue(
            property: "Logged On Server:" ,
            value: session.syncedWithServer ? "Yes" : "No",
        ),
        Divider()
      ],
    );
  }
}