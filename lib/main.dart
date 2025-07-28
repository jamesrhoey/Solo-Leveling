import 'package:flutter/material.dart';
import 'package:my_app/pages/Listitems.dart';
import 'package:my_app/pages/addQuests.dart';
import 'package:my_app/pages/dashboard.dart';
import 'package:my_app/pages/settings.dart';
import 'package:my_app/pages/shop.dart';
import 'package:my_app/pages/character.dart';
import 'package:my_app/pages/splash_screen.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Questify - Level Up Your Life',
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => MainNavigation(),
        '/quest': (context) => Listitems(),
        '/add': (context) => AddQuests(),
        '/settings': (context) => Settings(),
        '/shop': (context) => Shop(),
        '/character': (context) => Character(),
      },
      initialRoute: '/splash',
    ),
  );
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [Dashboard(), Listitems(), Settings()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent back button from working
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Color.fromARGB(255, 45, 45, 45),
          selectedItemColor: Color.fromARGB(255, 172, 245, 0),
          unselectedItemColor: Colors.white70,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Quests'),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
