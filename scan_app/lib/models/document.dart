import 'package:equatable/equatable.dart';

class Document extends Equatable {
  final String id;
  final String name;
  final String path;
  final DateTime createdAt;
  final String? text;
  final String type; // 'pdf' ou 'image'

  const Document({
    required this.id,
    required this.name,
    required this.path,
    required this.createdAt,
    this.text,
    required this.type,
  });

  @override
  List<Object?> get props => [id, name, path, createdAt, text, type];

  Document copyWith({
    String? id,
    String? name,
    String? path,
    DateTime? createdAt,
    String? text,
    String? type,
  }) {
    return Document(
      id: id ?? this.id,
      name: name ?? this.name,
      path: path ?? this.path,
      createdAt: createdAt ?? this.createdAt,
      text: text ?? this.text,
      type: type ?? this.type,
    );
  }
} 