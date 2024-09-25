class Todo {
  final int id;
  final String text;
    final String desc;

  final bool isCompleted;

  Todo( {
    required this.id,
   required this.desc,
    required this.text,
    this.isCompleted = false,
  });

  Todo toggleCompletiom() {
    return Todo(id: id, 
    text: text, 
    desc: desc,
    isCompleted: !isCompleted);
  }
}
