import 'package:flutter/material.dart';

class ViewTodo extends StatelessWidget {
  final String title;
  final String desc;
  final bool isCompleted;

  const ViewTodo(
      {super.key,
      required this.title,
      required this.desc,
      required this.isCompleted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFFFCFFE0),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              isCompleted ? 'Accomplished' : "Pending",
              style: TextStyle(
                  color: isCompleted ? Colors.green : Colors.grey,
                  fontSize: 16),
            ),
          )
        ],
      ),
      backgroundColor: const Color(0XFFFCFFE0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'title',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                        width: 300,
                        child: Text(
                          title,
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w500),
                        ),
                      )),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              const Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'description',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: SizedBox(
                          width: 280,
                          child: Text(
                            softWrap: true,
                            desc,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w300),
                            textAlign: TextAlign.left,
                          ))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
