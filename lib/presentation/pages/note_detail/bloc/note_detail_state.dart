// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'note_detail_bloc.dart';

@immutable
sealed class NoteDetailState {}

class NoteDetailInitial extends NoteDetailState {}

class NoteDetailLoading extends NoteDetailState {}

class NoteDetailSuccess extends NoteDetailState with EquatableMixin {
  final NoteModel? note;

  NoteDetailSuccess({this.note});

  @override
  List<Object?> get props => [note];

  NoteDetailSuccess copyWith({
    NoteModel? note,
  }) {
    return NoteDetailSuccess(
      note: note ?? this.note,
    );
  }
}

class NoteDetailFailed extends NoteDetailState {}
