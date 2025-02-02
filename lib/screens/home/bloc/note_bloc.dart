import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:minimal_note/screens/home/data/model/note_model.dart';
import 'package:minimal_note/screens/home/data/repository/note_repository.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final NoteRepository noteRepository = GetIt.instance<NoteRepository>();

  NoteBloc() : super(NoteInitial()) {
    on<LoadNotes>(_loadNotes);
    on<AddNotes>(_addNotes);
    on<UpdateNotes>(_updateNotes);
    on<DeleteNote>(_deleteNote);
  }

  Future<void> _loadNotes(LoadNotes event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      final notes = await noteRepository.getNotes();
      emit(NoteLoaded(noteList: notes));
    } catch (e) {
      emit(NoteError(message: e.toString()));
    }
  }

  Future<void> _addNotes(AddNotes event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      await noteRepository.addNotes(noteModel: event.noteModel);
      emit(NoteLoaded(noteList: await noteRepository.getNotes()));
    } catch (e) {
      emit(NoteError(message: e.toString()));
    }
  }

  Future<void> _updateNotes(UpdateNotes event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      await noteRepository.updateNotes(noteModel: event.noteModel);
      emit(NoteLoaded(noteList: await noteRepository.getNotes()));
    } catch (e) {
      emit(NoteError(message: e.toString()));
    }
  }

  Future<void> _deleteNote(DeleteNote event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      await noteRepository.deleteNotes(id: event.noteId);
      emit(NoteLoaded(noteList: await noteRepository.getNotes()));
    } catch (e) {
      emit(NoteError(message: e.toString()));
    }
  }
}
