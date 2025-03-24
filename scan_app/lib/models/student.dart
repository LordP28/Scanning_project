import 'package:equatable/equatable.dart';

class Student extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String major;
  final String profilePicture;
  final bool hasAccess;

  const Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.major,
    required this.profilePicture,
    required this.hasAccess,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      major: json['major'],
      profilePicture: json['profilePicture'],
      hasAccess: json['hasAccess'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, firstName, lastName, major, profilePicture, hasAccess];
} 