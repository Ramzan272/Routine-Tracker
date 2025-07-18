import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'objectbox_helper.dart';
import 'quran_screen.dart';

late ObjectBoxHelper objectBoxHelper;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectBoxHelper = await ObjectBoxHelper.create();
  runApp(RoutineTrackerApp());
}

class RoutineTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Routine Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/quran-screen': (context) => QuranScreen(quranBox: objectBoxHelper.quranBox),
      },
    );
  }
}
