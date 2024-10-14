import 'package:uuid/uuid.dart';

class StudentModel {
  final String _sId;
  String name;
  String email;
  String phone;
  String section;
  List<String> courseName;

  // Constructor: _sId will be auto-generated if not provided
  StudentModel(String? sId, this.name, this.email, this.phone, this.section,
      this.courseName)
      : _sId = sId ?? Uuid().v4();

  // Getter for _sId (optional if you need access to the id)
  String get sId => _sId;
}

class NewStudent extends StudentModel {
  static num discount = 5; // Remove @override because discount is static
  NewStudent(
    String? sId, // sId can be nullable
    String name,
    String email,
    String phone,
    String section,
    List<String> courseName,
  ) : super(sId, name, email, phone, section,
            courseName); // Use super to pass parameters
}

class PremiumStudent extends StudentModel {
  static num discount = 10; // Remove @override because discount is static
  PremiumStudent(
    String? sId,
    String name,
    String email,
    String phone,
    String section,
    List<String> courseName, // Fixed: courseName instead of courseId
  ) : super(sId, name, email, phone, section,
            courseName); // Use super to pass parameters
}

class PlatinumStudent extends StudentModel {
  static num discount = 15; // Remove @override because discount is static
  PlatinumStudent(
    String? sId,
    String name,
    String email,
    String phone,
    String section,
    List<String> courseName,
  ) : super(sId, name, email, phone, section,
            courseName); // Use super to pass parameters
}
