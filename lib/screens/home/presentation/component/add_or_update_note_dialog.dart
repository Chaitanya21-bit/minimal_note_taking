import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minimal_note/screens/home/bloc/note_bloc.dart';
import 'package:minimal_note/screens/home/data/model/note_model.dart';

class AddOrUpdateDialog extends StatefulWidget {
  final NoteModel? note;
  const AddOrUpdateDialog({super.key, this.note});

  @override
  AddOrUpdateDialogState createState() => AddOrUpdateDialogState();
}

class AddOrUpdateDialogState extends State<AddOrUpdateDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _nameHasError = false;
  bool _descriptionHasError = false;

  @override
  void initState() {
    if (widget.note != null) {
      _nameController.text = widget.note!.name;
      _descriptionController.text = widget.note!.description;
    }
    super.initState();
  }

  bool _validateInputs() {
    setState(() {
      _nameHasError = _nameController.text.trim().isEmpty;
      _descriptionHasError = _descriptionController.text.trim().isEmpty;
    });
    return !_nameHasError && !_descriptionHasError;
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isEditing ? Icons.edit : Icons.add,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  isEditing ? 'Edit Note' : 'Add Note',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              onChanged: (_) {
                if (_nameHasError) {
                  setState(() => _nameHasError = false);
                }
              },
              decoration: InputDecoration(
                labelText: 'Note Title *',
                errorText: _nameHasError ? 'Title is required' : null,
                prefixIcon: Icon(
                  Icons.title,
                  color: _nameHasError
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.error,
                  ),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              onChanged: (_) {
                if (_descriptionHasError) {
                  setState(() => _descriptionHasError = false);
                }
              },
              decoration: InputDecoration(
                labelText: 'Description *',
                errorText:
                    _descriptionHasError ? 'Description is required' : null,
                alignLabelWithHint: true,
                prefixIcon: Icon(
                  Icons.description,
                  color: _descriptionHasError
                      ? theme.colorScheme.error
                      : theme.colorScheme.primary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.error,
                  ),
                ),
                filled: true,
                fillColor: theme.colorScheme.surface,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: theme.colorScheme.secondary),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    if (_validateInputs()) {
                      if (widget.note == null) {
                        final newNote = NoteModel(
                          id: DateTime.now().toString(),
                          name: _nameController.text.trim(),
                          description: _descriptionController.text.trim(),
                          isPinned: false,
                        );
                        context
                            .read<NoteBloc>()
                            .add(AddNotes(noteModel: newNote));
                      } else {
                        final note = widget.note!.copyWith(
                          id: widget.note!.id,
                          name: _nameController.text.trim(),
                          description: _descriptionController.text.trim(),
                          isPinned: widget.note!.isPinned,
                        );
                        context
                            .read<NoteBloc>()
                            .add(UpdateNotes(noteModel: note));
                      }
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isEditing ? Icons.save : Icons.add,
                        size: 20,
                        color: theme.colorScheme.onPrimary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isEditing ? 'Save' : 'Add Note',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
