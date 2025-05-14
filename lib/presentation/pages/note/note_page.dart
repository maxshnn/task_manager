import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager/core/di/dependency_injection.dart';
import 'package:task_manager/presentation/pages/note/bloc/note_bloc.dart';
import 'package:task_manager/presentation/pages/note/widget/note_card_widget.dart';
import 'package:task_manager/presentation/pages/note_detail/note_detail_page.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController _searchController = TextEditingController();
  bool isSelectMode = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injection<NoteBloc>()..add(GetAllNoteEvent()),
      child: BlocConsumer<NoteBloc, NoteState>(
        listener: (context, state) {
          setState(() {
            if (state.idsSelectedNotes.isEmpty) {
              isSelectMode = false;
            } else {
              isSelectMode = true;
            }
          });
        },
        builder: (context, state) {
          final selectedIds = state.idsSelectedNotes;

          return Scaffold(
            extendBody: true,
            appBar: AppBar(
              backgroundColor: const Color(0xFFB4D464),
              actions: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) => context.read<NoteBloc>().add(
                            SearchNoteEvent(query: value),
                          ),
                      decoration: const InputDecoration(
                        hintText: 'Искать заметки',
                        suffixIcon: Icon(
                          Icons.search,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            floatingActionButton: IconButton(
              onPressed: () {
                if (isSelectMode) {
                  context.read<NoteBloc>().add(DeleteNotesEvent());
                } else {
                  _pushToDetailPage(context);
                }
              },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  isSelectMode ? Colors.red : const Color(0xFFB4D464),
                ),
              ),
              iconSize: 35,
              icon: Icon(
                isSelectMode ? Icons.delete : Icons.add,
              ),
            ),
            body: Center(
              child: GestureDetector(
                  onTap: () {
                    if (isSelectMode) {
                      context.read<NoteBloc>().add(ResetSelectedEvent());
                    }
                  },
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: state.notes.length,
                    itemBuilder: (context, index) {
                      final note = state.notes[index];
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onLongPress: () {
                            context.read<NoteBloc>().add(
                                  SelectNoteEvent(id: note.id),
                                );
                          },
                          onTap: () => _onCardPressed(context, note.id),
                          child: NoteCardWidget(
                            title: note.title,
                            description: note.description,
                            createdAt: note.createdAt,
                            isSelected: selectedIds.contains(note.id),
                          ),
                        ),
                      );
                    },
                  )),
            ),
          );
        },
      ),
    );
  }

  void _pushToDetailPage(BuildContext context, {int? id}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<NoteBloc>(),
          child: NoteDetailPage(id: id),
        ),
      ),
    );
  }

  void _onCardPressed(BuildContext context, int id) {
    if (isSelectMode) {
      context.read<NoteBloc>().add(SelectNoteEvent(id: id));
    } else {
      _pushToDetailPage(context, id: id);
    }
  }
}
