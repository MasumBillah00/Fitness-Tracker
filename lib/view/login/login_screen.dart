import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:fitness_tracker_app/view/screen/home_screen.dart';
import 'package:fitness_tracker_app/view/login/registration/registration.dart';
import '../../../bloc/login/login_bloc.dart';
import '../../../bloc/login/login_event.dart';
import '../../../bloc/login/login_state.dart';
import 'finger_print_login.dart';
import 'forgetpassword/forget_password_screen.dart';

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
  final LocalAuthentication auth = LocalAuthentication();
  bool _isFingerprintSupported = false;

  @override
  void initState() {
    super.initState();
    _loginBloc = context.read<LoginBloc>();
    emailController.addListener(_handleUserInteraction);
    passwordController.addListener(_handleUserInteraction);
    _checkFingerprintSupport();
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
    // Handle any user interaction, if needed
  }

  Future<void> _checkFingerprintSupport() async {
    final isSupported = await auth.canCheckBiometrics;
    setState(() {
      _isFingerprintSupported = isSupported;
    });
  }

  Future<void> _authenticateWithFingerprint() async {
    try {
      final isAuthenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        _loginBloc.add(LoginSubmitted()); // Assuming fingerprint authentication is successful
      }
    } catch (e) {
      print('Fingerprint authentication failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fingerprint authentication failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.success) {
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
                        style: TextStyle(color: Colors.blueGrey.shade900),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: passwordController,
                        focusNode: passwordFocusNode,
                        obscureText: true,
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
                          prefixIcon: Icon(Icons.lock, color: Colors.blueGrey.shade900),
                          hintStyle: TextStyle(color: Colors.blueGrey.shade900),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey.shade900, width: 2.0),
                            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey.shade900, width: 3.0),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueGrey.shade900),
                          ),
                        ),
                        style: TextStyle(color: Colors.blueGrey.shade900),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
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
                      const SizedBox(height: 20),
                      if (_isFingerprintSupported)
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FingerprintSetupScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.fingerprint),
                          label: const Text('Set up Fingerprint'),
                        ),
                      const SizedBox(height: 20),
                      if (_isFingerprintSupported)
                        ElevatedButton.icon(
                          onPressed: _authenticateWithFingerprint,
                          icon: const Icon(Icons.fingerprint),
                          label: const Text('Log in with Fingerprint'),
                        ),
                      const SizedBox(height: 5),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                            );
                          },
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              color: Colors.lightBlueAccent,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                          );
                        },
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
