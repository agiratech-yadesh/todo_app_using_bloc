import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:to_do_bloc/data/models/isar_todo.dart';
import 'package:to_do_bloc/data/repository/isar_note_repo.dart';
import 'package:to_do_bloc/data/repository/isar_todo_repo.dart';
import 'package:to_do_bloc/domain/repository/note_repo.dart';
import 'package:to_do_bloc/domain/repository/todo_repo.dart';
import 'package:to_do_bloc/presentation/todo_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();


  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([TodoIsarSchema], directory: dir.path);

  final isarTodoRepo = IsarTodoRepo(isar);
  final isarNoteRepo = IsarNoteRepo(isar);

  runApp( MyApp(todoRepo: isarTodoRepo, noteRepo: isarNoteRepo,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.todoRepo, required this.noteRepo});


  final TodoRepo todoRepo;
  final NoteRepo noteRepo;
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
       
        useMaterial3: true,
      ),
      home: TodoPage(todoRepo: todoRepo, noteRepo: noteRepo,),
    );
  }
}
