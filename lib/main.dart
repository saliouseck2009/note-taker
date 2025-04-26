import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'core/injection.dart';
import 'presentation/pages/notes_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies(useMemoryDataSource: false);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: AppTheme.darkTheme,
      home: const NotesListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
