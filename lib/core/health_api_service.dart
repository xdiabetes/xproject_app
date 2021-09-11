import 'package:health/health.dart';

abstract class HealthApiService {
  Future<bool> requestHealthPermission();
  Future<int> getSteps(DateTime fromDate);
}

class HealthApiServiceImpl extends HealthApiService {
  HealthFactory health;

  HealthApiServiceImpl({
    required this.health
  });

  // define the types to get
  static const List<HealthDataType> types = [
    HealthDataType.STEPS,
  ];

  @override
  Future<bool> requestHealthPermission() async {
    return await health.requestAuthorization(types);
  }


  @override
  Future<int> getSteps(DateTime fromDate) async {
    // get everything from midnight until now
    DateTime endDate = DateTime.now();



    // setState(() => _state = AppState.FETCHING_DATA);

    int steps = 0;
    List<HealthDataPoint> _healthDataList = [];

    try {
      // fetch new data
      List<HealthDataPoint> healthData =
      await health.getHealthDataFromTypes(fromDate, endDate, types);

      // save all the new data points
      _healthDataList.addAll(healthData);
    } catch (e) {
      print("Caught exception in getHealthDataFromTypes: $e");
    }

    // filter out duplicates
    _healthDataList = HealthFactory.removeDuplicates(_healthDataList);

    // print the results
    _healthDataList.forEach((x) {
      if(x.type == HealthDataType.STEPS) {
        print("Data point: $x");
        steps += x.value.round();
      }
    });

    print("Steps: $steps");

    // update the UI to display the results
    // setState(() {
    //   _state =
    //   _healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
    // });


    return steps;
  }

}