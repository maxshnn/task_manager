import 'package:task_manager/data/datasource/local/database/collection/note_collection.dart';
import 'package:task_manager/domain/models/note_model.dart';

class NoteMapper {
  static NoteModel fromCollectionToModel(NoteCollection collection) {
    assert(
      collection.title != null &&
          collection.description != null &&
          collection.createdAt != null &&
          collection.updatedAt != null,
      'NoteCollection содержит null в обязательных полях',
    );
    return NoteModel(
      id: collection.id,
      title: collection.title!,
      description: collection.description!,
      createdAt: collection.createdAt!,
      updatedAt: collection.updatedAt!,
    );
  }

  static List<NoteModel> fromCollectionListToModelList(
    List<NoteCollection> collection,
  ) {
    return collection.map(fromCollectionToModel).toList();
  }
}
