abstract class PedometerService {
  Future<int> getPedometerSteps();
}

class MockPedometerService extends PedometerService{
  Future<int> getPedometerSteps() async {
    return 100;
  }
}