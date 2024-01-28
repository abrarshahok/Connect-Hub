import 'package:connecthub/components/loading.dart';
import 'package:connecthub/constants/constants.dart';
import 'package:connecthub/features/app/presentation/screens/startup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../service_locator/service_locator.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../home/presentation/screens/home.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  void initState() {
    authBloc.add(AuthInitialEvent());
    super.initState();
  }

  final authBloc = ServiceLocator.instance.get<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: authBloc,
      builder: (context, state) {
        switch (state.runtimeType) {
          case const (AuthUserAuthenticationSuccessState):
            return const Home();
          case const (AuthUserUnAuthenticatedState):
            return StartupScreen();
          default:
            return Scaffold(
              body: const Loading(),
              backgroundColor: MyColors.primaryColor,
            );
        }
      },
    );
  }
}
