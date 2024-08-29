// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../bloc/forgotpassword/forgetpassword_bloc.dart';
// import '../../../bloc/forgotpassword/forgetpassword_event.dart';
// import '../../../bloc/forgotpassword/forgetpassword_state.dart';
// import '../login_screen.dart';
//
//
//
// class ResetPasswordScreen extends StatelessWidget {
//   final String email;
//   final TextEditingController _passwordController = TextEditingController();
//
//   ResetPasswordScreen({required this.email});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Reset Password'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
//           listener: (context, state) {
//             if (state is PasswordResetSuccess) {
//               Navigator.pushAndRemoveUntil(
//                 context,
//                 MaterialPageRoute(builder: (context) => const LoginScreen()),
//                     (Route<dynamic> route) => false,
//               );
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text('Password reset successful. Please log in with your new password.')),
//               );
//             } else if (state is ForgotPasswordFailure) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(content: Text(state.error)),
//               );
//             }
//           },
//           builder: (context, state) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Reset New Password',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 20,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     labelText: 'New Password',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     context.read<ForgotPasswordBloc>().add(
//                       NewPasswordSubmitted(email, _passwordController.text.trim()),
//                     );
//                   },
//                   child: Text('Set New Password'),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// // class ResetPasswordScreen extends StatelessWidget {
// //   final String email;
// //   final TextEditingController _passwordController = TextEditingController();
// //
// //   ResetPasswordScreen({required this.email});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Reset Password'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(20.0),
// //         child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
// //           listener: (context, state) {
// //             if (state is PasswordResetSuccess) {
// //               Navigator.popUntil(context, ModalRoute.withName('/login'));
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 SnackBar(content: Text('Password reset successful. Please log in with your new password.')),
// //               );
// //             } else if (state is ForgotPasswordFailure) {
// //               ScaffoldMessenger.of(context).showSnackBar(
// //                 SnackBar(content: Text(state.error)),
// //               );
// //             }
// //           },
// //           builder: (context, state) {
// //             return Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 const Text(
// //                   'Reset New Password',
// //                   style: TextStyle(
// //                     fontWeight: FontWeight.w600,
// //                     fontSize: 20,
// //                   ),
// //                 ),
// //                 SizedBox(height: 20),
// //                 TextField(
// //                   controller: _passwordController,
// //                   obscureText: true,
// //                   decoration: InputDecoration(
// //                     labelText: 'New Password',
// //                     border: OutlineInputBorder(),
// //                   ),
// //                 ),
// //                 SizedBox(height: 20),
// //                 ElevatedButton(
// //                   onPressed: () {
// //                     context.read<ForgotPasswordBloc>().add(
// //                       NewPasswordSubmitted(email, _passwordController.text.trim()),
// //                     );
// //                   },
// //                   child: Text('Set New Password'),
// //                 ),
// //               ],
// //             );
// //           },
// //         ),
// //       ),
// //     );
// //   }
// // }