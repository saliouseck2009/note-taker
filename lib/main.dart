import 'package:flutter/material.dart';
import 'package:note/presentation/bloc/note_list/note_list_bloc.dart';
import 'core/app_theme.dart';
import 'core/injection.dart';
import 'presentation/pages/notes_list_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => NotesListBloc(
                getNotesUseCase: getIt(),
                deleteNoteUseCase: getIt(),
              ),
        ),
      ],
      child: MaterialApp(
        title: 'Notes App',
        theme: AppTheme.darkTheme,
        home: const NotesListPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
