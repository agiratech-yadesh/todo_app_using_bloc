import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_bloc/domain/models/note.dart';
import 'package:to_do_bloc/domain/models/todo.dart';
import 'package:to_do_bloc/domain/repository/note_repo.dart';
import 'package:to_do_bloc/domain/repository/todo_repo.dart';
import 'package:to_do_bloc/presentation/add_note.dart';
import 'package:to_do_bloc/presentation/custom_location_float.dart';
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
        backgroundColor:  Colors.white,
        title: const Text(
          'Delete Confirmation',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        content: const Text(
          'Are you sure you want to delete this item?',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8))),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.red,
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
              backgroundColor:  Colors.white,
              title: const Center(
                child: Text(
                  "Add Todo",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Title',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400),
                  ),
                  TextField(
                    controller: titleTextController,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Description',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400),
                  ),
                  TextField(
                    maxLines: 2,
                    maxLength: 100,
                    controller: descTextController,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: const Color(0XFFF5DAD2),
                      foregroundColor: Color(0XFF75A47F),
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
                                  color: Colors.red,
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
          systemNavigationBarColor: Color(0XFFBACD92), // Color when state is 0
        ));
      } else {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Color.fromARGB(255, 255, 255, 255), // Color for other states
        ));
      }

      return Scaffold(
        extendBody: true,
        
        backgroundColor: const Color(0XFFFCFFE0),
        appBar: AppBar(
          toolbarHeight: 20,
          backgroundColor: const Color(0XFFFCFFE0),
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
            floatingActionButtonLocation: CustomFloatingActionButtonLocation(),

        floatingActionButton: BlocBuilder<NavigationCubit, int>(
          builder: (context, state) => FloatingActionButton(
            
            
            backgroundColor: const Color(0XFFF5DAD2),
            foregroundColor: const Color(0XFF75A47F),
            onPressed: () {
              if (state == 0) {
                _showAddTodoBox(context);
              } else {
                showModalBottomSheet(
                  barrierColor: const Color(0XFFBACD92),
                  barrierLabel: 'Add Note',
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
                              Row(
                                children: [



                                  IconButton(
  onPressed: () {
    if (noteTextController.text.isNotEmpty || headingTextController.text.isNotEmpty) {

showDialog(context: context, builder: (context)=> AlertDialog(
  alignment: Alignment.bottomCenter,
  actionsAlignment: MainAxisAlignment.center,
  actionsPadding: EdgeInsets.all(8),
  actions: [

    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(onPressed: (){
          noteTextController.clear();
          headingTextController.clear();

          Navigator.of(context).pop();
          



        }, child: Text("Delete", style: TextStyle(color: Colors.red),)),

         TextButton(onPressed: (){
          Navigator.of(context).pop();

        }, child: Text("Cancel", style: TextStyle(color: Colors.black54),))
      ],
    )


  ],


));      
    }

  },
  icon: const Icon(Icons.more_vert),
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
                                      icon: const Icon(Icons.done)),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                formattedDate,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey),
                              )),
                          const SizedBox(
                            height: 10,
                          ),

                          TextField(
                            style: TextStyle(fontSize: 22),
                            controller: headingTextController,
                            
                            decoration: const InputDecoration(
                              
                                                                          floatingLabelBehavior: FloatingLabelBehavior.never,

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
                              labelText: 'Type...',
                               labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                                                          floatingLabelBehavior: FloatingLabelBehavior.never,

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
       bottomNavigationBar: BlocBuilder<NavigationCubit, int>(
  builder: (context, state) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Icon(Icons.add_task),
          ),
          label: 'Todo',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(top: 5.0,),  
            child: Icon(Icons.note_add_outlined),
          ),
          label: 'Note',
        ),
      ],
      currentIndex: state,
      backgroundColor: const Color(0XFFBACD92),
      selectedItemColor: const Color(0XFFFCFFE0),
      onTap: (index) => context.read<NavigationCubit>().changeTab(index),
    );
  
            },
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
                          left: 20,
                        ),
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "✏️ To-Do",
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
                                  tileColor: const Color(0XFFBACD92),
                                  title: Text(
                                    todo.text,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  subtitle: Text(todo.desc,  style: TextStyle(color: Colors.white, fontSize: 18),),
                                  leading: Checkbox(
                                      checkColor: Colors.white,
                                      activeColor:  Colors.green,
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
                                        color: Colors.red,
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
                        left: 20,
                      ),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "📝 Notes",
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
                                barrierColor: const Color(0XFFBACD92),
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
                                            Row(
                                              children: [


                                                                             IconButton(
  onPressed: () {

showDialog(context: context, builder: (context)=> AlertDialog(
  alignment: Alignment.bottomCenter,
  actionsAlignment: MainAxisAlignment.center,
  actionsPadding: EdgeInsets.all(8),
  actions: [

    Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(onPressed: (){
          Navigator.of(context).pop();

          noteCubit.deleteTodo(note);
Navigator.of(context).pop();

          



        }, child: Text("Delete", style: TextStyle(color: Colors.red),)),

         TextButton(onPressed: (){
          Navigator.of(context).pop();


        }, child: Text("Cancel"))
      ],
    )


  ],


));      

  },
  icon: const Icon(Icons.more_vert),
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
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              formattedCompletedDate,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.grey),
                                            )),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                                                      style: TextStyle(fontSize: 22),

                                          controller: headingController,
                                          decoration: const InputDecoration(
                                            floatingLabelBehavior: FloatingLabelBehavior.never,
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
                                             labelText: 'Type...',
                               labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                                                          floatingLabelBehavior: FloatingLabelBehavior.never,
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
    borderRadius: BorderRadius.circular(10),
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  
  
  tileColor: const Color(0XFFBACD92),
  title: note.heading!.isNotEmpty ? Text(note.heading!) : const SizedBox.shrink(),
  titleTextStyle: const TextStyle(fontSize: 20, color: Colors.black),
  subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      
         Text(
          
          note.note,
          style: const TextStyle(fontSize: 18),
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
      
      const SizedBox(height: 2),
      Text(
        DateFormat.yMMMEd().add_jm().format(note.dateTime),
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    ],
  ),
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
