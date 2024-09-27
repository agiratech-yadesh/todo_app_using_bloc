


import 'package:isar/isar.dart';
import 'package:to_do_bloc/domain/models/note.dart';
import 'package:to_do_bloc/domain/models/todo.dart';


part 'isar_todo.g.dart';

@collection
class TodoIsar{

  Id id = Isar.autoIncrement;
  late String text;
  late String desc;
  late bool isCompleted;


  // convert isar object to pure todo object to use in our app

  Todo toDomain(){
    return Todo(id: id, text: text, isCompleted: isCompleted, desc:desc );
    
  }

// convert pure todo object to isar object to store in isar db
  static TodoIsar fromDomain(Todo todo){
    return TodoIsar()
    ..id = todo.id
    ..text = todo.text
    ..desc = todo.desc
    ..isCompleted = todo.isCompleted;
  }

}


@collection
class NoteIsar{


  Id id = Isar.autoIncrement;
  late String heading;
  late String note;



  Note toDomain(){

    return Note(id: id, note: note);
  }


  static NoteIsar fromDomain(Note note){
    return NoteIsar()
    ..id = note.id
    ..heading = note.heading!
    ..note = note.note;
  }

  
}