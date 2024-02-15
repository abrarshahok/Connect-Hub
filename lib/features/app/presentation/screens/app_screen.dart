import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/components/loading.dart';
import '/constants/constants.dart';
import '/features/app/presentation/screens/startup_screen.dart';
import '/features/app/presentation/screens/no_internet_connection.dart';
import '../../../../service_locator/service_locator.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../home/presentation/screens/home.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  ConnectivityResult? _internetConnectivityResult;

  @override
  void initState() {
    super.initState();
    authBloc.add(AuthInitialEvent());
    _checkInternetConnectivity();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _internetConnectivityResult = result;
      });
    });
  }

  Future<void> _checkInternetConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _internetConnectivityResult = connectivityResult;
    });
  }

  final authBloc = ServiceLocator.instance.get<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    if (_internetConnectivityResult == ConnectivityResult.none) {
      return const NoInternetConnection();
    }
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
