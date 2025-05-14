import 'package:isar/isar.dart';

part 'note_collection.g.dart';

@collection
class NoteCollection {
  Id id = Isar.autoIncrement;

  String? title;

  String? description;

  DateTime? createdAt;

  DateTime? updatedAt;
}
