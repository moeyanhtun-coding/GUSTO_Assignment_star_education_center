class CourseModel {
  final String _cId;
  String courseName;
  double fees;

  CourseModel(this._cId, this.courseName, this.fees);

  String get courseId => _cId;
}
