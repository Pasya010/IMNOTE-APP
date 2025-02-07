import 'package:flutter/material.dart';
import 'package:imnote_app/screens/home_screen.dart';
import 'package:imnote_app/screens/reminder_screen.dart';
import 'package:imnote_app/screens/profile_screen.dart';

class PagesNavigator extends StatefulWidget {
  const PagesNavigator({super.key});

  @override
  State<PagesNavigator> createState() => _PagesNavigatorState();
}

class _PagesNavigatorState extends State<PagesNavigator> {
  int selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    HomeScreen(),
    ReminderScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.grey.shade800,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade700,
          onTap: navigateBottomBar,
          currentIndex: selectedIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications_active_outlined),
                label: 'Reminder'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'Profile'),
          ]),
    );
  }
}
