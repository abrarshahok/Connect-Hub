import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '/features/posts/screens/add_post_screen.dart';
import '/features/auth/screens/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Auth(),
      routes: {
        AddPostScreen.routeName: (context) =>  AddPostScreen(),
      },
    );
  }
}
