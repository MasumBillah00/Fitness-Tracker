//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../bloc/auth_bloc.dart';
// import '../bloc/auth_state.dart';
// import '../home.dart';
// import '../login/loginpage.dart';
//
// class AuthWrapper extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthBloc, AuthState>(
//       builder: (context, state) {
//         if (state is LoggedOutState) {
//           return LoginPage();
//         } else if (state is LoggedInState) {
//           return HomePage();
//         } else {
//           return SizedBox();
//         }
//       },
//     );
//   }
// }
import 'package:fitness_tracker_app/view/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/login/login_bloc.dart';
import '../bloc/login/login_state.dart';
import '../login/loginpage.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is LoggedOutState) {
          return LoginPage();
        } else if (state is LoggedInState) {
          return HomeScreen();
        } else {
          return SizedBox();
        }
      },
    );
  }
}


