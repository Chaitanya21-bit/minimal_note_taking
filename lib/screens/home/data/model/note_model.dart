import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 0)
class NoteModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final bool isPinned;

  const NoteModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isPinned,
  });

  NoteModel copyWith({
    String? id,
    String? name,
    String? description,
    bool? isPinned,
  }) {
    return NoteModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}
