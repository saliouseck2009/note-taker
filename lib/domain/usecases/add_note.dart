import '../note_repository.dart';
import '../note_entity.dart';

/// Use case for adding a new note.
class AddNoteUseCase {
  final NoteRepository _repository;
  AddNoteUseCase(this._repository);

  /// Adds the given [note] to the repository.
  Future<void> call(Note note) {
    return _repository.addNote(note);
  }
}
