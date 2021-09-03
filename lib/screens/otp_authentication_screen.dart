import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xproject_app/blocs/authentication/authentication_bloc.dart';
import 'package:xproject_app/blocs/otp/otp_bloc.dart';
import 'package:xproject_app/core/app_router.dart';
import 'package:xproject_app/models/otp_request_response_models.dart';

class OtpAuthenticationPage extends StatefulWidget {
  OtpAuthenticationPage({Key? key}) : super(key: key);

  @override
  _OtpAuthenticationPageState createState() => _OtpAuthenticationPageState();
}

class _OtpAuthenticationPageState extends State<OtpAuthenticationPage> {
  final otpPhoneNumberController = TextEditingController();
  final otpCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocConsumer<OtpBloc, OtpState>(
        listener: (context, state) {
          if (state is OtpCodeSent) {
            if (state.otpSendCodeResponse.code != null) {
              otpCodeController.text = state.otpSendCodeResponse.code!;
            }
          } else if (state is OtpDoneState) {
            BlocProvider.of<AuthenticationBloc>(context).add(
                AuthenticationAuthenticate(
                    token: state.otpVerifyCodeResponse.token,
                )
            );
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRouter.HomeScreenRoute,
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is OtpInitial) {
            return buildOtpGetPhoneNumberForm(context);
          } else if (state is OtpCodeSent) {
            return buildOtpGetCodeForm(context, state.otpSendCodeRequest.phoneNumber);
          } else if (state is OtpLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget buildOtpForm({
    required BuildContext context,
    required TextEditingController controller,
    required String confirmButtonText,
    required Function() onConfirmPressed,
    required String textFieldHint,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: textFieldHint,
            ),
            controller: controller,
          ),
          Container(
            padding: EdgeInsets.only(top: 8.0),
            width: double.infinity,
            child: MaterialButton(
              color: Colors.white60,
              onPressed: onConfirmPressed,
              child: Text(confirmButtonText),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOtpGetCodeForm(BuildContext context, String phoneNumber) {
    return buildOtpForm(
        context: context,
        controller: otpCodeController,
        textFieldHint: 'Enter verification code',
        confirmButtonText: 'Verify Code',
        onConfirmPressed: () {
          BlocProvider.of<OtpBloc>(context).add(
            OtpVerifyCodeEvent(
                otpVerifyCodeRequest: OtpVerifyCodeRequest(
                  phoneNumber: phoneNumber,
                  code: otpCodeController.text
                )),
          );
        }
    );
  }

  Widget buildOtpGetPhoneNumberForm(BuildContext context) {
    return buildOtpForm(
        context: context,
        controller: otpPhoneNumberController,
        textFieldHint: 'Enter your phone number',
        confirmButtonText: 'Send Code',
        onConfirmPressed: () {
          BlocProvider.of<OtpBloc>(context).add(
            OtpSendCodeEvent(
                otpSendCodeRequest: OtpSendCodeRequest(
                    phoneNumber: otpPhoneNumberController.text)),
          );
        }
    );
  }
}
