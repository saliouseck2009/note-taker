import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/constants.dart';
import 'package:note/domain/entities/note_entity.dart';
import 'package:note/domain/usecases/add_note.dart';
import 'package:note/domain/usecases/update_note.dart';

part 'note_form_event.dart';
part 'note_form_state.dart';

class NoteFormBloc extends Bloc<NoteFormEvent, NoteFormState> {
  // Use cases or repository for creating/updating notes (injected via constructor).
  final AddNoteUseCase _createNote;
  final UpdateNoteUseCase _updateNote;

  NoteFormBloc({
    required AddNoteUseCase createNoteUseCase,
    required UpdateNoteUseCase updateNoteUseCase,
    Note? initialNote,
  }) : _createNote = createNoteUseCase,
       _updateNote = updateNoteUseCase,
       super(
         NoteFormState(
           noteId: initialNote?.id,
           title: initialNote?.title ?? '',
           content: initialNote?.content ?? '',
           color: initialNote?.color ?? AppConstants.noteColorValues.first,
           date: initialNote?.date,
           isSaving: initialNote != null,
           errorMessage: null,
         ),
       ) {
    on<NoteFormTitleChanged>(_onTitleChanged);
    on<NoteFormContentChanged>(_onContentChanged);
    on<NoteFormColorChanged>(_onColorChanged);
    on<NoteFormSubmitted>(_onSubmitted);
  }

  void _onTitleChanged(
    NoteFormTitleChanged event,
    Emitter<NoteFormState> emit,
  ) {
    emit(
      state.copyWith(
        title: event.title,
        errorMessage: null, // Clear error message on title change
      ),
    );
  }

  void _onContentChanged(
    NoteFormContentChanged event,
    Emitter<NoteFormState> emit,
  ) {
    emit(
      state.copyWith(
        content: event.content,
        errorMessage: null, // Clear error message on content change
      ),
    );
  }

  void _onColorChanged(
    NoteFormColorChanged event,
    Emitter<NoteFormState> emit,
  ) {
    emit(state.copyWith(color: event.color, errorMessage: null));
  }

  void _onSubmitted(
    NoteFormSubmitted event,
    Emitter<NoteFormState> emit,
  ) async {
    emit(state.copyWith(errorMessage: null, isEditing: true));

    if (state.title.trim().isEmpty) {
      emit(state.copyWith(errorMessage: 'Title cannot be empty'));
      // emit(
      //   NoteFormFailure(
      //     noteId: state.noteId,
      //     title: state.title,
      //     content: state.content,
      //     color: state.color,
      //     date: state.date,
      //     error: 'Title cannot be empty',
      //   ),
      // );
      return;
    }
    emit(
      // NoteFormSaving(
      //   noteId: state.noteId,
      //   title: state.title,
      //   content: state.content,
      //   color: state.color,
      //   date: state.date,
      // ),
      state.copyWith(isEditing: true, errorMessage: null),
    );
    try {
      if (state.noteId == null) {
        // Create new note
        final newNote = Note(
          title: state.title,
          content: state.content,
          color: state.color,
          date: state.date ?? DateTime.now(),
        );
        await _createNote(newNote);
      } else {
        // Update existing note
        final updatedNote = Note(
          id: state.noteId,
          title: state.title,
          content: state.content,
          color: state.color,
          date: state.date ?? DateTime.now(),
        );
        await _updateNote(updatedNote);
      }
      emit(
        state.copyWith(isEditing: false, errorMessage: null, isSubmitted: true),
      );
    } catch (e) {
      emit(
        state.copyWith(isEditing: false, errorMessage: 'Error saving note: $e'),
      );
    }
  }
}
