import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/data/models/isar_todo.dart';
import 'package:to_do/data/repository/isar_note_repo.dart';
import 'package:to_do/data/repository/isar_todo_repo.dart';
import 'package:to_do/domain/repository/note_repo.dart';
import 'package:to_do/domain/repository/todo_repo.dart';
import 'package:to_do/presentation/navigation_cubit.dart';
import 'package:to_do/presentation/note_cubit.dart';
import 'package:to_do/presentation/todo_cubit.dart';
import 'package:to_do/presentation/todo_view.dart';
import 'package:to_do/theme/theme_bloc.dart';
import 'package:to_do/theme/theme_data.dart';
import 'package:to_do/theme/theme_state.dart';
import 'package:to_do/theme/theme_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  final isar =
      await Isar.open([TodoIsarSchema, NoteIsarSchema], directory: dir.path);

  final isarTodoRepo = IsarTodoRepo(isar);
  final isarNoteRepo = IsarNoteRepo(isar);

  // Initialize ThemeBloc with saved preference before running the app
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('theme_mode') ?? false;
  final themeBloc = ThemeBloc()
    ..add(SetThemeEvent(isDark ? ThemeMode.dark : ThemeMode.light));

  runApp(MyApp(
    todoRepo: isarTodoRepo,
    noteRepo: isarNoteRepo,
    themeBloc: themeBloc,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.todoRepo,
    required this.noteRepo,
    required this.themeBloc,
  });

  final TodoRepo todoRepo;
  final NoteRepo noteRepo;
  final ThemeBloc themeBloc;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodoCubit>(
          create: (context) => TodoCubit(todoRepo),
        ),
        BlocProvider<NavigationCubit>(
          create: (context) => NavigationCubit(),
        ),
        BlocProvider<NoteCubit>(
          create: (context) => NoteCubit(noteRepo),
        ),
        BlocProvider<ThemeBloc>.value(
          value: themeBloc,
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'To-Do',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeState.themeMode,
            home: TodoView(todoRepo: todoRepo, noteRepo: noteRepo),
          );
        },
      ),
    );
  }
}
