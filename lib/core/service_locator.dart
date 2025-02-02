import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'package:minimal_note/screens/home/data/model/note_model.dart';
import 'package:minimal_note/screens/home/data/repository/note_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupLocator() async {
  final Box<NoteModel> noteBox = await Hive.openBox<NoteModel>('notes');
  getIt.registerLazySingleton<NoteRepository>(() => NoteRepository(noteBox));
}
