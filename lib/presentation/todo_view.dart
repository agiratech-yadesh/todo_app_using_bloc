import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_bloc/domain/models/note.dart';
import 'package:to_do_bloc/domain/models/todo.dart';
import 'package:to_do_bloc/domain/repository/note_repo.dart';
import 'package:to_do_bloc/domain/repository/todo_repo.dart';
import 'package:to_do_bloc/presentation/add_note.dart';
import 'package:to_do_bloc/presentation/note_cubit.dart';
import 'package:to_do_bloc/presentation/todo_cubit.dart';
import 'navigation_cubit.dart'; // Import the NavigationCubit

class TodoView extends StatelessWidget {
  final TodoRepo todoRepo;
  final NoteRepo noteRepo;
  const TodoView({super.key, required this.todoRepo, required this.noteRepo});

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
    final noteCubit = BlocProvider.of<NoteCubit>(context);
    DateTime now = DateTime.now();

    // Format the date and time
    String formattedDate = DateFormat.yMMMEd().add_jm().format(now);

    double screenHeight = MediaQuery.of(context).size.height;
    final headingTextController = TextEditingController();
    final noteTextController = TextEditingController();

    return BlocBuilder<NavigationCubit, int>(builder: (context, state) {
      // Update system navigation bar color based on the current state
      if (state == 0) {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0XFFEAD8B1), // Color when state is 0
        ));
      } else {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0XFF001F3F), // Color for other states
        ));
      }

      return Scaffold(
        extendBody: true,
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
          builder: (context, state) => FloatingActionButton(
            backgroundColor: const Color(0XFF001F3F),
            foregroundColor: const Color(0XFFF7F7F8),
            onPressed: () {
              if (state == 0) {
                _showAddTodoBox(context);
              } else {
                showModalBottomSheet(
                  barrierColor: const Color(0XFFEAD8B1),
                  enableDrag: true,
                  isDismissible: true,

                  isScrollControlled: true, // Allows full-screen height control

                  context: context,
                  builder: (BuildContext context) {
                    double screenHeight = MediaQuery.of(context).size.height;
                    return Container(
                      width: double.maxFinite,
                      height: screenHeight * 0.8,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Add Note',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.w500),
                              ),
                              IconButton(
                                  onPressed: () {

                                    if(noteTextController.text.isNotEmpty){
                                        noteCubit.addNote(
                                      headingTextController.text,
                                      
                                      noteTextController.text,
                                      DateTime.now()
                                      
                                    );
                                    Navigator.of(context).pop();
                                      


                                    } else{

                                      FocusScope.of(context).unfocus();
                                    }
                                  
                                  },
                                  icon: const Icon(Icons.done))
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                formattedDate,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                              )),
                          const SizedBox(
                            height: 10,
                          ),

                          TextField(
                            controller: headingTextController,
                            decoration: const InputDecoration(
                                labelText: 'Heading',
                                labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                          ),
                          const SizedBox(height: 16.0),
                          TextField(
                            autofocus: true,
                            controller: noteTextController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none)),
                            maxLines: null,
                          ),
                          // Add other widgets here
                        ],
                      ),
                    );
                  },
                );
              }
            },
            child: const Icon(Icons.add),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: BlocBuilder<NavigationCubit, int>(
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
                backgroundColor: const Color(0XFFEAD8B1),
                selectedItemColor: Colors.blue,
                onTap: (index) =>
                    context.read<NavigationCubit>().changeTab(index),
              );
            },
          ),
        ),
        body: BlocBuilder<NavigationCubit, int>(
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
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: todos.length,
                            itemBuilder: (context, index) {
                              final todo = todos[index];

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10),
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
              return BlocBuilder<NoteCubit, List<Note>>(
                  builder: (context, notes) {
                return Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 40,
                      ),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Notes",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w500),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];

                          return GestureDetector(
                            onTap: () {
                              DateTime completedDate = note.dateTime;

                              String formattedCompletedDate =
                                  DateFormat.yMMMEd()
                                      .add_jm()
                                      .format(completedDate);

                              // Create TextEditingControllers and set their text
                              final headingController =
                                  TextEditingController(text: note.heading);
                              final noteController =
                                  TextEditingController(text: note.note);

                              showModalBottomSheet(
                                barrierColor: const Color(0XFFEAD8B1),
                                enableDrag: true,
                                isDismissible: true,
                                isScrollControlled:
                                    true, // Allows full-screen height control
                                context: context,
                                builder: (BuildContext context) {
                                  double screenHeight =
                                      MediaQuery.of(context).size.height;
                                  return Container(
                                    width: double.maxFinite,
                                    height: screenHeight * 0.8,
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Add Note',
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                final updatedNote = Note(
                                                    id: note.id,
                                                    heading:
                                                        headingController.text,
                                                    note: noteController.text,
                                                    dateTime: DateTime.now());

                                                noteCubit
                                                    .updateNote(updatedNote);
                                                Navigator.of(context).pop();
                                              },
                                              icon: const Icon(Icons.done),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              formattedCompletedDate,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey),
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                          controller: headingController,
                                          decoration: const InputDecoration(
                                            labelText: 'Heading',
                                            labelStyle: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        TextField(
                                          controller: noteController,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                          maxLines: null,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                contentPadding: const EdgeInsets.all(8),
                                tileColor: const Color(0XFFEAD8B1),
                                title: note.heading!.isNotEmpty
                                    ? Text(note.heading!)
                                    : const SizedBox.shrink(),
                                subtitle: Text(note.note),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              });
            } else {
              return Container();
            }
          },
        ),
      );
    });
  }
}
