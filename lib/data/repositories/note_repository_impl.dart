import 'package:task_manager/data/datasource/local/database/note_database.dart';
import 'package:task_manager/data/mapper/note_mapper.dart';
import 'package:task_manager/domain/models/note_model.dart';
import 'package:task_manager/domain/repositories/note_repository.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteDatabase _noteDatabase;

  NoteRepositoryImpl({required NoteDatabase noteDatabase})
      : _noteDatabase = noteDatabase;

  @override
  Future<int> create({
    required String title,
    required String description,
  }) async {
    return await _noteDatabase.create(title: title, description: description);
  }

  @override
  Future<void> deleteByIds({required List<int> ids}) async {
    await _noteDatabase.deleteByIds(ids: ids);
  }

  @override
  Future<List<NoteModel>> getAll() async {
    final noteCollections = await _noteDatabase.getAll();
    return NoteMapper.fromCollectionListToModelList(noteCollections);
  }

  @override
  Future<NoteModel?> getById(int id) async {
    final noteCollection = await _noteDatabase.getById(id);
    if (noteCollection == null) return null;

    return NoteMapper.fromCollectionToModel(noteCollection);
  }

  @override
  Future<List<NoteModel>> search(String query) async {
    final noteCollections = await _noteDatabase.search(query);
    return NoteMapper.fromCollectionListToModelList(noteCollections);
  }

  @override
  Future<void> update({
    required int id,
    required String title,
    required String description,
  }) async {
    return await _noteDatabase.update(
      id: id,
      title: title,
      description: description,
    );
  }
}
