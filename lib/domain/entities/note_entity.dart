import 'package:equatable/equatable.dart';

class Note extends Equatable {
  final int? id;
  final String title;
  final String content;
  final DateTime date;
  final int color;

  const Note({
    required this.title,
    required this.content,
    required this.date,
    required this.color,
    this.id,
  });

  Note copyWith({
    int? id,
    String? title,
    String? content,
    DateTime? date,
    int? color,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      color: color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [id, title, content, date, color];
}
