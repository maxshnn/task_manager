part of 'note_detail_bloc.dart';

@immutable
sealed class NoteDetailEvent {}

class GetNoteEvent extends NoteDetailEvent {
  final int? id;

  GetNoteEvent({required this.id});
}

class SaveNoteEvent extends NoteDetailEvent {
  final int? id;
  final String title;
  final String description;

  SaveNoteEvent({
    required this.id,
    required this.title,
    required this.description,
  });
}
