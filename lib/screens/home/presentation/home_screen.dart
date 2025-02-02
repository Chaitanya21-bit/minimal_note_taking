import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimal_note/screens/home/bloc/note_bloc.dart';
import 'package:minimal_note/screens/home/data/model/note_model.dart';
import 'package:minimal_note/screens/home/presentation/component/add_or_update_note_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is NoteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NoteLoaded) {
            return ListView.builder(
              itemCount: state.noteList.length,
              itemBuilder: (context, index) {
                // Sort the list: Pinned notes first
                final sortedNotes = List<NoteModel>.from(state.noteList)
                  ..sort(
                    (a, b) =>
                        b.isPinned.toString().compareTo(a.isPinned.toString()),
                  );

                final note = sortedNotes[index];

                return Dismissible(
                  key: Key(note.id),
                  background: Container(
                    decoration: BoxDecoration(
                      color: Colors.red.shade400,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    alignment: Alignment.centerRight,
                    child: const Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text('Delete Note'),
                          content: const Text(
                            'Are you sure you want to delete this note?',
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) {
                    context.read<NoteBloc>().add(DeleteNote(noteId: note.id));
                  },
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddOrUpdateDialog(note: note),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).cardColor,
                                Theme.of(context)
                                    .cardColor
                                    .withValues(alpha: 0.95),
                              ],
                            ),
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.2),
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Text(
                                note.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  letterSpacing: 0.2,
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.color,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              note.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.4,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.color
                                    ?.withValues(alpha: 0.8),
                              ),
                            ),
                            leading: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                icon: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  transitionBuilder: (
                                    Widget child,
                                    Animation<double> animation,
                                  ) {
                                    return RotationTransition(
                                      turns: animation,
                                      child: FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: Icon(
                                    note.isPinned
                                        ? Icons.push_pin
                                        : Icons.push_pin_outlined,
                                    key: ValueKey<bool>(note.isPinned),
                                    color: note.isPinned
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.grey.withValues(alpha: 0.6),
                                    size: 24,
                                  ),
                                ),
                                onPressed: () {
                                  final updatedNote =
                                      note.copyWith(isPinned: !note.isPinned);
                                  context
                                      .read<NoteBloc>()
                                      .add(UpdateNotes(noteModel: updatedNote));
                                },
                                splashRadius: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is NoteError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddOrUpdateDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
