import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_bloc/data/models/isar_todo.dart';
import 'package:to_do_bloc/data/repository/isar_todo_repo.dart';
import 'package:to_do_bloc/domain/repository/todo_repo.dart';
import 'package:to_do_bloc/presentation/todo_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();


  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([TodoIsarSchema], directory: dir.path);

  final isarTodoRepo = IsarTodoRepo(isar);

  runApp( MyApp(todoRepo: isarTodoRepo,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.todoRepo});


  final TodoRepo todoRepo;
  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       
        useMaterial3: true,
      ),
      home: TodoPage(todoRepo: todoRepo),
    );
  }
}
