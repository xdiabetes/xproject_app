import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:xproject_app/blocs/authentication/authentication_bloc.dart';
import 'package:xproject_app/blocs/otp/otp_bloc.dart';
import 'package:xproject_app/core/app_router.dart';
import 'package:xproject_app/injection_container.dart' as di;
import 'package:xproject_app/injection_container.dart';
import 'package:xproject_app/screens/home_screen.dart';
import 'package:xproject_app/screens/otp_authentication_screen.dart';
import 'package:xproject_app/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: AppRouter.generateRoute,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (BuildContext context) =>
                sl<AuthenticationBloc>()..add(AppStartedEvent()),
          ),
          BlocProvider<OtpBloc>(
            create: (BuildContext context) =>
            sl<OtpBloc>(),
          ),
        ],
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationAuthenticated) {
              return HomeScreenPage();
            } else if (state is AuthenticationUnauthenticated) {
              return OtpAuthenticationPage();
            } else {
              return SplashScreen();
            }
          },
        ),
      ),
    );
  }
}
