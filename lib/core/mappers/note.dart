import 'package:note/data/models/note.dart';
import 'package:note/domain/entities/note_entity.dart';

extension NoteModelExtension on NoteModel {
  /// Converts a NoteModel to a domain Note entity.
  Note toEntity() {
    return Note(
      id: id,
      title: title,
      content: content,
      date: date,
      color: color,
    );
  }
}
