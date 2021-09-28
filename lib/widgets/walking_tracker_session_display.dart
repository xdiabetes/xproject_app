import 'package:flutter/material.dart';
import 'package:xproject_app/models/walking_tracker_models.dart';
import 'package:intl/intl.dart';

class TrackerSessionDataDisplay extends StatelessWidget {
  final WalkingTrackerSession session;
  const TrackerSessionDataDisplay({
    Key? key,
    required this.session,
  }) : super(key: key);

  Widget buildPropValue(String property, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(property),
          Text(value)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildPropValue("Start Time:" , DateFormat("yyyy-MM-DD HH:mm").format(session.startDateTime)),
        buildPropValue("Duration:" , session.durationString),
        buildPropValue("Pedometer Steps:" , (session.pedometerSteps).toString()),
        buildPropValue("Health Api Steps:" , session.healthApiSteps.toString()),
        buildPropValue("Current Speed (MPS):" , session.speedMetersPerSecond.toString()),
        buildPropValue("Average Speed (MPS):" , session.averageSpeedMetersPerSecond.toString()),
        buildPropValue("Logged On Server:" , session.syncedWithServer ? "Yes" : "No"),
        Divider()
      ],
    );
  }
}