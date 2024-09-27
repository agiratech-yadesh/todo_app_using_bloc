import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_bloc/domain/models/todo.dart';
import 'package:to_do_bloc/presentation/add_note.dart';
import 'package:to_do_bloc/presentation/todo_cubit.dart';
import 'navigation_cubit.dart'; // Import the NavigationCubit

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0XFF001F3F),
        title: const Text(
          'Delete Confirmation',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to delete this item?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddTodoBox(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final titleTextController = TextEditingController();
    final descTextController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: const Color(0XFF001F3F),
              title: const Center(
                child: Text(
                  "Add Todo",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Title',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                  TextField(
                    controller: titleTextController,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Description',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                  TextField(
                    maxLines: 2,
                    maxLength: 100,
                    controller: descTextController,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: const Color(0XFF4F6F52),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    if (titleTextController.text.isEmpty ||
                        descTextController.text.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Icon(
                                  Icons.warning_amber,
                                  color: Colors.redAccent,
                                ),
                                content: const Text(
                                  'Title or Description should not be empty',
                                  style: TextStyle(fontSize: 20),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Close',
                                        style: TextStyle(color: Colors.red),
                                      ))
                                ],
                              ));
                    } else {
                      todoCubit.addTodo(
                          titleTextController.text, descTextController.text);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(
                    'Add',
                  ),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();

    return Scaffold(
      backgroundColor: const Color(0XFFFEFBF6),
      appBar: AppBar(
        backgroundColor: const Color(0XFFFEFBF6),
      ),
      // appBar: AppBar(
      //   title: const Text(
      //     'Todo',
      //     style: TextStyle(
      //         color: Color(0XFFFEFBF6),
      //         fontSize: 26,
      //         fontWeight: FontWeight.w600),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: const Color(0XFF001F3F),
      // ),
      floatingActionButton: BlocBuilder<NavigationCubit, int>(
        builder: (context, state) => 
         FloatingActionButton(
          backgroundColor: const Color(0XFF001F3F),
          foregroundColor: const Color(0XFFF7F7F8),
          onPressed: () {
            if(state == 0){
                          _showAddTodoBox(context);


            }
            else{
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddNote()));
            }
          },
          child: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: BlocBuilder<NavigationCubit, int>(
        builder: (context, state) {
          return BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.add_task),
                label: 'Todo',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.note_add_outlined),
                label: 'Note',
              ),
            ],
            currentIndex: state,
            selectedItemColor: Colors.blue,
            onTap: (index) => context.read<NavigationCubit>().changeTab(index),
          );
        },
      ),
      body: SafeArea(
        child: BlocBuilder<NavigationCubit, int>(
          builder: (context, state) {
            if (state == 0) {
              // Todo List View
              return BlocBuilder<TodoCubit, List<Todo>>(
                builder: (context, todos) {
                  return Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 40,
                        ),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "ToDo",
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.w500),
                            )),
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: todos.length,
                            itemBuilder: (context, index) {
                              final todo = todos[index];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 18.0, horizontal: 10),
                                child: ListTile(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  contentPadding: const EdgeInsets.all(8),
                                  tileColor: const Color(0XFFEAD8B1),
                                  title: Text(
                                    todo.text,
                                    style: const TextStyle(),
                                  ),
                                  subtitle: Text(todo.desc),
                                  leading: Checkbox(
                                      checkColor: Colors.white,
                                      activeColor: const Color(0XFF4F6F52),
                                      value: todo.isCompleted,
                                      onChanged: (value) =>
                                          todoCubit.toggleCompletion(todo)),
                                  trailing: IconButton(
                                      onPressed: () {
                                        _confirmDelete(context)
                                            .then((confirmed) {
                                          if (confirmed == true) {
                                            todoCubit.deleteTodo(todo);
                                          }
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.redAccent,
                                      )),
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                },
              );
            } else if (state == 1) {
              // Note View
              return const Center();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
