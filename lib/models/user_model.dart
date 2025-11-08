enum UserRole { student, teacher }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? photoUrl;
  final String? department;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.photoUrl,
    this.department,
  });
}
