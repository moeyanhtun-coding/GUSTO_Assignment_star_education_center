class CourseModel {
  final String _cId;
  String courseName;
  String courseDuration;
  double fees;

  CourseModel(this._cId, this.courseName, this.fees, this.courseDuration);

  String get courseId => _cId;
}
