import 'package:flutter/material.dart';
import 'quran_screen.dart';
import 'gym_screen.dart';
import 'objectbox_helper.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Future<ObjectBoxHelper> _objectBoxHelperFuture;

  @override
  void initState() {
    super.initState();
    _objectBoxHelperFuture = ObjectBoxHelper.create();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ObjectBoxHelper>(
        future: _objectBoxHelperFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final objectBoxHelper = snapshot.data!;
            if (objectBoxHelper.quranBox == null || objectBoxHelper.gymBox == null) {
              return Center(child: Text('Error initializing data boxes.'));
            }

            final screens = [
              QuranScreen(quranBox: objectBoxHelper.quranBox),
              GymScreen(gymBox: objectBoxHelper.gymBox),
            ];

            return screens[_selectedIndex];
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Quran',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'GYM',
          ),
        ],
      ),
    );
  }
}
