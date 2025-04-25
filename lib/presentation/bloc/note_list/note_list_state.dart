part of 'note_list_bloc.dart';

enum NoteSortField { date, title, color }


/// State of the notes list screen.
class NotesListState extends Equatable {
  final List<Note> notes;
  final NoteSortField sortField;
  final bool ascending;
  final bool isLoading;
  final String? errorMessage;

  const NotesListState({
    required this.notes,
    required this.sortField,
    required this.ascending,
    required this.isLoading,
    this.errorMessage,
  });

  factory NotesListState.initial() {
    return NotesListState(
      notes: [],
      sortField: NoteSortField.date,
      ascending: false, // false = descending by default for date
      isLoading: true,
      errorMessage: null,
    );
  }

  NotesListState copyWith({
    List<Note>? notes,
    NoteSortField? sortField,
    bool? ascending,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NotesListState(
      notes: notes ?? this.notes,
      sortField: sortField ?? this.sortField,
      ascending: ascending ?? this.ascending,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [notes, sortField, ascending, isLoading, errorMessage];
}