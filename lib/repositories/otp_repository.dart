import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:xproject_app/core/http_helper.dart';
import 'package:xproject_app/models/otp_request_response_models.dart';

abstract class OtpRepository {
  Future<OtpSendCodeResponse> sendCode(OtpSendCodeRequest request);

  Future<OtpVerifyCodeResponse> verifyCode(OtpVerifyCodeRequest otpVerifyCodeRequest);
}

class OtpRepositoryImpl extends OtpRepository {
  Future<OtpSendCodeResponse> sendCode(OtpSendCodeRequest request) async {
    final response = await http.post(Uri.parse(
        HttpHelper.apiUrl + 'api/v1/user_profile/send-code/?format=json'),
                  body: request.toJson());
    if (HttpHelper.isTypicalHttpSuccess(response.statusCode)) {
      return OtpSendCodeResponse.fromJson(jsonDecode(response.body));
    } else {
      //TODO: handle api errors
      throw (ServerException(response: response));
    }
  }

  @override
  Future<OtpVerifyCodeResponse> verifyCode(OtpVerifyCodeRequest request) async {
    final response = await http.post(Uri.parse(
        HttpHelper.apiUrl + 'api/v1/user_profile/verify-code/?format=json'),
        body: request.toJson());
    if (HttpHelper.isTypicalHttpSuccess(response.statusCode)) {
      return OtpVerifyCodeResponse.fromJson(jsonDecode(response.body));
    } else {
      //TODO: handle api errors
      throw (ServerException(response: response));
    }
  }
}
