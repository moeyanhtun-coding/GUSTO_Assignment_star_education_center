class AttendenceModel {
  final String _aId;
  DateTime attendenceDate;
  List<String> StudentIdList;
  String courseId;

  AttendenceModel(
    this._aId,
    this.StudentIdList,
    this.attendenceDate,
    this.courseId,
  );

  String get attendenceId => _aId;
}
