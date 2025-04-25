import 'package:note/data/models/note.dart';

/// Abstraction for a local data source of notes (e.g., database or in-memory).
abstract class LocalDataSource {
  /// Watches all notes, emitting a stream of [NoteModel] lists.
  Stream<List<NoteModel>> watchAllNotes();

  /// Inserts a new [note]. Returns the generated id.
  Future<int> insertNote(NoteModel note);

  /// Updates an existing [note].
  Future<void> updateNote(NoteModel note);

  /// Deletes the note with the given [id].
  Future<void> deleteNote(int id);
}
