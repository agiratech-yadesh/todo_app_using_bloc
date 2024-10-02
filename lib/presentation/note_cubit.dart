import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do/domain/models/note.dart';
import 'package:to_do/domain/repository/note_repo.dart';


class NoteCubit extends Cubit<List<Note>> {
  final NoteRepo noteRepo;

  NoteCubit(this.noteRepo) : super([]) {
    loadNotes();
  }

  Future<void> loadNotes() async {
    final noteList = await noteRepo.getNote();

    emit(noteList);
  }

  Future<void> addNote(String heading, String note, DateTime dateTime) async {
    final newNote = Note(
        id: DateTime.now().millisecondsSinceEpoch,
        heading: heading,
        note: note,
        dateTime: dateTime);

    await noteRepo.addNote(newNote);

    loadNotes();
  }

  Future<void> updateNote(Note updatedNote) async {
    await noteRepo.updateNote(
        updatedNote); // Assuming your repository has an update method
    loadNotes();
  }

  Future<void> deleteTodo(Note note) async {
    await noteRepo.deleteNote(note);

    loadNotes();
  }
}
