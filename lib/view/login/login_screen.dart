import 'dart:async';

import 'package:fitness_tracker_app/view/home_screen.dart';
import 'package:fitness_tracker_app/view/login/registration/registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/login/login_bloc.dart';
import '../../../bloc/login/login_event.dart';
import '../../../bloc/login/login_state.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  late LoginBloc _loginBloc;
  //bool _rememberMe = false;
  String? _savedPassword;
  bool _showPasswordDialog = true;
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _loginBloc = context.read<LoginBloc>();
    //_loadRememberMe();
    emailController.addListener(_handleUserInteraction);
    passwordController.addListener(_handleUserInteraction);
  }

  @override
  void dispose() {
    emailController.removeListener(_handleUserInteraction);
    passwordController.removeListener(_handleUserInteraction);
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  void _handleUserInteraction() {
    if (_showPasswordDialog && _savedPassword != null) {
      _showPasswordDialog = false;
      _showPasswordNotification();
    }
  }

  // void _loadRememberMe() async {
  //   final isFirstTime = await LoginDatabaseHelper().isFirstTime();
  //   final rememberMeInfo = await LoginDatabaseHelper().loadRememberMe();
  //   if (rememberMeInfo != null && rememberMeInfo['remember_me'] == 1) {
  //     emailController.text = rememberMeInfo['email'];
  //     _savedPassword = rememberMeInfo['password'];
  //     setState(() {
  //       _rememberMe = true;
  //     });
  //     // Trigger BLoC events for initial values
  //     _loginBloc.add(EmailChanged(emailController.text));
  //     _loginBloc.add(PasswordChanged(_savedPassword ?? ''));
  //
  //     if (!isFirstTime) {
  //       _showPasswordNotification();
  //     }
  //   }
  //   // Update the first-time flag after checking
  //   await LoginDatabaseHelper().saveFirstTimeFlag(false);
  // }
  //
  // void _saveRememberMe() async {
  //   if (_rememberMe) {
  //     await LoginDatabaseHelper().saveRememberMe(
  //       emailController.text,
  //       passwordController.text,
  //       _rememberMe,
  //     );
  //   } else {
  //     await LoginDatabaseHelper().clearRememberMe();
  //   }
  // }

  void _showPasswordNotification() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Auto-fill Password?'),
          content: Text('Do you want to fill in the saved password for ${emailController.text}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                if (_savedPassword != null) {
                  passwordController.text = _savedPassword!;
                  _loginBloc.add(PasswordChanged(_savedPassword!));
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
           // _saveRememberMe();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (state.status == LoginStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            return Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/background1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //  Center(
                      //   child: Text(
                      //     'Login',
                      //     style: TextStyle(
                      //       fontSize: 40,
                      //       fontWeight: FontWeight.bold,
                      //       color: Colors.red,
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: emailController,
                        focusNode: emailFocusNode,
                        onChanged: (value) {
                          _loginBloc.add(EmailChanged(value));
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        decoration:  InputDecoration(
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
                        style:  TextStyle(color: Colors.blueGrey.shade900),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        obscureText: !_isPasswordVisible,
                        onChanged: (value) {
                          _loginBloc.add(PasswordChanged(value));
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter password';
                          } else if (value.length < 5) {
                            return 'Password must be at least 5 characters';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon:  Icon(Icons.lock, color: Colors.blueGrey.shade900),
                          hintStyle:  TextStyle(color: Colors.blueGrey.shade900),
                          enabledBorder:  OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey.shade900, width: 2.0),
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder:  OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey.shade900, width: 3.0),
                          ),
                          border:  OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey.shade900),
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Colors.blueGrey.shade900,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                  if (_isPasswordVisible) {
                                    Timer(const Duration(milliseconds: 400),
                                            () {
                                          setState(() {
                                            _isPasswordVisible = false;
                                          });
                                        });
                                  }
                                });
                              }
                          ),
                        ),
                        style:  TextStyle(color: Colors.blueGrey.shade900),
                      ),
                      const SizedBox(height: 2),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     Checkbox(
                      //       value: _rememberMe,
                      //       onChanged: (value) {
                      //         setState(() {
                      //           _rememberMe = value ?? false;
                      //         });
                      //       },
                      //     ),
                      //     const Text(
                      //       'Remember Me',
                      //       style: TextStyle(color: Colors.white),
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        // style: ElevatedButton.styleFrom(
                        //    foregroundColor: Colors.white,
                        //  backgroundColor: Colors.blue,
                        //   padding: const EdgeInsets.symmetric(horizontal: 150, vertical: 10),
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   elevation: 5,
                        // ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _loginBloc.add(LoginSubmitted());
                          }
                        },
                        child: state.status == LoginStatus.loading
                            ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : const Text(
                          'Log In',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: TextButton(
                      //     onPressed: () {
                      //       // Navigator.push(
                      //       //   context,
                      //       //   MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                      //       // );
                      //     },
                      //     child: const Text(
                      //       'Forgot password?',
                      //       style: TextStyle(
                      //         color: Colors.lightBlueAccent,
                      //         fontWeight: FontWeight.w500,
                      //         fontSize: 16,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                          );
                        },
                        // style: ElevatedButton.styleFrom(
                        //   foregroundColor: Colors.white,
                        //   backgroundColor: Colors.green,
                        //   padding: const EdgeInsets.symmetric(
                        //     horizontal: 20,
                        //     vertical: 10,
                        //   ),
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        // ),
                        child: const Text(
                          'Create an Account',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}