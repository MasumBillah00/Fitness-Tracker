
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_event.dart';
import '../view/login/login_screen.dart';

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
      child: Container(
        width: screenWidth * 0.6,
        child: Drawer(
          child: SizedBox(

            child: Container(



              color: Colors.white.withOpacity(.12),
              child: ListView(
                padding: const EdgeInsets.only(
                  right: 5,
                  top: 8,
                ),
                children: <Widget>[
                  SizedBox(
                    height: 80,
                    child: DrawerHeader(
                      decoration: BoxDecoration(color: Colors.blueGrey[900], borderRadius: BorderRadius.circular(13)),
                      child: const Text(
                        'Fitness Tracker',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    color: Colors.blueGrey.shade800,
                    child: ListTile(
                      leading: const Icon(Icons.home, color: Colors.white),
                      title: const Text(
                        'Home',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                      onTap: () {
                        onItemTapped(0);
                        Navigator.of(context).pop(); // Close the drawer
                      },
                    ),
                  ),
                  Card(
                    color: Colors.blueGrey.shade800,
                    child: ListTile(
                      leading: Icon(
                        Icons.library_books,
                          color: Colors.white
                      ),
                      title: const Text(
                        'Workout List',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                      onTap: () {
                        onItemTapped(1);
                        Navigator.of(context).pop(); // Close the drawer
                      },
                    ),
                  ),
                  Card(
                    color: Colors.blueGrey.shade800,
                    child: ListTile(
                      leading:  Icon(Icons.bar_chart_outlined, color: Colors.white),
                      title: const Text(
                        'Stats',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                      onTap: () {
                        onItemTapped(2);
                        Navigator.of(context).pop(); // Close the drawer
                      },
                    ),
                  ),

                  Card(
                    color: Colors.blueGrey.shade800,
                    child: ListTile(
                      leading:  Icon(Icons.query_stats,
                          color: Colors.white),
                      title: const Text(
                        'Progress',
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500,
                            color: Colors.white),
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

                  Card(
                    color: Colors.blueGrey.shade800,
                    child: ListTile(
                      leading: const Icon(Icons.logout,color: Colors.white,),
                      title: const Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w500,
                          color: Colors.white

                        ),
                      ),
                      onTap: () {
                        context.read<LoginBloc>().add(Logout());
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
