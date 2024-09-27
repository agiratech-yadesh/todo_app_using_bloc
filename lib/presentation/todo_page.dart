import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_bloc/domain/repository/note_repo.dart';
import 'package:to_do_bloc/domain/repository/todo_repo.dart';
import 'package:to_do_bloc/presentation/note_cubit.dart';
import 'package:to_do_bloc/presentation/todo_cubit.dart';
import 'package:to_do_bloc/presentation/todo_view.dart';
import 'package:to_do_bloc/presentation/navigation_cubit.dart'; // Add this if you have a separate NavigationCubit

class TodoPage extends StatelessWidget {
  final TodoRepo todoRepo;
  final NoteRepo noteRepo;

  const TodoPage({super.key, required this.todoRepo, required this.noteRepo});

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
        )
      ],
      child: const TodoView(),
    );
  }
}
