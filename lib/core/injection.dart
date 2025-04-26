import 'package:get_it/get_it.dart';
import 'package:note/domain/usecases/add_note.dart';
import 'package:note/domain/usecases/delete_note.dart';
import 'package:note/domain/usecases/get_notes.dart';
import 'package:note/domain/usecases/update_note.dart';
import '../data/datasources/local/bdd_data_source.dart';
import '../data/datasources/local/memory_data_source.dart';
import '../data/datasources/local/local_data_source.dart';
import '../data/repositories/note_repository_impl.dart';
import '../domain/repositories/note_repository.dart';
import '../data/datasources/local/database/app_database.dart';

final getIt = GetIt.instance;

/// Configure dependencies for the entire app (Service Locator).
void configureDependencies({bool useMemoryDataSource = false}) {
  // Database (Drift) instance
  getIt.registerLazySingleton<AppDatabase>(() => AppDatabase());
  // Choose local data source: Drift database or in-memory
  if (useMemoryDataSource) {
    getIt.registerLazySingleton<LocalDataSource>(() => MemoryDataSource());
  } else {
    getIt.registerLazySingleton<LocalDataSource>(
      () => BddDataSource(getIt<AppDatabase>()),
    );
  }
  /*
  // Register the local data source with intance name to distinguish between them
  getIt.registerLazySingleton<LocalDataSource>(
    () => getIt<LocalDataSource>(),
    instanceName: 'localDataSource',
  );
  !Info getIt<LocalDataSource>(instanceName: 'localDataSource');
  getIt.registerLazySingleton<LocalDataSource>(
    () => getIt<LocalDataSource>(),
    instanceName: 'memoryDataSource',
  );
  !Info getIt<LocalDataSource>(instanceName: 'memoryDataSource');
  */

  // Repository
  getIt.registerLazySingleton<NoteRepository>(
    () => NoteRepositoryImpl(getIt<LocalDataSource>()),
  );
  // Use cases
  getIt.registerLazySingleton(() => GetNotesUseCase(getIt<NoteRepository>()));
  getIt.registerLazySingleton(() => AddNoteUseCase(getIt<NoteRepository>()));
  getIt.registerLazySingleton(() => UpdateNoteUseCase(getIt<NoteRepository>()));
  getIt.registerLazySingleton(() => DeleteNoteUseCase(getIt<NoteRepository>()));
}
