import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:task_manager/data/datasource/local/database/collection/note_collection.dart';

class NoteDatabase {
  Isar? _isar;

  Future<Isar> _init() async {
    final dir = await getApplicationDocumentsDirectory();
    return await Isar.open(
      [NoteCollectionSchema],
      directory: dir.path,
    );
  }

  Future<Isar> get _db async {
    _isar ??= await _init();
    return _isar!;
  }

  Future<List<NoteCollection>> getAll() async {
    return (await _db).noteCollections.where().sortByCreatedAtDesc().findAll();
  }

  Future<NoteCollection?> getById(int id) async {
    return (await _db).noteCollections.get(id);
  }

  Future<List<NoteCollection>> search(String query) async {
    return (await _db)
        .noteCollections
        .filter()
        .group((q) => q
            .titleContains(query, caseSensitive: false)
            .or()
            .descriptionContains(query, caseSensitive: false))
        .sortByCreatedAtDesc()
        .findAll();
  }

  Future<int> create({
    required String title,
    required String description,
  }) async {
    final now = DateTime.now();
    final note = NoteCollection()
      ..title = title
      ..description = description
      ..createdAt = now
      ..updatedAt = now;

    return (await _db)
        .writeTxn(() async => (await _db).noteCollections.put(note));
  }

  Future<void> update({
    required int id,
    required String title,
    required String description,
  }) async {
    final note = await (await _db).noteCollections.get(id);

    if (note != null) {
      note.title = title;
      note.description = description;
      note.updatedAt = DateTime.now();
      (await _db).writeTxn(() async => (await _db).noteCollections.put(note));
    }
  }

  Future<void> deleteByIds({required List<Id> ids}) async {
    if (ids.isEmpty) return;
    (await _db)
        .writeTxn(() async => (await _db).noteCollections.deleteAll(ids));
  }
}
