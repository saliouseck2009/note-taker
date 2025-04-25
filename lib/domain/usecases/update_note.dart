import '../note_repository.dart';
import '../note_entity.dart';

/// Use case for updating an existing note.
class UpdateNoteUseCase {
  final NoteRepository _repository;
  UpdateNoteUseCase(this._repository);

  /// Updates the given [note] in the repository.
  Future<void> call(Note note) {
    return _repository.updateNote(note);
  }
}
