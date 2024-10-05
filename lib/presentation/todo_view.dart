import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do/domain/models/note.dart';
import 'package:to_do/domain/models/todo.dart';
import 'package:to_do/domain/repository/note_repo.dart';
import 'package:to_do/domain/repository/todo_repo.dart';
import 'package:to_do/presentation/note_cubit.dart';
import 'package:to_do/presentation/todo_cubit.dart';
import 'package:to_do/presentation/view_todo.dart';

import 'navigation_cubit.dart';
import 'dart:ui' as ui; // Required for capturing the image

class TodoView extends StatefulWidget {
  final TodoRepo todoRepo;
  final NoteRepo noteRepo;
  const TodoView({super.key, required this.todoRepo, required this.noteRepo});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _getUserName();
  }

  Future<void> _getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('userName');

    if (userName == null) {
      // Ask for the name if not set
      _askForUserName();
    } else {
      setState(() {
        _userName = userName;
      });
    }
  }

  Future<void> _askForUserName() async {
    String? userName = await showDialog<String>(
      context: context,
      builder: (context) {
        String inputName = '';
        return AlertDialog(
          titlePadding: const EdgeInsets.only(top: 30, left: 20, right: 20),
          title: const Text(
            'Hey, your name please!',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              inputName = value;
            },
            decoration: const InputDecoration(
                hintText: 'Name',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFFF5DAD2)))),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(inputName);
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: Color(0XFF75A47F)),
              ),
            ),
          ],
        );
      },
    );

    if (userName != null && userName.isNotEmpty) {
      String formattedName = "$userName's"; // Add 's to the name
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', formattedName);

      setState(() {
        _userName = formattedName;
      });
    }
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
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
        barrierColor: const Color(0XFFBACD92),
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
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
                    maxLength: 100,
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
                    maxLines: 3,
                    maxLength: 255,
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
                      foregroundColor: const Color(0XFF75A47F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  onPressed: () {
                    if (titleTextController.text.isEmpty ||
                        descTextController.text.isEmpty) {
                      showDialog(
                          barrierColor: const Color(0XFFBACD92),
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text(
                                  'Title or Description should not be empty',
                                  style: TextStyle(fontSize: 16),
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
    final GlobalKey globalKey = GlobalKey();

    Future<void> captureAndShareScreenshot() async {
      try {
        // Capture the widget as an image
        RenderRepaintBoundary boundary = globalKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        Uint8List pngBytes = byteData!.buffer.asUint8List();

        // Save the image to a temporary directory
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/screenshot.png').create();
        await file.writeAsBytes(pngBytes);

        final XFile xFile = XFile(file.path);
        Share.shareXFiles(
          [xFile],
        );
      } catch (e) {
        print("Error capturing screenshot: $e");
      }
    }

    DateTime now = DateTime.now();

    String formattedDate = DateFormat.yMMMEd().add_jm().format(now);

    final headingTextController = TextEditingController();
    final noteTextController = TextEditingController();

    return BlocBuilder<NavigationCubit, int>(builder: (context, state) {
      // Update system navigation bar color based on the current state
      if (state == 0) {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemNavigationBarColor: Color(0XFFFCFFE0), // Color when state is 0
        ));
      }
      // if (state == 1) {
      //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      //     systemNavigationBarColor:
      //         Color.fromARGB(255, 255, 255, 255), // Color for other states
      //   ));
      // }

      return Scaffold(
        extendBody: true,
        backgroundColor: const Color(0XFFFCFFE0),
        appBar: AppBar(
          scrolledUnderElevation: 0,
          toolbarHeight: 70,
          backgroundColor: const Color(0XFFFCFFE0),
          title: BlocBuilder<NavigationCubit, int>(
            builder: (context, state) {
              String titleText = state == 0
                  ? "${_userName ?? ''} To-Do"
                  : "${_userName ?? ''} Notes";

              return Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: [
                    Text(
                      titleText,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/note_icon.png',
                      width: 40,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButton: BlocBuilder<NavigationCubit, int>(
          builder: (context, state) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: FloatingActionButton(
              backgroundColor: const Color(0XFFF5DAD2),
              foregroundColor: const Color(0XFF75A47F),
              onPressed: () {
                if (state == 0) {
                  _showAddTodoBox(context);
                } else {
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    barrierColor: const Color(0XFFFCFFE0),
                    barrierLabel: 'Add Note',
                    enableDrag: true,
                    isDismissible: true,
                    isScrollControlled:
                        true, // Allows full-screen height control
                    context: context,
                    builder: (BuildContext context) {
                      double screenHeight = MediaQuery.of(context).size.height;
                      return Container(
                        width: double.maxFinite,
                        height: screenHeight * 0.8,
                        padding: const EdgeInsets.all(16.0),
                        child: Stack(
                          children: [
                            // Scrollable content
                            Padding(
                              padding: const EdgeInsets.only(
                                  top:
                                      60), // Add padding to prevent overlap with the fixed row
                              child: ListView(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      formattedDate,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  TextField(
                                    style: const TextStyle(fontSize: 22),
                                    controller: headingTextController,
                                    decoration: const InputDecoration(
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      labelText: 'Heading...',
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
                                    autofocus: true,
                                    controller: noteTextController,
                                    decoration: const InputDecoration(
                                      labelText: 'Type...',
                                      labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    maxLines: null,
                                  ),
                                  // Add other widgets here
                                ],
                              ),
                            ),
                            // Fixed row at the top
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(
                                    children: [
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     Navigator.of(context).pop();
                                      //   },
                                      //   child: const Icon(Icons.arrow_back_ios),
                                      // ),
                                      // const SizedBox(
                                      //   width: 5,
                                      // ),
                                      Text(
                                        'Add Note',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          noteTextController.clear();
                                          headingTextController.clear();
                                          Navigator.of(context).pop();
                                        },
                                        icon: const Icon(Icons.close),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (noteTextController
                                              .text.isNotEmpty) {
                                            noteCubit.addNote(
                                              headingTextController.text,
                                              noteTextController.text,
                                              DateTime.now(),
                                            );
                                            Navigator.of(context).pop();
                                          } else {
                                            FocusScope.of(context).unfocus();
                                          }
                                        },
                                        icon: const Icon(Icons.done),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
        ),
        bottomNavigationBar: BlocBuilder<NavigationCubit, int>(
          builder: (context, state) {
            return BottomNavigationBar(
              showUnselectedLabels: false,
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
                    padding: EdgeInsets.only(
                      top: 5.0,
                    ),
                    child: Icon(Icons.note_add_outlined),
                  ),
                  label: 'Note',
                ),
              ],
              currentIndex: state,
              unselectedItemColor: Colors.black54,
              backgroundColor: const Color(0XFFFCFFE0),
              selectedItemColor: const Color(0XFF75A47F),
              onTap: (index) =>
                  context.read<NavigationCubit>().changeTab(index),
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
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        child: todos.isNotEmpty
                            ? ListView.builder(
                                itemCount: todos.length,
                                itemBuilder: (context, index) {
                                  // Reverse the todos list
                                  final todo = todos.reversed.toList()[index];

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(
                                                builder: (context) => ViewTodo(
                                                      title: todo.text,
                                                      desc: todo.desc,
                                                      isCompleted:
                                                          todo.isCompleted,
                                                    )));
                                      },
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        contentPadding: const EdgeInsets.all(8),
                                        tileColor: const Color(0XFFBACD92),
                                        title: Text(
                                          todo.text,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        subtitle: Text(
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          todo.desc,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                        leading: Checkbox(
                                          checkColor: Colors.white,
                                          activeColor: Colors.green,
                                          value: todo.isCompleted,
                                          onChanged: (value) =>
                                              todoCubit.toggleCompletion(todo),
                                        ),
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
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Text(
                                'Empty',
                              )),
                      )
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
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: notes.isEmpty
                          ? const Center(child: Text('Empty '))
                          : ListView.builder(
                              itemCount: notes.length,
                              itemBuilder: (context, index) {
                                final note = notes.reversed.toList()[index];

                                return GestureDetector(
                                  onTap: () {
                                    DateTime completedDate = note.dateTime;

                                    String formattedCompletedDate =
                                        DateFormat.yMMMEd()
                                            .add_jm()
                                            .format(completedDate);

                                    final headingController =
                                        TextEditingController(
                                            text: note.heading);
                                    final noteController =
                                        TextEditingController(text: note.note);

                                    showModalBottomSheet(
                                      backgroundColor: Colors.white,
                                      barrierColor: const Color(0XFFFCFFE0),
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
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                top: 0,
                                                left: 0,
                                                right: 0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: const Icon(Icons
                                                              .arrow_back_ios),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        const Text(
                                                          'Note',
                                                          style: TextStyle(
                                                            fontSize: 22,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        Builder(
                                                          builder: (context) {
                                                            return IconButton(
                                                              icon: const Icon(
                                                                  Icons
                                                                      .more_vert),
                                                              onPressed: () {
                                                                final RenderBox
                                                                    button =
                                                                    context.findRenderObject()
                                                                        as RenderBox;
                                                                final RenderBox
                                                                    overlay =
                                                                    Overlay.of(
                                                                            context)
                                                                        .context
                                                                        .findRenderObject() as RenderBox;
                                                                final Offset
                                                                    position =
                                                                    button.localToGlobal(
                                                                        Offset
                                                                            .zero,
                                                                        ancestor:
                                                                            overlay);

                                                                showMenu(
                                                                  color: const Color(
                                                                      0XFFF5DAD2),
                                                                  context:
                                                                      context,
                                                                  position:
                                                                      RelativeRect
                                                                          .fromLTRB(
                                                                    position.dx,
                                                                    position.dy +
                                                                        button
                                                                            .size
                                                                            .height,
                                                                    position.dx +
                                                                        button
                                                                            .size
                                                                            .width,
                                                                    position.dy +
                                                                        button
                                                                            .size
                                                                            .height,
                                                                  ),
                                                                  items: [
                                                                    const PopupMenuItem<
                                                                        String>(
                                                                      value:
                                                                          'Share',
                                                                      child: Text(
                                                                          'Share'),
                                                                    ),
                                                                    const PopupMenuItem<
                                                                        String>(
                                                                      value:
                                                                          'Delete',
                                                                      child: Text(
                                                                          'Delete'),
                                                                    ),
                                                                  ],
                                                                ).then((value) {
                                                                  if (value !=
                                                                      null) {
                                                                    switch (
                                                                        value) {
                                                                      case 'Share':
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder: (context) =>
                                                                                AlertDialog(
                                                                                  alignment: Alignment.bottomCenter,
                                                                                  actionsAlignment: MainAxisAlignment.center,
                                                                                  actionsPadding: const EdgeInsets.all(8),
                                                                                  actions: [
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        TextButton(
                                                                                            onPressed: () {
                                                                                              Share.share('${headingController.text}\n${noteController.text}');
                                                                                            },
                                                                                            child: const Text(
                                                                                              "Share as text",
                                                                                              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                                                                                            )),
                                                                                        TextButton(
                                                                                            onPressed: () {
                                                                                              captureAndShareScreenshot();
                                                                                            },
                                                                                            child: const Text(
                                                                                              "Share as image",
                                                                                              style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
                                                                                            )),
                                                                                        const Padding(
                                                                                          padding: EdgeInsets.symmetric(
                                                                                            horizontal: 18.0,
                                                                                          ),
                                                                                          child: Divider(
                                                                                            thickness: .5,
                                                                                          ),
                                                                                        ),
                                                                                        TextButton(
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                            child: const Text(
                                                                                              "Cancel",
                                                                                              style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w400),
                                                                                            ))
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                ));

                                                                        break;
                                                                      case 'Delete':
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder: (context) =>
                                                                                AlertDialog(
                                                                                  alignment: Alignment.bottomCenter,
                                                                                  actionsAlignment: MainAxisAlignment.center,
                                                                                  actionsPadding: const EdgeInsets.all(8),
                                                                                  actions: [
                                                                                    Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        TextButton(
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop();

                                                                                              noteCubit.deleteTodo(note);
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                            child: const Text(
                                                                                              "Delete",
                                                                                              style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.w400),
                                                                                            )),
                                                                                        const Padding(
                                                                                          padding: EdgeInsets.symmetric(
                                                                                            horizontal: 18.0,
                                                                                          ),
                                                                                          child: Divider(
                                                                                            thickness: .5,
                                                                                          ),
                                                                                        ),
                                                                                        TextButton(
                                                                                            onPressed: () {
                                                                                              Navigator.of(context).pop();
                                                                                            },
                                                                                            child: const Text(
                                                                                              "Cancel",
                                                                                              style: TextStyle(color: Colors.black54, fontSize: 16, fontWeight: FontWeight.w400),
                                                                                            ))
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                ));

                                                                        break;
                                                                    }
                                                                  }
                                                                });
                                                              },
                                                            );
                                                          },
                                                        ),
                                                        IconButton(
                                                          onPressed: () {
                                                            final updatedNote = Note(
                                                                id: note.id,
                                                                heading:
                                                                    headingController
                                                                        .text,
                                                                note:
                                                                    noteController
                                                                        .text,
                                                                dateTime:
                                                                    DateTime
                                                                        .now());

                                                            noteCubit.updateNote(
                                                                updatedNote);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          icon: const Icon(
                                                              Icons.done),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 60.0),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    children: <Widget>[
                                                      RepaintBoundary(
                                                        key: globalKey,
                                                        child: Container(
                                                          color: Colors.white,
                                                          child: Column(
                                                            children: [
                                                              const SizedBox(
                                                                  height: 20),
                                                              Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  child: Text(
                                                                    formattedCompletedDate,
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .grey),
                                                                  )),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              TextField(
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            22),
                                                                controller:
                                                                    headingController,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  floatingLabelBehavior:
                                                                      FloatingLabelBehavior
                                                                          .never,
                                                                  labelText:
                                                                      'Heading...',
                                                                  labelStyle:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .grey,
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                  height: 16.0),
                                                              TextField(
                                                                controller:
                                                                    noteController,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  labelText:
                                                                      'Type...',
                                                                  labelStyle: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                  floatingLabelBehavior:
                                                                      FloatingLabelBehavior
                                                                          .never,
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                  ),
                                                                ),
                                                                maxLines: null,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 8),
                                      tileColor: const Color(0XFFBACD92),
                                      title: note.heading!.isNotEmpty
                                          ? Text(note.heading!)
                                          : const SizedBox.shrink(),
                                      titleTextStyle: const TextStyle(
                                          fontSize: 20, color: Colors.black),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            note.note,
                                            style:
                                                const TextStyle(fontSize: 18),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            DateFormat.yMMMEd()
                                                .add_jm()
                                                .format(note.dateTime),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14),
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
