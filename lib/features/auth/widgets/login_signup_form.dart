import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/auth/bloc/auth_bloc.dart';
import '../../../components/custom_text_form_field.dart';
import '../../../constants/constants.dart';

enum AuthMode { login, signUp }

class LoginSignUpForm extends StatefulWidget {
  final AuthBloc authBloc;
  const LoginSignUpForm({super.key, required this.authBloc});

  @override
  State<LoginSignUpForm> createState() => _LoginSignUpFormState();
}

class _LoginSignUpFormState extends State<LoginSignUpForm> {
  AuthMode authMode = AuthMode.login;
  final formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  final authData = {
    'username': '',
    'email': '',
    'password': '',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Center(
                  child: Text(
                    'Connect Hub',
                    style: MyFonts.bodyFont(
                      fontWeight: FontWeight.bold,
                      fontColor: MyColors.secondaryColor,
                      fontSize: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                if (authMode == AuthMode.signUp) ...[
                  CustomTextFormField(
                    key: const ValueKey('username'),
                    label: 'Username',
                    onSaved: (username) {
                      authData['username'] = username!;
                    },
                    validator: (username) {
                      if (username!.isEmpty) {
                        return 'This field is required!';
                      } else if (username.trim().length < 4) {
                        return 'Username name must contain at least 4 characters.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                ],
                CustomTextFormField(
                  key: const ValueKey('email'),
                  label: 'Email',
                  onSaved: (email) {
                    authData['email'] = email!;
                  },
                  validator: (email) {
                    if (email!.isEmpty) {
                      return 'This field is required!';
                    } else if (!email.contains('@')) {
                      return 'Please enter valid email.';
                    }
                    return null;
                  },
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  key: const ValueKey('password'),
                  label: 'Password',
                  controller: _passwordController,
                  onSaved: (password) {
                    authData['password'] = password!;
                  },
                  validator: (password) {
                    if (password!.isEmpty) {
                      return 'This field is required!';
                    } else if (password.length < 6) {
                      return 'Password must contain at least 6 characters';
                    }
                    return null;
                  },
                  obscureText: true,
                ),
                if (authMode == AuthMode.signUp) ...[
                  const SizedBox(height: 10),
                  CustomTextFormField(
                    key: const ValueKey('confirm password'),
                    label: 'Confirm Password',
                    validator: (confirmPassword) {
                      if (confirmPassword!.trim() !=
                          _passwordController.text.trim()) {
                        return 'Password do not match.';
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                ],
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: onFormSubmitted,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    fixedSize: const Size(double.infinity, 50),
                    backgroundColor: MyColors.buttonColor1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: BlocBuilder<AuthBloc, AuthState>(
                    bloc: widget.authBloc,
                    buildWhen: (previous, current) =>
                        current is AuthActionState,
                    builder: (context, state) {
                      return state is AuthButtonLoadingActionState
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: MyColors.secondaryColor,
                              ),
                            )
                          : Text(
                              authMode == AuthMode.signUp ? 'Sign Up' : 'Login',
                              style: MyFonts.bodyFont(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontColor: MyColors.secondaryColor,
                              ),
                            );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      authMode == AuthMode.login
                          ? 'Not a member? '
                          : 'Already a member? ',
                      style: MyFonts.bodyFont(
                        fontColor: MyColors.secondaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: toggleAuthMode,
                      child: Text(
                        authMode == AuthMode.login ? 'Sign Up' : 'Login',
                        style: MyFonts.bodyFont(
                          fontColor: MyColors.buttonColor2,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toggleAuthMode() {
    setState(() {
      if (authMode == AuthMode.signUp) {
        authMode = AuthMode.login;
      } else {
        authMode = AuthMode.signUp;
      }
    });
  }

  void onFormSubmitted() {
    bool isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();
    if (authMode == AuthMode.login) {
      widget.authBloc.add(
        AuthLoginFormSubmitedEvent(
          email: authData['email']!,
          password: authData['password']!,
        ),
      );
    } else {
      widget.authBloc.add(AuthSignupFormSubmitedEvent(
        email: authData['email']!,
        password: authData['password']!,
        username: authData['username']!,
        userImage: null,
      ));
    }
  }
}
