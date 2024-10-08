
import 'package:to_do/domain/models/note.dart';

abstract class NoteRepo {


  Future<List<Note>> getNote();


  Future<void> addNote(Note newNote);

  Future<void> updateNote(Note note);

  Future<void> deleteNote(Note note);



}