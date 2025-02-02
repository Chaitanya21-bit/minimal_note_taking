import 'package:hive/hive.dart';
import 'package:minimal_note/screens/home/data/model/note_model.dart';

class NoteRepository {
  final Box<NoteModel> _noteBox;

  NoteRepository(this._noteBox);

  Future<List<NoteModel>> getNotes() async {
    return _noteBox.values.toList();
  }

  Future<void> addNotes({required NoteModel noteModel}) async {
    await _noteBox.put(noteModel.id, noteModel);
  }

  Future<void> deleteNotes({required String id}) async {
    await _noteBox.delete(id);
  }

  Future<void> updateNotes({required NoteModel noteModel}) async {
    await _noteBox.put(noteModel.id, noteModel);
  }
}
