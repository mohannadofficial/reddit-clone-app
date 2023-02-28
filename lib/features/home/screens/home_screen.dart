import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/core/services/services.dart';
import 'package:reddit_app/features/auth/controller/auth_cubit.dart';
import 'package:reddit_app/features/auth/controller/auth_state.dart';
import 'package:reddit_app/features/feed/screens/feed_screen_community.dart';
import 'package:reddit_app/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_app/features/home/drawer/community_drawer.dart';
import 'package:reddit_app/features/home/drawer/profile_drawer.dart';
import 'package:reddit_app/features/post/screens/add_post_community.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void openCommunityDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void openEndCommunityDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanged(int index) {
    sl<AuthCubit>().onPageChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      const FeedsCommunityScreen(),
      const AddPostCommunityScreen(),
    ];

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state.userModel == null) {
          return const Loader();
        }
        return Scaffold(
          appBar: AppBar(
            leading: Builder(builder: (context) {
              return IconButton(
                icon: const Icon(
                  Icons.menu,
                ),
                onPressed: (() => openCommunityDrawer(context)),
              );
            }),
            title: const Text(
              'Create a community',
            ),
            centerTitle: false,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                ),
                onPressed: () {
                  showSearch(
                      context: context, delegate: SearchCommunityDelegate());
                },
              ),
              Builder(builder: (context) {
                return IconButton(
                  icon: CircleAvatar(
                    backgroundImage: NetworkImage(state.userModel!.profilePic),
                  ),
                  onPressed: () => openEndCommunityDrawer(context),
                );
              }),
            ],
          ),
          body: Center(
            child: screens[state.currentIndex],
          ),
          drawer: const CommunityDrawer(),
          endDrawer: const ProfileDrawer(),
          bottomNavigationBar: !state.userModel!.isAuthenticated
              ? null
              : CupertinoTabBar(
                  activeColor: state.themeData!.iconTheme.color,
                  backgroundColor: state.themeData!.backgroundColor,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.add),
                      label: '',
                    ),
                  ],
                  onTap: onPageChanged,
                  currentIndex: state.currentIndex,
                ),
        );
      },
    );
  }
}
