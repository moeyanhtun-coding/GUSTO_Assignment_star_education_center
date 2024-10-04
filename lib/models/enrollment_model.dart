class EnrollmentModel {
  final String _eId;
  DateTime enrollDate;
  num discount;
  double totalFee;

  String studentId;
  String courseId;

  EnrollmentModel(
    this._eId,
    this.discount,
    this.enrollDate,
    this.studentId,
    this.courseId,
    this.totalFee,
  );

  String get enrollId => _eId;
}
