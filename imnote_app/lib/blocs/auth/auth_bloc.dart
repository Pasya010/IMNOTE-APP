import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imnote_app/blocs/auth/auth_event.dart';
import 'package:imnote_app/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AuthBloc() : super(AuthInitial()) {
    on<SignInRequested>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          await _auth.signInWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );

          emit(Authenticated());
        } catch (e) {
          emit(AuthError(message: 'Error: $e'));
        }
      },
    );

    on<RegisterRequested>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          final UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            email: event.email,
            password: event.password,
          );

          await _firestore
              .collection('users')
              .doc(userCredential.user?.uid)
              .set({
            'username': event.username,
            'email': event.email,
            'uid': userCredential.user?.uid,
          });

          emit(Authenticated());
        } on FirebaseAuthException catch (e) {
          emit(AuthError(message: e.message ?? 'Failed to register'));
        }
      },
    );

    on<SignOutRequested>(
      (event, emit) async {
        await _auth.signOut();

        emit(Unauthenticated());
      },
    );
  }
}
