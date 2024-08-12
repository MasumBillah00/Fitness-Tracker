import 'package:flutter/material.dart';

// Define your custom ThemeData
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.blueGrey,
      primary: Colors.blueGrey.shade800,
      secondary: Colors.amber,
    ),
    useMaterial3: true,

    // Define the default font family
    fontFamily: 'Roboto',

    // Define the default text theme
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey.shade600,
      ),
      titleMedium: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey.shade700,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16.0,
        color: Colors.black87,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14.0,
        color: Colors.black54,
      ),
    ),

    // Define the default button theme
    buttonTheme: const ButtonThemeData(
      buttonColor: Colors.deepPurple,
      textTheme: ButtonTextTheme.primary,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.blueGrey.shade700),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        elevation: WidgetStateProperty.all(5.0),
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),

    // Define the default input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      filled: true,
      fillColor: Colors.deepPurple[50],
    ),

    // Define the default app bar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blueGrey,
      foregroundColor: Colors.white,
      elevation: 4.0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}
