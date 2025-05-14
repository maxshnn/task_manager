import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:task_manager/domain/models/note_model.dart';
import 'package:task_manager/domain/use_cases/note_use_case.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteUseCase _noteUseCase;
  NoteBloc({required NoteUseCase noteUseCase})
      : _noteUseCase = noteUseCase,
        super(NoteState(status: InitializeStatus())) {
    on<GetAllNoteEvent>(_onGetAllNoteEvent);
    on<SearchNoteEvent>(_onSearchNoteEvent);
    on<SelectNoteEvent>(_onSelectNoteEvent);
    on<DeleteNotesEvent>(_onDeleteNotesEvent);
    on<ResetSelectedEvent>(_onResetSelectedEvent);
  }

  Future<void> _onGetAllNoteEvent(GetAllNoteEvent event, Emitter emit) async {
    emit(
      state.copyWith(status: LoadingStatus()),
    );
    final notes = await _noteUseCase.getAll();
    emit(
      state.copyWith(
        notes: notes,
        status: SuccessStatus(),
      ),
    );
  }

  Future<void> _onSearchNoteEvent(SearchNoteEvent event, Emitter emit) async {
    if (event.query.isEmpty) return;

    emit(
      state.copyWith(status: LoadingStatus()),
    );
    final notes = await _noteUseCase.search(event.query);
    emit(
      state.copyWith(
        notes: notes,
        status: SuccessStatus(),
      ),
    );
  }

  Future<void> _onSelectNoteEvent(SelectNoteEvent event, Emitter emit) async {
    final isSelected = state.idsSelectedNotes.contains(event.id);
    final currentIds = state.idsSelectedNotes;
    if (isSelected) {
      final ids = currentIds.where((id) => id != event.id).toList();
      emit(state.copyWith(idsSelectedNotes: ids));
    } else {
      emit(state.copyWith(idsSelectedNotes: [...currentIds, event.id]));
    }
  }

  Future<void> _onDeleteNotesEvent(DeleteNotesEvent event, Emitter emit) async {
    final currentSelectedIds = state.idsSelectedNotes;
    final updatedNotes = state.notes
        .where(
          (note) => !currentSelectedIds.contains(note.id),
        )
        .toList();
    await _noteUseCase.deleteByIds(ids: currentSelectedIds);
    emit(state.copyWith(
      idsSelectedNotes: [],
      notes: updatedNotes,
    ));
  }

  Future<void> _onResetSelectedEvent(
    ResetSelectedEvent event,
    Emitter emit,
  ) async {
    emit(state.copyWith(idsSelectedNotes: []));
  }
}
