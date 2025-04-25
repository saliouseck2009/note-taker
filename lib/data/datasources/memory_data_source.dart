import 'dart:async';
import 'package:note/data/models/note.dart';

import 'local_data_source.dart';

/// In-memory implementation of [LocalDataSource], useful for testing.
class MemoryDataSource implements LocalDataSource {
  final List<NoteModel> _notes = [];
  int _autoIncrementId = 0;
  late final StreamController<List<NoteModel>> _controller;

  MemoryDataSource() {
    // Broadcast controller that emits the current list on new subscriptions.
    _controller = StreamController<List<NoteModel>>.broadcast(
      onListen: () {
        _controller.sink.add(List<NoteModel>.from(_notes));
      },
    );
  }

  @override
  Stream<List<NoteModel>> watchAllNotes() {
    return _controller.stream;
  }

  @override
  Future<int> insertNote(NoteModel note) async {
    final newId = ++_autoIncrementId;
    note.id = newId;
    _notes.add(note);
    _controller.sink.add(List<NoteModel>.from(_notes));
    return newId;
  }

  @override
  Future<void> updateNote(NoteModel note) async {
    if (note.id == null) {
      throw ArgumentError('Cannot update note without an id');
    }
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index == -1) return;
    _notes[index] = note;
    _controller.sink.add(List<NoteModel>.from(_notes));
  }

  @override
  Future<void> deleteNote(int id) async {
    _notes.removeWhere((n) => n.id == id);
    _controller.sink.add(List<NoteModel>.from(_notes));
  }
}
