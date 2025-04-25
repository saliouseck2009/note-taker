/// Data model for Note (used within the data layer).
class NoteModel {
  int? id;
  String title;
  String content;
  DateTime date;
  int color;

  NoteModel({
    required this.title,
    required this.content,
    required this.date,
    required this.color,
    this.id,
  });
}
