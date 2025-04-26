import '../repositories/note_repository.dart';
import '../entities/note_entity.dart';

/// Use case for retrieving all notes as a stream.
class GetNotesUseCase {
  final NoteRepository _repository;
  GetNotesUseCase(this._repository);

  /// Returns a stream of notes list that updates whenever notes change.
  Stream<List<Note>> call() {
    return _repository.watchAllNotes();
  }
}
