// import 'package:flutter/material.dart';
// import 'package:local_auth/local_auth.dart';
//
// class FingerprintSetupScreen extends StatefulWidget {
//   const FingerprintSetupScreen({Key? key}) : super(key: key);
//
//   @override
//   State<FingerprintSetupScreen> createState() => _FingerprintSetupScreenState();
// }
//
// class _FingerprintSetupScreenState extends State<FingerprintSetupScreen> {
//   final LocalAuthentication auth = LocalAuthentication();
//   bool _isFingerprintSetup = false;
//
//   Future<void> _setupFingerprint() async {
//     try {
//       final isAuthenticated = await auth.authenticate(
//         localizedReason: 'Set up fingerprint authentication',
//         options: const AuthenticationOptions(
//           stickyAuth: true,
//         ),
//       );
//
//       if (isAuthenticated) {
//         setState(() {
//           _isFingerprintSetup = true;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Fingerprint setup successful')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Fingerprint setup failed: $e')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Set Up Fingerprint')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: _setupFingerprint,
//           child: const Text('Set Up Fingerprint'),
//         ),
//       ),
//     );
//   }
// }
