import 'package:uuid/uuid.dart';

class StudentModel {
  final String _sId;
  String name;
  String email;
  String phone;
  String section;
  List<String> courseName;

  StudentModel(String? sId, this.name, this.email, this.phone, this.section,
      this.courseName)
      : _sId = sId ?? Uuid().v4();
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
    super.courseName,
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
    super.courseName,
  );
}
