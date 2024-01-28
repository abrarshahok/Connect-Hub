import 'package:connecthub/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/components/show_snackbar.dart';
import '../../../home/presentation/screens/home.dart';
import '../widgets/login_signup_form.dart';
import '../bloc/auth_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  static const routeName = '/auth-screen';
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    authBloc.add(AuthInitialEvent());
    super.initState();
  }

  final authBloc = ServiceLocator.instance.get<AuthBloc>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: authBloc,
      listenWhen: (previous, current) => current is AuthActionState,
      buildWhen: (previous, current) => current is! AuthActionState,
      listener: (context, state) {
        if (state is AuthLoginFailedActionState) {
          ShowSnackBar(
            context: context,
            label: 'Login Failed!',
            color: Colors.red,
          ).show();
        } else if (state is AuthSignUpFailedActionState) {
          ShowSnackBar(
            context: context,
            label: 'SignUp Failed!',
            color: Colors.red,
          ).show();
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case const (AuthUserAuthenticationSuccessState):
            return const Home();
          case const (AuthUserUnAuthenticatedState):
            return const LoginSignUpForm();
          default:
            return const SizedBox();
        }
      },
    );
  }
}
