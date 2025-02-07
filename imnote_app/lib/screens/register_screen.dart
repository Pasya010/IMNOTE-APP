import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imnote_app/blocs/auth/auth_bloc.dart';
import 'package:imnote_app/blocs/auth/auth_event.dart';
import 'package:imnote_app/blocs/auth/auth_state.dart';
import 'package:imnote_app/screens/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              height: 450,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Text(
                        'Register',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),

                    SizedBox(height: 50),

                    // Enter Username
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20)),
                          hintText: 'Username',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20))),
                    ),

                    SizedBox(height: 25),

                    // Enter Email
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20)),
                          hintText: 'Email',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20))),
                    ),

                    SizedBox(height: 25),

                    // Enter Password
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20)),
                          hintText: 'Password',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20))),
                    ),

                    SizedBox(height: 15),

                    BlocConsumer<AuthBloc, AuthState>(
                      listener: (context, state) {
                        if (state is Authenticated) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Register Success')));
                        } else if (state is AuthError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.message)));
                        }
                      },
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ElevatedButton(
                          onPressed: () {
                            if (usernameController.text.isEmpty ||
                                emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Please fill all fields!")));
                              return;
                            }
                            context.read<AuthBloc>().add(RegisterRequested(
                                username: usernameController.text,
                                email: emailController.text,
                                password: passwordController.text));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          child: Text('Register',
                              style: TextStyle(color: Colors.white)),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
