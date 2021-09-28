import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:xproject_app/core/http_helper.dart';
import 'package:xproject_app/core/user_context.dart';
import 'package:xproject_app/models/walking_tracker_models.dart';

abstract class WalkingTrackerRepository {
  const WalkingTrackerRepository();
  Future<bool> createSession(WalkingTrackerSession session);
}

class WalkingTrackerRepositoryImpl extends WalkingTrackerRepository {
  final UserContext userContext;
  const WalkingTrackerRepositoryImpl({
    required this.userContext,
  });
  Future<bool> createSession(WalkingTrackerSession session) async {
    final request = json.encode(session.toJson());
    final response = await http.post(Uri.parse(
      HttpHelper.apiUrl + 'api/v1/walking_tracker/session/create/?format=json'),
      body: request,
      headers: {
        'Content-Type': "application/json",
        'Authorization': 'token ' + (await userContext.getUserToken())!
      }
    );
    if (HttpHelper.isTypicalHttpSuccess(response.statusCode)) {
      return true;
    } else {
      //TODO: handle api errors
      throw (ServerException(response: response));
    }
  }
}
