import 'note_entity.dart';

/// Abstract repository for Note operations.
abstract class NoteRepository {
  /// Stream of all notes. Emits updates whenever the note list changes.
  Stream<List<Note>> watchAllNotes();

  /// Adds a new note.
  Future<void> addNote(Note note);

  /// Updates an existing note.
  Future<void> updateNote(Note note);

  /// Deletes the note with the given [id].
  Future<void> deleteNote(int id);
}
