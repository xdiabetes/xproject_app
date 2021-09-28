abstract class PedometerService {
  Future<int> getPedometerSteps();
  String getPedestrianStatus();
}

class MockPedometerService extends PedometerService {
  Future<int> getPedometerSteps() async {
    return 100;
  }

  String getPedestrianStatus() {
    return "walking";
  }
}