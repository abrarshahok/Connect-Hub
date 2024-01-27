import 'package:connecthub/constants/constants.dart';
import 'package:connecthub/features/app/presentation/screens/app_screen.dart';
import 'package:connecthub/features/auth/presentation/screens/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import '/service_locator/service_locator.dart';
import 'features/posts/presentation/screens/likes_screen.dart';
import 'features/posts/presentation/screens/comments_screen.dart';
import 'features/posts/presentation/screens/add_post_screen.dart';
import 'features/posts/presentation/screens/upload_post_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // SettingUp service Locators
  ServiceLocator.setupLocators();
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
        pageTransitionsTheme: customPageTransitionsTheme,
      ),
      home: const AppScreen(),
      routes: {
        AddPostScreen.routeName: (context) => const AddPostScreen(),
        UploadPostScreen.routeName: (context) => UploadPostScreen(),
        LikesScreen.routeName: (context) => const LikesScreen(),
        CommentsScreen.routeName: (context) => const CommentsScreen(),
        AuthScreen.routeName: (context) => const AuthScreen()
      },
    );
  }
}
