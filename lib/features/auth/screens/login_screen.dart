import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/core/common/sign_in_button.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/services/services.dart';
import 'package:reddit_app/core/utils.dart';
import 'package:reddit_app/features/auth/controller/auth_cubit.dart';
import 'package:reddit_app/features/auth/controller/auth_state.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  void signInAsGuest(BuildContext context) {
    sl<AuthCubit>().signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Image.asset(
              AppContants.logoImagePath,
              height: 40,
            ),
            actions: [
              TextButton(
                onPressed: () => signInAsGuest(context),
                child: const Text(
                  'Skip',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          body: state.requestState == RequestState.loading
              ? const Loader()
              : Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Dive into anything',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        AppContants.emoteImagePath,
                        height: 300,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SignInButton(),
                  ],
                ),
        );
      },
    );
  }
}
