part of 'otp_bloc.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();
}

class OtpSendCodeEvent extends OtpEvent {
  final OtpSendCodeRequest otpSendCodeRequest;

  const OtpSendCodeEvent({required this.otpSendCodeRequest});

  @override
  // TODO: implement props
  List<Object?> get props => [
    otpSendCodeRequest
  ];
}

class OtpVerifyCodeEvent extends OtpEvent {
  final OtpVerifyCodeRequest otpVerifyCodeRequest;

  const OtpVerifyCodeEvent({required this.otpVerifyCodeRequest});

  @override
  // TODO: implement props
  List<Object?> get props => [
    otpVerifyCodeRequest
  ];
}