import 'package:note/core/mappers/note.dart';
import 'package:note/data/models/note.dart';

import '../../domain/repositories/note_repository.dart';
import '../../domain/entities/note_entity.dart';
import '../datasources/local/local_data_source.dart';

/// Implementation of the NoteRepository that uses a LocalDataSource.
class NoteRepositoryImpl implements NoteRepository {
  final LocalDataSource _localDataSource;
  NoteRepositoryImpl(this._localDataSource);

  @override
  Stream<List<Note>> watchAllNotes() {
    // Convert stream of NoteModel to stream of domain Note.
    return _localDataSource.watchAllNotes().map((models) {
      return models.map((m) => m.toEntity()).toList();
    });
  }

  @override
  Future<void> addNote(Note note) async {
    // Use current time as creation date (if not provided).
    final model = NoteModel(
      title: note.title,
      content: note.content,
      date: note.date,
      color: note.color,
      id: null,
    );
    await _localDataSource.insertNote(model);
  }

  @override
  Future<void> updateNote(Note note) async {
    if (note.id == null) {
      throw ArgumentError('Cannot update note without an id');
    }
    final model = NoteModel(
      id: note.id,
      title: note.title,
      content: note.content,
      date: note.date,
      color: note.color,
    );
    await _localDataSource.updateNote(model);
  }

  @override
  Future<void> deleteNote(int id) async {
    await _localDataSource.deleteNote(id);
  }
}
