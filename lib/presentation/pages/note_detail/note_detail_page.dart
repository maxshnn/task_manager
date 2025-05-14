import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/di/dependency_injection.dart';
import 'package:task_manager/presentation/pages/note/bloc/note_bloc.dart';
import 'package:task_manager/presentation/pages/note_detail/bloc/note_detail_bloc.dart';

class NoteDetailPage extends StatefulWidget {
  final int? id;
  const NoteDetailPage({super.key, this.id});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NoteDetailBloc(noteUseCase: injection())
        ..add(
          GetNoteEvent(id: widget.id),
        ),
      child: BlocConsumer<NoteDetailBloc, NoteDetailState>(
        listener: (context, state) {
          if (state is NoteDetailSuccess && state.note != null) {
            titleController.text = state.note!.title;
            descriptionController.text = state.note!.description;
          }
        },
        builder: (context, state) {
          if (state is NoteDetailLoading || state is NoteDetailInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NoteDetailFailed) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Произошла ошибка при загрузке заметки.',
                    style: TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<NoteDetailBloc>().add(
                            GetNoteEvent(id: widget.id),
                          );
                    },
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFFB4D464),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<NoteDetailBloc>().add(
                          SaveNoteEvent(
                            id: widget.id,
                            title: titleController.text,
                            description: descriptionController.text,
                          ),
                        );
                    context.read<NoteBloc>().add(GetAllNoteEvent());
                  },
                  icon: const Icon(Icons.save),
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: TextField(
                      controller: titleController,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Заголовок',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: TextField(
                        controller: descriptionController,
                        style: const TextStyle(fontSize: 16),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        expands: true,
                        decoration: const InputDecoration(
                          hintText: 'Заметка',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
