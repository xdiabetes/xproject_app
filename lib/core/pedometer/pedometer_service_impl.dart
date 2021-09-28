import 'package:pedometer/pedometer.dart';
import 'package:xproject_app/core/pedometer/pedometer_service.dart';

class PedometerServiceImpl extends PedometerService {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  int _steps = 0;

  @override
  Future<int> getPedometerSteps() async {
    return _steps;
  }

  void onStepCount(StepCount event) {
    /// Handle step count changed
    _steps = event.steps;
    // DateTime timeStamp = event.timeStamp;
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    /// Handle status changed
    String status = event.status;
    DateTime timeStamp = event.timeStamp;
  }

  void onPedestrianStatusError(error) {
    /// Handle the error
  }

  void onStepCountError(error) {
    /// Handle the error
  }

  Future<void> initPlatformState() async {
    /// Init streams
    _pedestrianStatusStream = await Pedometer.pedestrianStatusStream;
    _stepCountStream = await Pedometer.stepCountStream;

    /// Listen to streams and handle errors
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

  }

  // singleton
  PedometerServiceImpl._internal();
  static PedometerServiceImpl? instance;
  static Future<PedometerServiceImpl> getInstance() async {
    if(instance != null) {
      return instance!;
    }
    instance = PedometerServiceImpl._internal();
    await instance!.initPlatformState();
    return instance!;
  }
}