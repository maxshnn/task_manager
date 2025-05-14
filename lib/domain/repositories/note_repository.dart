import 'package:task_manager/domain/models/note_model.dart';

abstract class NoteRepository {
  Future<List<NoteModel>> getAll();

  Future<NoteModel?> getById(int id);

  Future<List<NoteModel>> search(String query);

  Future<int> create({required String title, required String description});

  Future<void> update({
    required int id,
    required String title,
    required String description,
  });

  Future<void> deleteByIds({required List<int> ids});
}
