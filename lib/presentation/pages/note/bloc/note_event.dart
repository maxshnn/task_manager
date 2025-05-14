part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {}

class GetAllNoteEvent extends NoteEvent {}

class SearchNoteEvent extends NoteEvent {
  final String query;
  SearchNoteEvent({required this.query});
}

class SelectNoteEvent extends NoteEvent {
  final int id;
  SelectNoteEvent({required this.id});
}

class ResetSelectedEvent extends NoteEvent {}

class DeleteNotesEvent extends NoteEvent {}
