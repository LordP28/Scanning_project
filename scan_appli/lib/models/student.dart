class Student {
  final String studentId;
  final String firstName;
  final String lastName;
  final String major;
  final String? profilePicture;
  final String? qrCode;

  Student({
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.major,
    this.profilePicture,
    this.qrCode,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    // Construire l'URL complète de l'image de profil
    String? profilePictureUrl;
    if (json['profile_picture'] != null) {
      // Supprimer le préfixe /uploads/ s'il existe déjà
      String imagePath = json['profile_picture'].toString();
      if (imagePath.startsWith('/uploads/')) {
        imagePath = imagePath.substring(8); // Supprimer les 8 premiers caractères (/uploads/)
      }
      profilePictureUrl = 'http://localhost:3000/uploads/$imagePath';
    }

    return Student(
      studentId: json['student_id']?.toString() ?? '',
      firstName: json['first_name']?.toString() ?? '',
      lastName: json['last_name']?.toString() ?? '',
      major: json['major']?.toString() ?? '',
      profilePicture: profilePictureUrl,
      qrCode: json['qr_code']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'first_name': firstName,
      'last_name': lastName,
      'major': major,
      'profile_picture': profilePicture,
      'qr_code': qrCode,
    };
  }
} 