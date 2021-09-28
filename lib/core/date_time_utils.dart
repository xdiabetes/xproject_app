class DateTimeUtils {
  static DateTime? dateTimeFromJsonOrNull(String? stringFromJson){
    if(stringFromJson == null) {
      return null;
    }
    return DateTime.tryParse(stringFromJson);
  }

  static DateTime dateTimeFromJson(String stringFromJson){
    return DateTime.parse(stringFromJson);
  }

  static String dateTimeToJson(DateTime dateTime){
    return dateTime.toIso8601String();
  }

  static String? dateTimeToJsonOrNull(DateTime? dateTime){
    if(dateTime == null) {
      return null;
    }
    return dateTime.toIso8601String();
  }
}