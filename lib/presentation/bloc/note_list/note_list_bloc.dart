import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/constants.dart';
import 'package:note/domain/entities/note_entity.dart';
import 'package:note/domain/usecases/delete_note.dart';
import 'package:note/domain/usecases/get_notes.dart';

part 'note_list_event.dart';
part 'note_list_state.dart';

class NotesListBloc extends Bloc<NotesListEvent, NotesListState> {
  final GetNotesUseCase _getNotes;
  final DeleteNoteUseCase _deleteNote;
  late StreamSubscription<List<Note>> _notesStreamSub;

  NotesListBloc({
    required GetNotesUseCase getNotesUseCase,
    required DeleteNoteUseCase deleteNoteUseCase,
  }) : _getNotes = getNotesUseCase,
       _deleteNote = deleteNoteUseCase,
       super(NotesListInitial.initial()) {
    on<SortFieldChanged>(_onSortFieldChanged);
    on<SortOrderToggled>(_onSortOrderToggled);
    on<DeleteNoteRequested>(_onDeleteNoteRequested);
    on<_NotesUpdated>(_onNotesUpdated);
    on<_NotesLoadError>(_onNotesLoadError);

    // Subscribe to the notes stream from repository
    _notesStreamSub = _getNotes.call().listen(
      (notes) => add(_NotesUpdated(notes)),
      onError: (error) => add(_NotesLoadError(error)),
    );
  }

  void _onSortFieldChanged(
    SortFieldChanged event,
    Emitter<NotesListState> emit,
  ) {
    final newField = event.field;
    final sorted = _sortNotes(state.notes, newField, state.ascending);
    emit(
      NotesListLoaded(
        notes: sorted,
        sortField: newField,
        ascending: state.ascending,
      ),
    );
  }

  void _onSortOrderToggled(
    SortOrderToggled event,
    Emitter<NotesListState> emit,
  ) {
    final newAsc = !state.ascending;
    final sorted = _sortNotes(state.notes, state.sortField, newAsc);
    emit(
      NotesListLoaded(
        notes: sorted,
        sortField: state.sortField,
        ascending: newAsc,
      ),
    );
  }

  void _onDeleteNoteRequested(
    DeleteNoteRequested event,
    Emitter<NotesListState> emit,
  ) async {
    final id = event.id;

    try {
      await _deleteNote.call(id);
    } catch (error) {
      emit(
        NotesListError(
          notes: state.notes,
          sortField: state.sortField,
          ascending: state.ascending,
          errorMessage: 'Error deleting note: $error',
        ),
      );
    }
  }

  void _onNotesUpdated(_NotesUpdated event, Emitter<NotesListState> emit) {
    final sortedList = _sortNotes(
      event.notes,
      state.sortField,
      state.ascending,
    );
    emit(
      NotesListLoaded(
        notes: sortedList,
        sortField: state.sortField,
        ascending: state.ascending,
      ),
    );
  }

  void _onNotesLoadError(_NotesLoadError event, Emitter<NotesListState> emit) {
    emit(
      NotesListError(
        notes: state.notes,
        sortField: state.sortField,
        ascending: state.ascending,
        errorMessage: 'Error deleting note: ${event.error}',
      ),
    );
  }

  List<Note> _sortNotes(List<Note> notes, NoteSortField field, bool asc) {
    final sorted = List<Note>.from(notes);
    sorted.sort((a, b) {
      int comparison;
      switch (field) {
        case NoteSortField.date:
          comparison = a.date.compareTo(b.date);
          break;
        case NoteSortField.title:
          comparison = a.title.toLowerCase().compareTo(b.title.toLowerCase());
          break;
        case NoteSortField.color:
          // Sort by index in the predefined color palette (see AppConstants).
          final indexA = AppConstants.noteColorValues.indexOf(a.color);
          final indexB = AppConstants.noteColorValues.indexOf(b.color);
          comparison = indexA.compareTo(indexB);
          break;
      }
      return asc ? comparison : -comparison;
    });
    return sorted;
  }

  @override
  Future<void> close() {
    _notesStreamSub.cancel();
    return super.close();
  }
}
