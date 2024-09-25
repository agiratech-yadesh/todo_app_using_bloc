

import 'package:isar/isar.dart';
import 'package:to_do_bloc/data/models/isar_todo.dart';
import 'package:to_do_bloc/domain/models/todo.dart';
import 'package:to_do_bloc/domain/repository/todo_repo.dart';

class IsarTodoRepo implements TodoRepo {

  final Isar db;

  IsarTodoRepo(this.db);


  @override
  Future<List<Todo>> getTodo() async {

    final todos = await db.todoIsars.where().findAll();

    return todos.map((todoIsar)=> todoIsar.toDomain()).toList();


  }
  
  @override
  Future<void> addTodo(Todo newTodo) {


    // conert todo into isar todo
    final todoIsar = TodoIsar.fromDomain(newTodo);


    // to store in isar db
    return db.writeTxn(()=> db.todoIsars.put(todoIsar));


  }
  
  @override
  Future<void> deleteTodo(Todo todo) async {

    await db.writeTxn(()=> db.todoIsars.delete(todo.id));





  }
  
  @override
  Future<void> updateTodo(Todo todo) {


         // conert todo into isar todo
    final todoIsar = TodoIsar.fromDomain(todo);


    // to store in isar db
    return db.writeTxn(()=> db.todoIsars.put(todoIsar));



  }

  
  


}