
import 'package:fitness_tracker_app/view/stats/total_workout_stats.dart';
import 'package:flutter/material.dart';

class Fitness_Drawer extends StatelessWidget {
  final ValueChanged<int> onItemTapped;

  const Fitness_Drawer({
    super.key,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Drawer(
        child: SizedBox(
          width: screenWidth *0.5,
          child: Container(


            color: Colors.white.withOpacity(.12),
            child: ListView(
              padding: const EdgeInsets.only(
                right: 50,
                top: 8,
              ),
              children: <Widget>[
                SizedBox(
                  height: 90,
                  child: DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blueGrey[900], borderRadius: BorderRadius.circular(13)),
                    child: const Text(
                      'ToDo App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.black26,
                  child: ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text(
                      'Home',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      onItemTapped(0);
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
                ),
                Card(
                  color: Colors.black26,
                  child: ListTile(
                    leading: Icon(
                      Icons.library_books,
                      color: Colors.blueGrey[900],
                    ),
                    title: const Text(
                      'Workout List',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      onItemTapped(1);
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
                ),
                Card(
                  color: Colors.black26,
                  child: ListTile(
                    leading:  Icon(Icons.query_stats,color: Colors.blueGrey[900],),
                    title: const Text(
                      'Stats',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      onItemTapped(2);
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
                ),

                Card(
                  color: Colors.black26,
                  child: ListTile(
                    leading:  Icon(Icons.settings,
                      color: Colors.blueGrey[900],),
                    title: const Text(
                      'Setting',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      onItemTapped(3);
                      Navigator.of(context).pop(); // Close the drawer
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                // Card(
                //   child: ListTile(
                //     leading: const Icon(Icons.logout),
                //     title: const Text(
                //       'Logout',
                //       style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                //     ),
                //     onTap: () {
                //       context.read<LoginBloc>().add(Logout());
                //       Navigator.pushReplacement(
                //         context,
                //         MaterialPageRoute(builder: (context) => const LoginScreen()),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
