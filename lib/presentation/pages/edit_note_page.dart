import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/core/constants.dart';
import 'package:note/core/injection.dart';
import 'package:note/domain/entities/note_entity.dart';
import 'package:note/presentation/bloc/note_form/note_form_bloc.dart';

class EditNotePage extends StatelessWidget {
  final Note? note;
  const EditNotePage({super.key, this.note});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) => NoteFormBloc(
            createNoteUseCase: getIt(),
            updateNoteUseCase: getIt(),
            initialNote: note,
          ),
      child: BlocConsumer<NoteFormBloc, NoteFormState>(
        listenWhen:
            (previous, current) =>
                current.isSubmitted || current.errorMessage != null,
        listener: (context, state) {
          if (state.isSubmitted) {
            Navigator.of(context).pop(true);
          } else if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          final brightness = ThemeData.estimateBrightnessForColor(
            Color(state.color),
          );
          final appBarContentColor =
              brightness == Brightness.dark ? Colors.white : Colors.black;
          return Scaffold(
            // bottomNavigationBar: Container(
            //   color: Theme.of(context).scaffoldBackgroundColor,
            //   padding: const EdgeInsets.fromLTRB(
            //     16,
            //     8,
            //     80,
            //     8,
            //   ), // leave space for FAB on right
            //   child: NoteColorPicker(
            //     selectedColor: color,
            //     onColorSelected: (value) {
            //       context.read<NoteFormBloc>().add(NoteFormColorChanged(value));
            //     },
            //   ),
            // ),
            appBar: AppBar(
              iconTheme: IconThemeData(color: appBarContentColor),
              backgroundColor: Color(state.color),
              title: Text(
                note == null ? 'New Note' : 'Edit Note',
                style: TextStyle(color: appBarContentColor),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Color(state.color),
              foregroundColor: appBarContentColor,
              onPressed:
                  state.isSaving
                      ? null
                      : () {
                        context.read<NoteFormBloc>().add(
                          const NoteFormSubmitted(),
                        );
                      },
              tooltip: 'Save Note',
              child: Icon(Icons.save),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                NoteTextField(
                  label: 'Title',
                  initialValue: state.title,
                  onChanged: (value) {
                    context.read<NoteFormBloc>().add(
                      NoteFormTitleChanged(value),
                    );
                  },
                ),
                Expanded(
                  child: NoteEditor(
                    initialContent: state.content,
                    onChanged: (value) {
                      context.read<NoteFormBloc>().add(
                        NoteFormContentChanged(value),
                      );
                    },
                  ),
                ),
                NoteColorPicker(
                  selectedColor: state.color,
                  onColorSelected: (value) {
                    context.read<NoteFormBloc>().add(
                      NoteFormColorChanged(value),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NoteTextField extends StatelessWidget {
  final String label;
  final String initialValue;
  final ValueChanged<String> onChanged;
  const NoteTextField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      decoration: const InputDecoration(
        hintText: 'Title',
        border: InputBorder.none,
      ),
    );
  }
}

class NoteEditor extends StatelessWidget {
  final String initialContent;
  final ValueChanged<String> onChanged;
  const NoteEditor({
    super.key,
    required this.initialContent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialContent,
      onChanged: onChanged,
      maxLines: null,
      expands: true,
      textAlignVertical: TextAlignVertical.top,
      keyboardType: TextInputType.multiline,
      decoration: const InputDecoration(
        hintText: 'Type your note here...',
        border: InputBorder.none,
      ),
    );
  }
}

// note_color_picker.dart

class NoteColorPicker extends StatelessWidget {
  final int selectedColor;
  final ValueChanged<int> onColorSelected;
  const NoteColorPicker({
    super.key,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    // A set of preset colors for notes
    final colors = AppConstants.noteColors;
    return Row(
      children:
          colors.map((color) {
            final colorValue = color.toARGB32();
            final bool selected = selectedColor == colorValue;
            return GestureDetector(
              onTap: () => onColorSelected(colorValue),
              child: Container(
                width: 35,
                height: 35,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border:
                      selected
                          ? Border.all(color: Colors.white, width: 3)
                          : null,
                ),
              ),
            );
          }).toList(),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:note/domain/usecases/add_note.dart';
import 'package:note/domain/usecases/update_note.dart';
import '../../domain/note_entity.dart';
import '../../core/constants.dart';
import '../../core/injection.dart';

/// Note editing/adding page with a full-screen text editor and color selection.
class EditNotePage extends StatefulWidget {
  final Note?
  note; // if provided, editing an existing note; if null, adding a new note.
  const EditNotePage({super.key, this.note});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late int _selectedColorValue;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(
      text: widget.note?.content ?? '',
    );
    // Default to note's color if editing, otherwise use the first color in palette.
    _selectedColorValue =
        widget.note?.color ?? AppConstants.noteColorValues.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.note != null;
    return Scaffold(
      // No AppBar (use system back to go back) to let editor take full screen.
      floatingActionButton: FloatingActionButton(
        onPressed: _saveNote,
        tooltip: 'Save Note',
        child: const Icon(Icons.save, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          80,
          8,
        ), // leave space for FAB on right
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:
              AppConstants.noteColors.map((color) {
                final colorValue = color.value;
                final bool selected = _selectedColorValue == colorValue;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColorValue = colorValue;
                    });
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border:
                          selected
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title text field
              TextField(
                controller: _titleController,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 8),
              // Content text field (multiline)
              Expanded(
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    hintText: 'Type your note here...',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveNote() async {
    final title = _titleController.text;
    final content = _contentController.text;
    if (title.isEmpty && content.isEmpty) {
      // If note is empty, just return without saving.
      Navigator.of(context).pop();
      return;
    }
    if (widget.note == null) {
      // Add a new note
      final newNote = Note(
        title: title,
        content: content,
        date: DateTime.now(),
        color: _selectedColorValue,
        id: null,
      );
      await getIt<AddNoteUseCase>()(newNote);
    } else {
      // Update existing note (keep the original creation date)
      final updatedNote = Note(
        title: title,
        content: content,
        date: widget.note!.date,
        color: _selectedColorValue,
        id: widget.note!.id,
      );
      await getIt<UpdateNoteUseCase>()(updatedNote);
    }
    // Go back to the previous screen (note list) after saving.
    Navigator.of(context).pop();
  }
}

*/
