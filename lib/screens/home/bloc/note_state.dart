part of 'note_bloc.dart';

sealed class NoteState {}

class NoteInitial extends NoteState {}

class NoteLoading extends NoteState {}

class NoteLoaded extends NoteState {
  final List<NoteModel> noteList;
  NoteLoaded({required this.noteList});
}

class NoteError extends NoteState {
  final String message;
  NoteError({required this.message});
}
