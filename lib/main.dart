import 'package:flutter/material.dart';
import 'package:task_manager/core/di/dependency_injection.dart';
import 'package:task_manager/presentation/pages/note/note_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFB4D464)),
        useMaterial3: true,
      ),
      home: const NotePage(),
    );
  }
}
