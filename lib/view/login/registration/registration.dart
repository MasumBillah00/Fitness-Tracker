import 'package:fitness_tracker_app/view/screen/home_screen.dart';
import 'package:fitness_tracker_app/view/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import '../../../bloc/login/login_event.dart' as login_event;
import '../../../bloc/registration/registration_bloc.dart';
import '../../../bloc/registration/registration_event.dart' as registration_event;
import '../../../bloc/registration/registration_state.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  late RegistrationBloc _registrationBloc;

  @override
  void initState() {
    super.initState();
    _registrationBloc = context.read<RegistrationBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Registration'),
      // ),
      body: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state.status == RegistrationStatus.success) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          } else if (state.status == RegistrationStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<RegistrationBloc, RegistrationState>(
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
                      TextFormField(
                        onChanged: (value) {
                          _registrationBloc.add(registration_event.EmailChanged(value));
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter email';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter your email',
                          prefixIcon: Icon(Icons.email,),
                          //hintStyle: TextStyle(color: Colors.white54),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.white, width: 2.0),
                          //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          // ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.white, width: 3.0),
                          // ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        obscureText: true,
                        onChanged: (value) {
                          _registrationBloc.add(registration_event.PasswordChanged(value));
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter password';
                          } else if (value.length < 5) {
                            return 'Password must be at least 5 characters';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Enter your password',
                          prefixIcon: Icon(Icons.lock,),
                          // hintStyle: TextStyle(color: Colors.white54),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.white, width: 2.0),
                          //   borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          // ),
                          // focusedBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.white, width: 3.0),
                          // ),
                          // border: OutlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.white),
                          // ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _registrationBloc.add(registration_event.RegistrationSubmitted());
                          }
                        },
                        // style: ElevatedButton.styleFrom(
                        //   foregroundColor: Colors.white,
                        //   backgroundColor: Colors.blue,
                        //   padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   elevation: 5,
                        // ),
                        child: state.status == RegistrationStatus.loading
                            ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            : const Text('Register'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                            onPressed: (){
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => const LoginScreen()),
                              // );
                            },
                            child: const Text('Already have an account?',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),)),
                      )
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
