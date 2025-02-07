import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imnote_app/blocs/auth/auth_bloc.dart';
import 'package:imnote_app/blocs/note/note_bloc.dart';
import 'package:imnote_app/services/firebase_options.dart';
import 'package:imnote_app/services/auth_check_service.dart';
import 'package:imnote_app/services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    // Bloc Provider
    MultiBlocProvider(providers: [
      BlocProvider(create: (context) => AuthBloc()),
      BlocProvider(create: (context) => NoteBloc(FirestoreService())),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthCheckService(),
    );
  }
}
