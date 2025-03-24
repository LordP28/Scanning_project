import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:scan_appli/models/student.dart';
import 'dart:io';
import 'dart:async';

class ApiService {
  // Utiliser localhost pour le développement
  static const String baseUrl = 'http://localhost:3000';
  // Pour le déploiement, utiliser l'adresse IP du serveur
  // static const String baseUrl = 'http://172.29.12.11:3000';

  static Future<Student> verifyStudent(String studentId) async {
    try {
      print('Tentative de vérification de l\'étudiant avec l\'ID: $studentId');
      print('URL de la requête: $baseUrl/api/students/$studentId');
      
      final response = await http.get(
        Uri.parse('$baseUrl/api/students/$studentId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 30), // Augmenter le timeout à 30 secondes
        onTimeout: () {
          throw TimeoutException('La requête a expiré après 30 secondes');
        },
      );
      
      print('Code de statut de la réponse: ${response.statusCode}');
      print('Headers de la réponse: ${response.headers}');
      print('Corps de la réponse: ${response.body}');
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Student.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('Étudiant non trouvé');
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      print('Erreur de connexion: ${e.message}');
      print('OS Error: ${e.osError}');
      throw Exception('Impossible de se connecter au serveur. Vérifiez votre connexion internet.');
    } on TimeoutException catch (e) {
      print('Timeout: ${e.message}');
      throw Exception('Le serveur met trop de temps à répondre. Veuillez réessayer.');
    } catch (e) {
      print('Erreur détaillée: $e');
      throw Exception('Une erreur est survenue: ${e.toString()}');
    }
  }
} 