// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'note_form_bloc.dart';

class NoteFormState extends Equatable {
  final int? noteId; // null if new note, non-null if editing existing note
  final String title;
  final String content;
  final int color;
  final DateTime? date;
  final bool isSaving;
  final String? errorMessage;
  final bool isSubmitted;

  const NoteFormState({
    this.noteId,
    required this.title,
    required this.content,
    required this.color,
    this.date,
    required this.isSaving,
    this.errorMessage,
    this.isSubmitted = false,
  });

  NoteFormState copyWith({
    int? noteId,
    String? title,
    String? content,
    int? color,
    DateTime? date,
    bool? isEditing,
    String? errorMessage,
    bool? isSubmitted,
  }) {
    return NoteFormState(
      noteId: noteId ?? this.noteId,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      date: date ?? this.date,
      isSaving: isEditing ?? isSaving,
      errorMessage: errorMessage ?? this.errorMessage,
      isSubmitted: isSubmitted ?? this.isSubmitted,
    );
  }

  @override
  List<Object?> get props => [
    noteId,
    title,
    content,
    color,
    date,
    isSaving,
    errorMessage,
    isSubmitted,
  ];
}

// /// Initial or editing state of the note form, holding current field values.
// final class NoteFormInitial extends NoteFormState {
//   NoteFormInitial({
//     super.noteId,
//     required super.title,
//     required super.content,
//     required super.color,
//     super.date,
//   });
// }

// /// State when the form submission is in progress (saving to database).
// final class NoteFormSaving extends NoteFormState {
//   const NoteFormSaving({
//     super.noteId,
//     required super.title,
//     required super.content,
//     required super.color,
//     super.date,
//   });
// }

// /// State when the note was successfully saved.
// final class NoteFormSuccess extends NoteFormState {
//   const NoteFormSuccess({
//     super.noteId,
//     required super.title,
//     required super.content,
//     required super.color,
//     super.date,
//   });
// }

// /// State when saving the note failed.
// final class NoteFormFailure extends NoteFormState {
//   final String error;
//   const NoteFormFailure({
//     super.noteId,
//     required super.title,
//     required super.content,
//     required super.color,
//     super.date,
//     required this.error,
//   });
// }
