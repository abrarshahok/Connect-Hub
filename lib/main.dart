import 'package:connecthub/features/chat/screens/chat_users_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import '/constants/constants.dart';
import '/features/auth/screens/auth.dart';
import '/features/posts/screens/likes_screen.dart';
import '/features/posts/screens/comments_screen.dart';
import '/features/posts/screens/add_post_screen.dart';
import '/features/posts/screens/upload_post_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: MyColors.primaryColor,
      systemNavigationBarColor: MyColors.primaryColor,
    ),
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
        ),
      ),
      home: const Auth(),
      routes: {
        AddPostScreen.routeName: (context) => AddPostScreen(),
        UploadPostScreen.routeName: (context) => UploadPostScreen(),
        LikesScreen.routeName: (context) => const LikesScreen(),
        CommentsScreen.routeName: (context) => CommentsScreen(),
        ChatUsersScreen.routeName: (context) => const ChatUsersScreen(),
      },
    );
  }
}
