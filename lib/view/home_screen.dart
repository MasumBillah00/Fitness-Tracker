import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/workout_bloc.dart';
import '../bloc/workout_state.dart';
import '../widget/textformfield.dart';
import '../widget/workout_formfield.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  final _durationController = TextEditingController();
  String dropdownValue = 'Select Workout Type';

  // Map to hold calorie burn rates per minute
  final Map<String, int> calorieRates = {
    'Running': 10,
    'Walking': 5,
    'PushUP': 8,
    'Endurance': 7,
  };

  void _calculateCalories() {
    final duration = int.tryParse(_durationController.text) ?? 0;
    final rate = calorieRates[dropdownValue] ?? 0;
    final totalCalories = duration * rate;

    setState(() {
      _nameController.text = totalCalories.toString(); // Update controller text
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Tracker'),
      ),
      body: BlocBuilder<WorkoutBloc, WorkoutState>(
        builder: (context, state) {
          if (state is WorkoutsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WorkoutsLoaded) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Workout Calculator',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    WorkoutFormField(
                      label: 'Workout Type',
                      dropdownValue: dropdownValue,
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            dropdownValue = newValue;
                            _calculateCalories(); // Recalculate calories when workout type changes
                          });
                        }
                      },
                    ),
                    WorkoutTextFormField(
                      label: 'Duration (in minutes)',
                      controller: _durationController,
                      onChanged: (text) {
                        _calculateCalories(); // Recalculate calories when duration changes
                      },
                    ),
                    WorkoutTextFormField(
                      label: 'Burn Calories',
                      controller: _nameController,
                      readOnly: true,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong!'));
          }
        },
      ),
    );
  }
}
