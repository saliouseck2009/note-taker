import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Drift table definition for notes.
@DataClassName('NoteEntry')
class Notes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 0, max: 255)();
  TextColumn get content => text().named('body')();
  IntColumn get color => integer()();
  DateTimeColumn get date => dateTime()();
}

/// Drift database that includes the Notes table.
@DriftDatabase(tables: [Notes])
class AppDatabase extends _$AppDatabase {
  // Ensure to run build_runner to generate the part file for Drift.
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// Stream of all notes ordered by date descending (latest first).
  Stream<List<NoteEntry>> watchAllNotes() {
    return (select(notes)..orderBy([
      (tbl) => OrderingTerm(expression: tbl.date, mode: OrderingMode.desc),
    ])).watch();
  }

  /// Inserts a new note and returns its generated id.
  Future<int> insertNote(NotesCompanion noteCompanion) {
    return into(notes).insert(noteCompanion);
  }

  /// Updates an existing note (replaces it).
  Future<bool> updateNoteEntry(NoteEntry entry) {
    return update(notes).replace(entry);
  }

  /// Deletes a note by id.
  Future<int> deleteNoteById(int id) {
    return (delete(notes)..where((t) => t.id.equals(id))).go();
  }
}

/// Opens the database (using Drift's native SQLite implementation).
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'notes_db.sqlite'));
    return NativeDatabase(file);
  });
}
