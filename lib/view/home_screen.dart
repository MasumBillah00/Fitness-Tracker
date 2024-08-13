import 'package:fitness_tracker_app/view/settings.dart';
import 'package:fitness_tracker_app/view/stats/stats.dart';
import 'package:fitness_tracker_app/view/stats/total_workout_stats.dart';
import 'package:fitness_tracker_app/view/workoutcalculator.dart';
import 'package:fitness_tracker_app/widget/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'workout_list.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of pages to navigate between
  final List<Widget> _pages = [
    const WorkoutCalculator(),
    const WorkoutList(),
    const StatsPage(),
    //const TotalWorkoutStats(),
    const SettingsPage(),
    // Assuming WorkoutList is a page to display workout details
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fitness Tracker'),
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.list),
          //     onPressed: () {
          //       // Navigate to WorkoutList screen
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) =>  Fitness_Drawer(onItemTapped: _onItemTapped)),
          //       );
          //     },
          //   ),
          //
          // ],
      
        ),
        drawer: Fitness_Drawer(onItemTapped: _onItemTapped),
        body: _pages[_selectedIndex], // Display the selected page
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
      
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Workouts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Setting',
            ),
      
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.blueGrey, // Set background color
          selectedItemColor: Colors.amber, // Color of selected icon and label
          unselectedItemColor: Colors.white70, // Color of unselected icons and labels
          showUnselectedLabels: true, // Show labels for unselected items
          type: BottomNavigationBarType.fixed, // Ensures the text and icons remain at a fixed size
          elevation: 10, // Add a shadow to the bar
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
