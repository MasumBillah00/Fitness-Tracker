// import 'package:fitness_tracker_app/view/login/forgetpassword/reset_password_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../bloc/forgotpassword/forgetpassword_bloc.dart';
// import '../../../bloc/forgotpassword/forgetpassword_event.dart';
// import '../../../bloc/forgotpassword/forgetpassword_state.dart';
//
//
// class OtpScreen extends StatelessWidget {
//   final String email;
//   final TextEditingController _otpController = TextEditingController();
//
//   OtpScreen({required this.email});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Confirm OTP'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
//           listener: (context, state) {
//             if (state is OtpVerified) {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ResetPasswordScreen(email: email),
//                 ),
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
//                 Text(
//                   'Enter OTP',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 20,
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 TextField(
//                   controller: _otpController,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(
//                     labelText: 'OTP',
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     context.read<ForgotPasswordBloc>().add(
//                       OtpSubmitted(email, _otpController.text.trim()),
//                     );
//                   },
//                   child: Text('Verify'),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }