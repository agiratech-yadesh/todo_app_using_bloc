import 'package:to_do/domain/models/name.dart';

abstract class NameRepo {
  Future<void> addName(Name newTodo);


}