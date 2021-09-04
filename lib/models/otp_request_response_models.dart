import 'package:equatable/equatable.dart';

class OtpSendCodeRequest extends Equatable{
  final String phoneNumber;

  const OtpSendCodeRequest({
    required this.phoneNumber
  });

  Map<String, dynamic> toJson() {
    return {'phone_number': phoneNumber};
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    phoneNumber
  ];
}

class OtpSendCodeResponse extends Equatable{
  final int pk;
  final DateTime createDate;
  final int queryTimes;
  final String? code;

  const OtpSendCodeResponse({
    required this.pk,
    required this.createDate,
    required this.queryTimes,
    this.code
  });

  factory OtpSendCodeResponse.fromJson(Map<String, dynamic> json) {
    return OtpSendCodeResponse(
      pk: json['pk'],
      createDate: DateTime.parse(json['create_date']),
      queryTimes: json['query_times'],
      code: json['code'],
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw [
    pk,
    createDate,
    queryTimes,
    code
  ];
}

class OtpVerifyCodeRequest extends Equatable{
  final String phoneNumber;
  final String code;

  const OtpVerifyCodeRequest({
    required this.phoneNumber,
    required this.code
  });

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'code': code
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw [
    phoneNumber,
    code
  ];
}

class OtpVerifyCodeResponse extends Equatable{
  final int pk;
  final String phoneNumber;
  final String token;

  const OtpVerifyCodeResponse({
    required this.pk,
    required this.phoneNumber,
    required this.token,
  });

  factory OtpVerifyCodeResponse.fromJson(Map<String, dynamic> json) {
    return OtpVerifyCodeResponse(
      pk: json['pk'],
      // firstName: json['first_name'],
      // lastName: json['last_name'],
      phoneNumber: json['phone_number'],
      // verificationStatus: json['verification_status'],
      token: json['token'],
      // nickName: json['nick_name'],
      // gender: json['gender'],
      // birthDate: json['birth_date'],
      // location: json['location']
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    pk,
    phoneNumber,
    token
  ];
}