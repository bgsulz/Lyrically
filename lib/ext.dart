extension CaseIndependentEquality on String {
  bool equalsIgnoreCase(String other) => toLowerCase() == other.toLowerCase();
}

extension FromYMD on String {
  DateTime fromYMD() {
    int year = int.parse(substring(0, 4));
    int month = int.parse(substring(4, 6));
    int day = int.parse(substring(6));
    return DateTime(year, month, day);
  }
}

extension ToYMD on DateTime {
  String toYMD() {
    return "${year.toString().padLeft(4, '0')}${month.toString().padLeft(2, '0')}${day.toString().padLeft(2, '0')}";
  }
}
