abstract class HealthApiService {
  const HealthApiService();
  Future<bool> requestHealthPermission();
  Future<int> getSteps(DateTime fromDate);
}

class MockHealthApiService extends HealthApiService {
  Future<bool> requestHealthPermission() async {
    return true;
  }
  Future<int> getSteps(DateTime fromDate) async {
    return 100;
  }
}