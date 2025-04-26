part of 'note_form_bloc.dart';

sealed class NoteFormEvent {
  const NoteFormEvent();
}

/// Event triggered when the note title text changes.
final class NoteFormTitleChanged extends NoteFormEvent {
  final String title;
  const NoteFormTitleChanged(this.title);
}

/// Event triggered when the note content text changes.
final class NoteFormContentChanged extends NoteFormEvent {
  final String content;
  const NoteFormContentChanged(this.content);
}

/// Event triggered when the note color selection changes.
final class NoteFormColorChanged extends NoteFormEvent {
  final int color;
  const NoteFormColorChanged(this.color);
}

/// Event triggered when the form is submitted (save note).
final class NoteFormSubmitted extends NoteFormEvent {
  const NoteFormSubmitted();
}
