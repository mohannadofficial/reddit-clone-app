import 'package:flutter/material.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/services/services.dart';
import 'package:reddit_app/features/auth/controller/auth_cubit.dart';
import 'package:reddit_app/theme/pallete.dart';

class SignInButton extends StatelessWidget {
  final bool isLoginFrom;
  const SignInButton({super.key, this.isLoginFrom = true});

  void signInWithGoogle(BuildContext context) {
    sl<AuthCubit>().signInWithGoogle(context, isLoginFrom);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signInWithGoogle(context),
        icon: Image.asset(
          AppContants.googleImagePath,
          width: 35,
        ),
        label: const Text(
          'Continue with Google',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
