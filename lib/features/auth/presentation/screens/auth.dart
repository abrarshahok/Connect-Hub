import 'package:connecthub/service_locator/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/components/show_snackbar.dart';
import '../../home/screens/home.dart';
import '/features/auth/widgets/login_signup_form.dart';
import '../bloc/auth_bloc.dart';

class Auth extends StatefulWidget {
  const Auth({super.key});

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  void initState() {
    authBloc.add(AuthInitialEvent());
    super.initState();
  }

  final AuthBloc authBloc = ServiceLocator.instance.get<AuthBloc>();

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
