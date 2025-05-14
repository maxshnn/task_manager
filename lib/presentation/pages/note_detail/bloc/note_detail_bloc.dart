import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/domain/models/note_model.dart';
import 'package:task_manager/domain/use_cases/note_use_case.dart';

part 'note_detail_event.dart';
part 'note_detail_state.dart';

class NoteDetailBloc extends Bloc<NoteDetailEvent, NoteDetailState> {
  final NoteUseCase _noteUseCase;
  NoteDetailBloc({required NoteUseCase noteUseCase})
      : _noteUseCase = noteUseCase,
        super(NoteDetailInitial()) {
    on<GetNoteEvent>(_onGetNoteEvent);
    on<SaveNoteEvent>(_onSaveNoteEvent);
  }

  Future<void> _onGetNoteEvent(GetNoteEvent event, Emitter emit) async {
    if (event.id != null) {
      final note = await _noteUseCase.getById(event.id!);
      emit(NoteDetailSuccess(note: note));
    } else {
      emit(NoteDetailSuccess());
    }
  }

  Future<void> _onSaveNoteEvent(SaveNoteEvent event, Emitter emit) async {
    if (state is NoteDetailSuccess) {
      final currentState = state as NoteDetailSuccess;
      if (currentState.note == null) {
        final id = await _noteUseCase.create(
          title: event.title,
          description: event.description,
        );
        final note = await _noteUseCase.getById(id);
        if (note != null) {
          emit(currentState.copyWith(note: note));
        }
      } else {
        final note = currentState.note!;
        final updatedNote =
            note.copyWith(title: event.title, description: note.description);
        await _noteUseCase.update(
          id: updatedNote.id,
          title: updatedNote.title,
          description: updatedNote.description,
        );
        emit(currentState.copyWith(note: updatedNote));
      }
    }
  }
}
