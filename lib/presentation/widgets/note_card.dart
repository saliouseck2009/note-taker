import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/note_entity.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback? onTap;
  final VoidCallback? onDismissed;
  const NoteCard({super.key, required this.note, this.onTap, this.onDismissed});

  @override
  Widget build(BuildContext context) {
    final cardColor = Color(note.color);
    final brightness = ThemeData.estimateBrightnessForColor(cardColor);
    final textColor =
        brightness == Brightness.dark ? Colors.white : Colors.black;
    final titleStyle = TextStyle(
      color: textColor,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
    final contentStyle = TextStyle(color: textColor, fontSize: 16);
    final dateStyle = TextStyle(
      color: textColor.withValues(alpha: 0.8),
      fontSize: 12,
      fontStyle: FontStyle.italic,
    );
    final formattedDate = DateFormat.yMMMd().format(note.date);

    return Dismissible(
      key: ValueKey(note.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        if (onDismissed != null) onDismissed!();
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (note.title.isNotEmpty) Text(note.title, style: titleStyle),
                if (note.title.isNotEmpty) const SizedBox(height: 4),
                if (note.content.isNotEmpty)
                  Text(
                    note.content,
                    style: contentStyle,
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text(formattedDate, style: dateStyle)],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
