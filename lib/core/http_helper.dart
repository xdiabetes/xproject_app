import 'dart:io';

import 'package:http/http.dart';

class HttpHelper {
  static const apiUrl = 'https://xapp.alimahdiyar.ir/';
  static bool isTypicalHttpSuccess(int statusCode){
    return statusCode == HttpStatus.ok
          || statusCode == HttpStatus.created
          || statusCode == HttpStatus.noContent;
  }
}

class ServerException {
  final String? message;
  final Response? response;

  const ServerException({
    this.message,
    this.response,
  });

  @override
  String toString() {
    return response != null ? response!.body : (message != null ? message! : 'Unknown Server Exception');
  }
}
