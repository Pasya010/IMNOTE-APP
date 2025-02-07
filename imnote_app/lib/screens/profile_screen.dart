import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imnote_app/blocs/auth/auth_bloc.dart';
import 'package:imnote_app/blocs/auth/auth_event.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: GestureDetector(
        onTap: () {
          context.read<AuthBloc>().add(SignOutRequested());
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.logout),
            ),
            Text(
              'Logout',
              style: TextStyle(fontSize: 20),
            )
          ],
        ),
      )),
    );
  }
}
