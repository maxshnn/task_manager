import 'package:get_it/get_it.dart';
import 'package:task_manager/data/datasource/local/database/note_database.dart';
import 'package:task_manager/data/repositories/note_repository_impl.dart';
import 'package:task_manager/domain/repositories/note_repository.dart';
import 'package:task_manager/domain/use_cases/note_use_case.dart';
import 'package:task_manager/presentation/pages/note/bloc/note_bloc.dart';

final injection = GetIt.instance;

void setup() async {
  injection
    ..registerSingleton<NoteDatabase>(NoteDatabase())
    ..registerLazySingleton<NoteRepository>(
      () => NoteRepositoryImpl(
        noteDatabase: injection(),
      ),
    )
    ..registerLazySingleton<NoteUseCase>(
      () => NoteUseCase(
        noteRepository: injection(),
      ),
    )
    ..registerLazySingleton<NoteBloc>(
      () => NoteBloc(
        noteUseCase: injection(),
      ),
    );
}
