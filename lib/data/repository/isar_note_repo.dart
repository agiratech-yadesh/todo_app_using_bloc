import 'package:isar/isar.dart';
import 'package:to_do/data/models/isar_todo.dart';
import 'package:to_do/domain/models/note.dart';
import 'package:to_do/domain/repository/note_repo.dart';


class IsarNoteRepo implements NoteRepo{


  final Isar db;

  IsarNoteRepo(this.db);
  
  @override
  Future<void> addNote(Note newNote) async{

    final noteIsar = NoteIsar.fromDomain(newNote);


    return db.writeTxn(()=> db.noteIsars.put(noteIsar));

   


  }

  @override
  Future<void> deleteNote(Note note) async{

        await db.writeTxn(()=> db.noteIsars.delete(note.id));


  }

  @override
  Future<List<Note>> getNote() async {


     final note = await db.noteIsars.where().findAll();

    return note.map((noteIsar)=> noteIsar.toDomain()).toList();
  }

  @override
  Future<void> updateNote(Note note) {


    final noteIsar = NoteIsar.fromDomain(note);

    return db.writeTxn(()=> db.noteIsars.put(noteIsar));
  }
}