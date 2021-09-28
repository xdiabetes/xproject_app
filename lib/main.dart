import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:xproject_app/blocs/authentication/authentication_bloc.dart';
import 'package:xproject_app/blocs/otp/otp_bloc.dart';
import 'package:xproject_app/blocs/walking_tracker/walking_tracker_bloc.dart';
import 'package:xproject_app/blocs/walking_tracker_session_server_log/walking_tracker_session_server_log_bloc.dart';
import 'package:xproject_app/core/app_router.dart';
import 'package:xproject_app/core/http_helper.dart';
import 'package:xproject_app/injection_container.dart' as di;
import 'package:xproject_app/injection_container.dart';
import 'package:xproject_app/screens/home_screen.dart';
import 'package:xproject_app/screens/otp_authentication_screen.dart';
import 'package:xproject_app/screens/splash_screen.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // To load the .env file contents into dotenv.
  // NOTE: fileName defaults to .env and can be omitted in this case.
  // Ensure that the filename corresponds to the path in step 1 and 2.
  await dotenv.load(fileName: ".env");
  HttpHelper.apiUrl = dotenv.get("API_URL");
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
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
          BlocProvider<WalkingTrackerBloc>(
            create: (BuildContext context) =>
                sl<WalkingTrackerBloc>(),
          ),
          BlocProvider<WalkingTrackerSessionServerLogBloc>(
            create: (BuildContext context) =>
                sl<WalkingTrackerSessionServerLogBloc>(),
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
