import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/services/services.dart';
import 'package:reddit_app/features/auth/controller/auth_cubit.dart';
import 'package:reddit_app/features/auth/controller/auth_state.dart';
import 'package:reddit_app/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends StatelessWidget {
  const ProfileDrawer({super.key});

  void logOut(BuildContext context) {
    sl<AuthCubit>().logOut();
  }

  void navigateToUserProfile(BuildContext context) {
    Routemaster.of(context).push('/u/$uid/True');
  }

  void toggleTheme() {
    sl<AuthCubit>().toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final user = state.userModel!;
          return Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
                radius: 70,
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(
                  'u/${user.name}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () {},
              ),
              const Divider(),
              if (state.userModel!.isAuthenticated)
                ListTile(
                  title: const Text('My Profile'),
                  leading: const Icon(Icons.person),
                  onTap: () => navigateToUserProfile(context),
                ),
              if (state.userModel!.isAuthenticated)
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Pallete.redColor,
                  ),
                  title: const Text(
                    'Log out',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  onTap: () => logOut(context),
                ),
              Switch.adaptive(
                onChanged: (value) {
                  toggleTheme();
                },
                value:
                    sl<AuthCubit>().state.themeData == Pallete.darkModeAppTheme,
              )
            ],
          );
        },
      )),
    );
  }
}
