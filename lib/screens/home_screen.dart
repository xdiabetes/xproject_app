import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:xproject_app/core/device_location_service.dart';
import 'package:xproject_app/core/health_api_service.dart';
import 'package:xproject_app/core/user_context.dart';
import 'package:xproject_app/injection_container.dart';
import 'package:collection/collection.dart';
import 'package:xproject_app/widgets/tracker_body.dart';

class HomeScreenPage extends StatefulWidget {
  @override
  _HomeScreenPageState createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  static const String locationPermissionKey = "LOCATION";
  static const String healthApiPermissionKey = "HEALTHAPI";

  late Future<void> requestPermissionsFuture;

  Map<String, bool> permissions = {
    healthApiPermissionKey: false,
    locationPermissionKey: false,
  };

  bool get _permissionsGranted {
    return permissions.values.toList().firstWhereOrNull((element) => !element) == null;
  }

  Future<void> requestNeededPermissions() async {
    var newPermissions = Map<String, bool>.from(permissions);
    if(!(newPermissions[healthApiPermissionKey]!)){
      newPermissions[healthApiPermissionKey] = await sl<HealthApiService>().requestHealthPermission();
    }
    if(!(newPermissions[locationPermissionKey]!)){
      bool locationAvailable = await sl<DeviceLocationService>().deviceLocationAvailable();
      if(locationAvailable) {
        // make sure we can get location
        await sl<DeviceLocationService>().getDeviceLocation();
        newPermissions[locationPermissionKey] = true;
      }
    }
    setState(() {
      permissions = newPermissions;
    });
  }

  Widget permissionDeniedWidget([String? reason]) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Could not get needed permissions, reason: ' + (reason != null ? reason : '')),
        Container(
          padding: EdgeInsets.only(top: 8.0),
          width: double.infinity,
          child: MaterialButton(
            color: Colors.white60,
            onPressed: () {
              setState(() {
                requestPermissionsFuture = requestNeededPermissions();
              });
            },
            child: Text('retry'),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    requestPermissionsFuture = requestNeededPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Diabo'),
          ),
          body: FutureBuilder<void>(
            future: requestPermissionsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text('Requesting Permission...'),
                );
              }
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              if(!_permissionsGranted) {
                return permissionDeniedWidget();
              }

              return TrackerBody();
            },
          ),
      ),
    );
  }
}