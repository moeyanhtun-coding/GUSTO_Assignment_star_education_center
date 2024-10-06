import 'package:uuid/uuid.dart';

class StudentModel {
  final String _sId;
  String name;
  String email;
  String phone;
  String section;
  List<String> courseId;

  StudentModel(String? sId, this.name, this.email, this.phone, this.section,
      this.courseId)
      : _sId = sId ?? Uuid().v4();

  String get studentId => _sId;
}

class NewStudent extends StudentModel {
  @override
  static num discount = 5;
  NewStudent(
    super.sId,
    super.name,
    super.email,
    super.phone,
    super.section,
    super.courseId,
  );
}

class PremiumStudent extends StudentModel {
  @override
  static num discount = 10;
  PremiumStudent(
    super.sId,
    super.name,
    super.email,
    super.phone,
    super.section,
    super.courseId,
  );
}

class PlatinumStudent extends StudentModel {
  @override
  static num discount = 10;
  PlatinumStudent(
    super.sId,
    super.name,
    super.email,
    super.phone,
    super.section,
    super.courseId,
  );
}
