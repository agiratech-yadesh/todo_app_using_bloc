import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_bloc/domain/models/todo.dart';
import 'package:to_do_bloc/presentation/todo_cubit.dart';

class TodoView extends StatelessWidget {
  const TodoView({super.key});

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        
                  backgroundColor: Color(0XFF001F3F),

        title: Text('Delete Confirmation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
        content: Text('Are you sure you want to delete this item?', style: TextStyle(color: Colors.white),),
        actions: [
          TextButton(
                                          style: TextButton.styleFrom( foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),

            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
                              style: TextButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),

            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text('Delete'),
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
          backgroundColor: Color(0XFF001F3F),
              title: const Center(child: Text("Add Todo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Title', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),),
                  TextField(
                    controller: titleTextController,
                    style: TextStyle(color: Colors.white),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text('Description', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),),
                  TextField(
                    maxLines: 2,
                    maxLength: 100,
                    controller: descTextController,
                                        style: TextStyle(color: Colors.white),

                  ),
                ],
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom( foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),

                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                                                      style: TextButton.styleFrom(backgroundColor: Color(0XFF4F6F52), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),

                  onPressed: () {

                    if(titleTextController.text.isEmpty || descTextController.text.isEmpty){
                      showDialog(context: context, builder: (context)=> AlertDialog(
                        title: Icon(Icons.warning_amber, color: Colors.redAccent,),

                        content: Text('Title or Description should not be empty', style: TextStyle(fontSize: 20),),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.of(context).pop();

                          }, child: Text('Close', style: TextStyle(color: Colors.red),))
                        ],
                      ));
                    } else{
                    todoCubit.addTodo(
                        titleTextController.text, descTextController.text);
                    Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add',),
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
        title: const Text(
          'Todo',
          style: TextStyle(
              color: Color(0XFFFEFBF6),
              fontSize: 26,
              fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: const Color(0XFF001F3F),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0XFF001F3F),
        foregroundColor: const Color(0XFFF7F7F8),
        onPressed: () {
          _showAddTodoBox(context);
        },
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<TodoCubit, List<Todo>>(builder: (context, todos) {
        return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.all(8),
                  tileColor: const Color(0XFFEAD8B1),
                  title: Text(
                    todo.text,
                    style: TextStyle(),
                  ),
                  subtitle: Text(todo.desc),
                  leading: Checkbox(
                      checkColor: Colors.white,
                      activeColor: const Color(0XFF4F6F52),
                      value: todo.isCompleted,
                      onChanged: (value) => todoCubit.toggleCompletion(todo)),
                  trailing: IconButton(
                      onPressed: () {
                        _confirmDelete(context).then((confirmed) {
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
            });
      }),
    );
  }
}
