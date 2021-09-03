import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:xproject_app/core/user_context.dart';
import 'package:xproject_app/models/otp_request_response_models.dart';
import 'package:xproject_app/repositories/otp_repository.dart';

part 'otp_event.dart';
part 'otp_state.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final OtpRepository otpRepository;
  final UserContext userContext;

  OtpBloc({
    required this.otpRepository,
    required this.userContext
  }) : super(OtpInitial());

  @override
  Stream<OtpState> mapEventToState(
    OtpEvent event,
  ) async* {
    if (event is OtpSendCodeEvent) {
      yield OtpLoading();
      try {
        OtpSendCodeResponse response =
            await otpRepository.sendCode(event.otpSendCodeRequest);
        yield OtpCodeSent(
            otpSendCodeRequest: event.otpSendCodeRequest,
            otpSendCodeResponse: response,
        );
      } catch (err) {
        print(err);
      }
    }
    if (event is OtpVerifyCodeEvent) {
      yield OtpLoading();
      try {
        OtpVerifyCodeResponse response = await otpRepository.verifyCode(event.otpVerifyCodeRequest);
        yield OtpDoneState(
            otpVerifyCodeResponse: response,
        );
      } catch (err) {
        print("OtpVerifyCodeError");
        print(err);
      }
    }
  }
}
