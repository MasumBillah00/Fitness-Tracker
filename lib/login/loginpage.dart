
import 'dart:async';
import 'package:fitness_tracker_app/login/time_maneger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_event.dart';
import '../bloc/login/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();
  late TimerManager _timerManager;

  @override
  void initState() {
    super.initState();
    _timerManager = TimerManager(
      context: context,
      initialTime: 60,
      onTick: _updateTimerDisplay,
    );
    WidgetsBinding.instance.addObserver(this); // Add observer to listen for app lifecycle changes
  }

  void _updateTimerDisplay() {
    setState(() {}); // Trigger a rebuild to update the timer display
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // Start the inactivity timer when app becomes inactive
      _timerManager.startInactivityTimer();
    } else if (state == AppLifecycleState.resumed) {
      // Reset timers when the app becomes active
      _timerManager.resetTimers();
    }
  }

  Future<void> _checkBiometrics() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Biometric authentication not available.')),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _authenticate() async {
    try {
      bool isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to log in',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      if (isAuthenticated) {
        context.read<AuthBloc>().add(LoginEvent(
          email: _emailController.text,
          password: _passwordController.text,
        ));
        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
        _timerManager.startLogoutTimer(); // Start timer using TimerManager
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication failed')),
        );
      }
    } on PlatformException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication error occurred')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _timerManager.dispose(); // Dispose the timer manager
    WidgetsBinding.instance.removeObserver(this); // Remove the observer
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoggedInState) {
            Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
            _timerManager.startLogoutTimer(); // Start timer using TimerManager
          } else if (state is LoginFailedState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email, color: Colors.blueGrey.shade900),
                          hintStyle: TextStyle(color: Colors.blueGrey.shade900),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey.shade900, width: 2.0),
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey.shade900, width: 3.0),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Enter your Password',
                          prefixIcon: Icon(Icons.lock, color: Colors.blueGrey.shade900),
                          hintStyle: TextStyle(color: Colors.blueGrey.shade900),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey.shade900, width: 2.0),
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey.shade900, width: 3.0),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(LoginEvent(
                                email: _emailController.text,
                                password: _passwordController.text,
                              ));
                            }
                          },
                          child: const Text('Login'),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Center(
                        child: ElevatedButton(
                          onPressed: _authenticate,
                          child: const Text('Authenticate with Biometric'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:local_auth/local_auth.dart';
//
// import '../bloc/login/login_bloc.dart';
// import '../bloc/login/login_event.dart';
// import '../bloc/login/login_state.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final LocalAuthentication _localAuth = LocalAuthentication();
//   Timer? _logoutTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkBiometrics();
//   }
//
//   Future<void> _checkBiometrics() async {
//     try {
//       final isAvailable = await _localAuth.canCheckBiometrics;
//       if (!isAvailable) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Biometric authentication not available.')),
//         );
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   Future<void> _authenticate() async {
//     try {
//       bool isAuthenticated = await _localAuth.authenticate(
//         localizedReason: 'Please authenticate to log in',
//         options: const AuthenticationOptions(
//           biometricOnly: true,
//         ),
//       );
//
//       if (isAuthenticated) {
//         context.read<AuthBloc>().add(LoginEvent(
//           email: _emailController.text,
//           password: _passwordController.text,
//         ));
//         Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
//         _startLogoutTimer();  // Start logout timer on successful login
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Authentication failed')),
//         );
//       }
//     } on PlatformException catch (e) {
//       print(e);
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Authentication error occurred')),
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _logoutTimer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   title: const Text('Login'),
//       // ),
//       body: BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is LoggedInState) {
//             Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
//             _startLogoutTimer();  // Start logout timer on successful login
//           } else if (state is LoginFailedState) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text(state.message)),
//             );
//           }
//         },
//         child: Container(
//           decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: AssetImage('assets/images/background1.jpg'),
//             fit: BoxFit.cover,
//           ),
//         ),
//           child: Form(
//             key: _formKey,
//             child: Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   TextFormField(
//                     controller: _emailController,
//                 decoration: InputDecoration(
//                           hintText: 'Enter your email',
//                           prefixIcon: Icon(Icons.email, color: Colors.blueGrey.shade900),
//                           hintStyle: TextStyle(color: Colors.blueGrey.shade900),
//                           enabledBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blueGrey.shade900, width: 2.0),
//                             borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blueGrey.shade900, width: 3.0),
//                           ),
//                         ),
//                       //   style: TextStyle(color: Colors.blueGrey.shade900),
//                       // ),
//                    keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16.0),
//                   TextFormField(
//                     controller: _passwordController,
//                     decoration: InputDecoration(
//                       hintText: 'Enter your Password',
//                       prefixIcon: Icon(Icons.lock, color: Colors.blueGrey.shade900),
//                       hintStyle: TextStyle(color: Colors.blueGrey.shade900),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.blueGrey.shade900, width: 2.0),
//                         borderRadius: const BorderRadius.all(Radius.circular(10.0)),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.blueGrey.shade900, width: 3.0),
//                       ),
//                     ),
//                     obscureText: true,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters long';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 16.0),
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           context.read<AuthBloc>().add(LoginEvent(
//                             email: _emailController.text,
//                             password: _passwordController.text,
//                           ));
//                         }
//                       },
//                       child: const Text('Login'),
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                   Center(
//                     child: ElevatedButton(
//                       onPressed: _authenticate,
//                       child: const Text('Authenticate with Biometric'),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   void _startLogoutTimer() {
//     _logoutTimer?.cancel();
//     _logoutTimer = Timer(const Duration(seconds: 10), () {
//       context.read<AuthBloc>().add(LogoutEvent());
//       Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
//     });
//   }
// }
