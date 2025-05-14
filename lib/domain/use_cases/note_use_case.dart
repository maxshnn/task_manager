import 'package:task_manager/domain/helper/error_parser.dart';
import 'package:task_manager/domain/models/note_model.dart';
import 'package:task_manager/domain/repositories/note_repository.dart';

class NoteUseCase {
  final NoteRepository _noteRepository;
  List<NoteModel> _notes = const [];

  NoteUseCase({required NoteRepository noteRepository})
      : _noteRepository = noteRepository;

  Future<int> create({
    required String title,
    required String description,
  }) async {
    try {
      final id =
          await _noteRepository.create(title: title, description: description);
      final note = await _noteRepository.getById(id);
      if (note != null) {
        _notes.insert(0, note);
      }
      return id;
    } catch (e) {
      throw ErrorParser.parse(e);
    }
  }

  Future<void> deleteByIds({required List<int> ids}) async {
    try {
      await _noteRepository.deleteByIds(ids: ids);
      _notes.removeWhere((note) => ids.contains(note.id));
    } catch (e) {
      throw ErrorParser.parse(e);
    }
  }

  Future<List<NoteModel>> getAll() async {
    try {
      _notes = await _noteRepository.getAll();
      return _notes;
    } catch (e) {
      throw ErrorParser.parse(e);
    }
  }

  Future<NoteModel?> getById(int id) async {
    try {
      return await _noteRepository.getById(id);
    } catch (e) {
      throw ErrorParser.parse(e);
    }
  }

  Future<List<NoteModel>> search(String query) async {
    try {
      return await _noteRepository.search(query);
    } catch (e) {
      throw ErrorParser.parse(e);
    }
  }

  Future<void> update({
    required int id,
    required String title,
    required String description,
  }) async {
    try {
      await _noteRepository.update(
        id: id,
        title: title,
        description: description,
      );
      _notes = await _noteRepository.getAll();
    } catch (e) {
      throw ErrorParser.parse(e);
    }
  }
}
