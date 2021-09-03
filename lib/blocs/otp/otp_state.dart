part of 'otp_bloc.dart';

abstract class OtpState extends Equatable {
  const OtpState();
}

class OtpInitial extends OtpState {
  @override
  List<Object> get props => [];
}

class OtpLoading extends OtpState {
  @override
  List<Object> get props => [];
}

class OtpCodeSent extends OtpState {
  final OtpSendCodeResponse otpSendCodeResponse;
  final OtpSendCodeRequest otpSendCodeRequest;

  const OtpCodeSent({
    required this.otpSendCodeResponse,
    required this.otpSendCodeRequest
  });

  @override
  List<Object> get props => [
    otpSendCodeRequest,
    otpSendCodeResponse
  ];
}

class OtpDoneState extends OtpState {
  final OtpVerifyCodeResponse otpVerifyCodeResponse;
  const OtpDoneState({
    required this.otpVerifyCodeResponse
  });

  @override
  List<Object> get props => [
    otpVerifyCodeResponse
  ];
}