import 'package:flutter/material.dart';
import 'package:quiz_ai/screens/ai_generator_screen.dart';
import 'package:quiz_ai/screens/analytics_screen.dart';
import 'package:quiz_ai/screens/home_screen.dart';
import 'package:quiz_ai/screens/profile_screen.dart';
import 'package:quiz_ai/screens/quizzes_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const QuizzesScreen(),
    const AnalyticsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.quiz), label: 'Quizzes'),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'Analytics',
          ),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const AIQuizGeneratorScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Quiz'),
            )
          : null,
    );
  }
}
