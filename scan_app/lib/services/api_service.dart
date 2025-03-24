import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/student.dart';

class ApiService {
  static const String baseUrl = 'http://your-backend-url/api'; // À remplacer par l'URL de votre backend

  Future<Student?> verifyStudentAccess(String qrCode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verify-access'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'qrCode': qrCode}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Student.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la vérification: $e');
    }
  }
} 