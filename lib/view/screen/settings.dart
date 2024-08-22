// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/login/login_bloc.dart';
// import '../bloc/login/login_event.dart';
// import '../bloc/login/login_state.dart';
// import 'login/login_screen.dart';
//
// class MyScreen extends StatelessWidget {
//   const MyScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Home'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               context.read<LoginBloc>().add(Logout());
//             },
//           ),
//         ],
//       ),
//       body: BlocListener<LoginBloc, LoginState>(
//         listener: (context, state) {
//           if (state.status == LoginStatus.loggedOut) {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => const LoginScreen()),
//             );
//           }
//         },
//         child: const Center(child: Text('Welcome to Home Screen')),
//       ),
//     );
//   }
// }
