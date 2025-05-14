part of 'note_bloc.dart';

sealed class Status {}

class InitializeStatus extends Status {}

class LoadingStatus extends Status {}

class FailedStatus extends Status {
  final Exception? error;
  final String? message;

  FailedStatus({this.error, this.message});
}

class SuccessStatus extends Status {}

@immutable
class NoteState extends Equatable {
  final List<NoteModel> notes;
  final List<int> idsSelectedNotes;
  final Status status;

  const NoteState({
    this.notes = const [],
    this.idsSelectedNotes = const [],
    required this.status,
  });

  @override
  List<Object> get props => [notes, idsSelectedNotes, status];

  NoteState copyWith({
    List<NoteModel>? notes,
    List<int>? idsSelectedNotes,
    Status? status,
  }) {
    return NoteState(
      notes: notes ?? this.notes,
      idsSelectedNotes: idsSelectedNotes ?? this.idsSelectedNotes,
      status: status ?? this.status,
    );
  }
}
