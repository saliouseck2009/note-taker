part of 'note_list_bloc.dart';

enum NoteSortField { date, title, color }

sealed class NotesListState extends Equatable {
  final List<Note> notes;
  final NoteSortField sortField;
  final bool ascending;

  const NotesListState({
    required this.notes,
    required this.sortField,
    required this.ascending,
  });

  @override
  List<Object?> get props => [notes, sortField, ascending];
}

final class NotesListInitial extends NotesListState {
  const NotesListInitial({
    required super.notes,
    required super.sortField,
    required super.ascending,
  });
  factory NotesListInitial.initial() {
    return NotesListInitial(
      notes: [],
      sortField: NoteSortField.date,
      ascending: false,
    );
  }
}

final class NotesListLoading extends NotesListState {
  const NotesListLoading({
    required super.notes,
    required super.sortField,
    required super.ascending,
  });
}

final class NotesListLoaded extends NotesListState {
  const NotesListLoaded({
    required super.notes,
    required super.sortField,
    required super.ascending,
  });
}

final class NotesListError extends NotesListState {
  final String errorMessage;
  const NotesListError({
    required super.notes,
    required super.sortField,
    required super.ascending,
    required this.errorMessage,
  });
}
