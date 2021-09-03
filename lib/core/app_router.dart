import 'package:flutter/material.dart';
import 'package:xproject_app/screens/home_screen.dart';
import 'package:xproject_app/screens/otp_authentication_screen.dart';

class AppRouter {
  static const OtpRoute = '/otp';
  static const HomeScreenRoute = '/home';
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case OtpRoute:
        return MaterialPageRoute(
          builder: (_) => OtpAuthenticationPage(),
        );
      case HomeScreenRoute:
        return MaterialPageRoute(
          builder: (_) => HomeScreenPage(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
