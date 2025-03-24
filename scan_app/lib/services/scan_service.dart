import 'dart:io';
import 'package:google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import '../models/document.dart';

class ScanService {
  final _textRecognizer = TextRecognizer();
  final _imagePicker = ImagePicker();

  Future<Document> scanDocument() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (image == null) {
        throw Exception('Aucune image sélectionnée');
      }

      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      final directory = await getApplicationDocumentsDirectory();
      final fileName = '${const Uuid().v4()}.jpg';
      final savedPath = path.join(directory.path, fileName);

      await File(image.path).copy(savedPath);

      return Document(
        id: const Uuid().v4(),
        name: path.basename(image.path),
        path: savedPath,
        createdAt: DateTime.now(),
        text: recognizedText.text,
        type: 'image',
      );
    } catch (e) {
      throw Exception('Erreur lors du scan: $e');
    }
  }

  Future<String> extractText(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);
      return recognizedText.text;
    } catch (e) {
      throw Exception('Erreur lors de l\'extraction du texte: $e');
    }
  }

  Future<void> dispose() async {
    await _textRecognizer.close();
  }
} 