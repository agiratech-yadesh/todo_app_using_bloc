import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'note_cubit.dart';

class AddNote extends StatelessWidget {
  const AddNote({super.key});

  @override
  Widget build(BuildContext context) {
    final headingTextController = TextEditingController();
    final noteTextController = TextEditingController();

    
        return Scaffold(
          appBar: AppBar(
            actions: [
              GestureDetector(
                onTap: () {
                  final noteCubit = BlocProvider.of<NoteCubit>(context);
                  
                  final heading = headingTextController.text;
                  final note = noteTextController.text;

                  if (heading.isNotEmpty && note.isNotEmpty) {
                    // noteCubit.addNote(heading, note,);
                    
                    headingTextController.clear();
                    noteTextController.clear();
                  }
                },
                child: const Icon(Icons.done),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: headingTextController,
                  decoration: const InputDecoration(labelText: 'Heading'),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: noteTextController,
                  decoration: const InputDecoration(labelText: 'Note'),
                  maxLines: null, 
                ),
              ],
            ),
          ),
        );
  }
}
