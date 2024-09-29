class Note {
  final int id;
  final String? heading;

  final String note;
  final DateTime dateTime;

  Note({
    required this.id,
    this.heading,
    required this.note,
    required this.dateTime,
  });
}
