import 'dart:async';
import 'package:note/data/models/note.dart';

import '../database/app_database.dart';
import 'local_data_source.dart';

/// Local data source implementation using Drift (SQLite database).
class BddDataSource implements LocalDataSource {
  final AppDatabase _db;
  BddDataSource(this._db);

  @override
  Stream<List<NoteModel>> watchAllNotes() {
    // Map the stream of NoteEntry (from Drift) to a stream of NoteModel.
    return _db.watchAllNotes().map((entries) {
      return entries
          .map(
            (e) => NoteModel(
              id: e.id,
              title: e.title,
              content: e.content,
              date: e.date,
              color: e.color,
            ),
          )
          .toList();
    });
  }

  @override
  Future<int> insertNote(NoteModel note) async {
    // Prepare a Drift companion for insertion (id will auto-generate).
    final companion = NotesCompanion.insert(
      title: note.title,
      content: note.content,
      date: note.date,
      color: note.color,
    );
    return _db.insertNote(companion);
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    if (note.id == null) {
      throw ArgumentError('Cannot update note without an id');
    }
    // Create a NoteEntry from the NoteModel and replace it in the database.
    final entry = NoteEntry(
      id: note.id!,
      title: note.title,
      content: note.content,
      date: note.date,
      color: note.color,
    );
    await _db.updateNoteEntry(entry);
  }

  @override
  Future<void> deleteNote(int id) async {
    await _db.deleteNoteById(id);
  }
}
