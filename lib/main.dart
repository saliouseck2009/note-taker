import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:note/core/notification_service.dart';
import 'package:note/firebase_options.dart';
import 'core/app_theme.dart';
import 'core/injection.dart';
import 'presentation/pages/notes_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.instance.initialize();
  NotificationService.instance.getDeviceToken();
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
