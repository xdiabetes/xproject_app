import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xproject_app/blocs/authentication/authentication_bloc.dart';
import 'package:xproject_app/blocs/otp/otp_bloc.dart';
import 'package:xproject_app/blocs/walking_tracker/walking_tracker_bloc.dart';
import 'package:xproject_app/blocs/walking_tracker_session_server_log/walking_tracker_session_server_log_bloc.dart';
import 'package:xproject_app/core/device_location/device_location_service.dart';
import 'package:xproject_app/core/device_location/golocator_lib.dart';
import 'package:xproject_app/core/google_fit/health_api_service.dart';
import 'package:xproject_app/core/google_fit/health_api_service_impl.dart';
import 'package:xproject_app/core/pedometer/pedometer_service.dart';
import 'package:xproject_app/core/pedometer/pedometer_service_impl.dart';
import 'package:xproject_app/core/user_context.dart';
import 'package:xproject_app/repositories/otp_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // core
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<UserContext>(
      () => UserContextImpl(sharedPreferences: sl()));

  sl.registerLazySingleton<DeviceLocationService>(() => DeviceLocationServiceGeolocatorLibImpl());

  // sl.registerFactory(() => HealthFactory());
  sl.registerLazySingleton<HealthApiService>(() => HealthApiServiceImpl());

  final pedometerService = await PedometerServiceImpl.getInstance();
  sl.registerLazySingleton<PedometerService>(() => pedometerService);

  sl.registerLazySingleton<AuthenticationBloc>(
      () => AuthenticationBloc(userContext: sl()));
  sl.registerLazySingleton<OtpRepository>(() => OtpRepositoryImpl());

  sl.registerLazySingleton<OtpBloc>(() => OtpBloc(
    otpRepository: sl(),
    userContext: sl()
  ));
  sl.registerLazySingleton<WalkingTrackerBloc>(() => WalkingTrackerBloc());
  sl.registerLazySingleton<WalkingTrackerSessionServerLogBloc>(
          () => WalkingTrackerSessionServerLogBloc());
}
