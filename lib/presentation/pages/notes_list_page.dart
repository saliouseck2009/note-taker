import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note/domain/note_entity.dart';
import 'package:note/presentation/bloc/note_list/note_list_bloc.dart';
import '../../presentation/widgets/note_card.dart';
import 'edit_note_page.dart';

class NotesListPage extends StatelessWidget {
  const NotesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notesBloc = context.read<NotesListBloc>();
    return Scaffold(
      appBar: AppBar(title: const Text('Your notes')),
      body: BlocBuilder<NotesListBloc, NotesListState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.errorMessage != null) {
            return Center(
              child: Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 16),
              ),
            );
          }
          return Column(
            children: [
              SortOptions(
                state: state,
                onSortFieldChanged:
                    (field) => notesBloc.add(SortFieldChanged(field)),
                onSortOrderToggled: () => notesBloc.add(SortOrderToggled()),
              ),
              Expanded(
                child: NotesList(
                  notes: state.notes,
                  onNoteTap: (note) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditNotePage(note: note),
                      ),
                    );
                  },
                  onNoteDismissed:
                      (noteId) => notesBloc.add(DeleteNoteRequested(noteId)),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const EditNotePage()));
        },
        tooltip: 'Add Note',
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}

class SortOptions extends StatelessWidget {
  final NotesListState state;
  final ValueChanged<NoteSortField> onSortFieldChanged;
  final VoidCallback onSortOrderToggled;

  const SortOptions({
    super.key,
    required this.state,
    required this.onSortFieldChanged,
    required this.onSortOrderToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('Date'),
            selected: state.sortField == NoteSortField.date,
            onSelected: (_) => onSortFieldChanged(NoteSortField.date),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Title'),
            selected: state.sortField == NoteSortField.title,
            onSelected: (_) => onSortFieldChanged(NoteSortField.title),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Color'),
            selected: state.sortField == NoteSortField.color,
            onSelected: (_) => onSortFieldChanged(NoteSortField.color),
          ),
          const Spacer(),
          IconButton(
            icon: Icon(
              state.ascending ? Icons.arrow_upward : Icons.arrow_downward,
            ),
            tooltip: state.ascending ? 'Ascending' : 'Descending',
            onPressed: onSortOrderToggled,
          ),
        ],
      ),
    );
  }
}

class NotesList extends StatelessWidget {
  final List<Note> notes;
  final ValueChanged<Note> onNoteTap;
  final ValueChanged<int> onNoteDismissed;

  const NotesList({
    super.key,
    required this.notes,
    required this.onNoteTap,
    required this.onNoteDismissed,
  });

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return NoItemsWidget();
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          onTap: () => onNoteTap(note),
          onDismissed: () => onNoteDismissed(note.id!),
        );
      },
    );
  }
}

class NoItemsWidget extends StatelessWidget {
  const NoItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No notes yet. Tap + to add.',
        style: TextStyle(fontSize: 16, color: Colors.white70),
      ),
    );
  }
}
