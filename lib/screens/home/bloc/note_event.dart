part of 'note_bloc.dart';

abstract class NoteEvent {}

class LoadNotes extends NoteEvent {}

class AddNotes extends NoteEvent {
  final NoteModel noteModel;
  AddNotes({required this.noteModel});
}

class UpdateNotes extends NoteEvent {
  final NoteModel noteModel;
  UpdateNotes({required this.noteModel});
}

class DeleteNote extends NoteEvent {
  final String noteId;
  DeleteNote({required this.noteId});
}
