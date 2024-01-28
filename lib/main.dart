import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '/constants/constants.dart';
import '/features/app/presentation/screens/app_screen.dart';
import '/features/auth/presentation/screens/auth_screen.dart';
import '/features/profile/presentation/screens/profile_settings_screen.dart';
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
      home: ScreenUtilInit(
        designSize: const Size(360, 650),
        ensureScreenSize: true,
        builder: (context, _) => const AppScreen(),
      ),
      routes: {
        AddPostScreen.routeName: (context) => AddPostScreen(),
        UploadPostScreen.routeName: (context) => UploadPostScreen(),
        LikesScreen.routeName: (context) => const LikesScreen(),
        CommentsScreen.routeName: (context) => CommentsScreen(),
        AuthScreen.routeName: (context) => const AuthScreen(),
        ProfileSettingsScreen.routeName: (context) => ProfileSettingsScreen(),
      },
    );
  }
}
