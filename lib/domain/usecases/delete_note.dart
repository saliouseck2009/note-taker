import '../repositories/note_repository.dart';

/// Use case for deleting a note by id.
class DeleteNoteUseCase {
  final NoteRepository _repository;
  DeleteNoteUseCase(this._repository);

  /// Deletes the note with the given [id] from the repository.
  Future<void> call(int id) {
    return _repository.deleteNote(id);
  }
}
