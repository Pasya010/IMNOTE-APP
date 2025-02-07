import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imnote_app/blocs/auth/auth_bloc.dart';
import 'package:imnote_app/blocs/auth/auth_event.dart';
import 'package:imnote_app/blocs/auth/auth_state.dart';
import 'package:imnote_app/screens/home_screen.dart';
import 'package:imnote_app/screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Container(
            height: 400,
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
                      'Sign In',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),

                  SizedBox(height: 50),

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
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => HomeScreen()));
                      } else if (state is AuthError) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed To Login')));
                      }
                    },
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Column(
                        children: [
                          // Sign In Button
                          ElevatedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(SignInRequested(
                                  email: emailController.text,
                                  password: passwordController.text));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black),
                            child: Text(
                              'Sign In',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),

                          SizedBox(height: 15),

                          // Register Section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Not a member yet? '),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              RegisterScreen()));
                                },
                                child: Text('Register now!',
                                    style: TextStyle(color: Colors.blue)),
                              )
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
