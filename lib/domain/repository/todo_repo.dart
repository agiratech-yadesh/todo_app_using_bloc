

import 'package:to_do/domain/models/todo.dart';

abstract class TodoRepo {

  Future<List<Todo>> getTodo();


  Future<void> addTodo(Todo newTodo);


  Future<void> updateTodo(Todo todo);


  Future<void> deleteTodo(Todo todo);



}