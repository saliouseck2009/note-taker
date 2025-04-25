part of 'note_list_bloc.dart';

abstract class NotesListEvent extends Equatable {
  const NotesListEvent();
  @override
  List<Object?> get props => [];
}

class SortFieldChanged extends NotesListEvent {
  final NoteSortField field;
  const SortFieldChanged(this.field);
  @override
  List<Object?> get props => [field];
}

/// User toggled the sort order (asc/desc).
class SortOrderToggled extends NotesListEvent {}

/// User requested deletion of a note.
class DeleteNoteRequested extends NotesListEvent {
  final int id;
  const DeleteNoteRequested(this.id);
  @override
  List<Object?> get props => [id];
}

/// Internal event: new notes list received from data source.
class _NotesUpdated extends NotesListEvent {
  final List<Note> notes;
  const _NotesUpdated(this.notes);
  @override
  List<Object?> get props => [notes];
}

/// Internal event: error occurred while loading notes.
class _NotesLoadError extends NotesListEvent {
  final Object error;
  const _NotesLoadError(this.error);
  @override
  List<Object?> get props => [error];
}
