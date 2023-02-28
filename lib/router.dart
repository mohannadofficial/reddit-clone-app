import 'package:flutter/material.dart';
import 'package:reddit_app/features/auth/screens/login_screen.dart';
import 'package:reddit_app/features/community/screens/add_mods_community_screen.dart';
import 'package:reddit_app/features/community/screens/community_screen.dart';
import 'package:reddit_app/features/community/screens/create_community_screen.dart';
import 'package:reddit_app/features/community/screens/edit_community_screen.dart';
import 'package:reddit_app/features/community/screens/mod_tools_screen.dart';
import 'package:reddit_app/features/home/screens/home_screen.dart';
import 'package:reddit_app/features/post/screens/add_type_post_community.dart';
import 'package:reddit_app/features/post/screens/comment_post_community.dart';
import 'package:reddit_app/features/user_profile/screens/edit_profile_screen.dart';
import 'package:reddit_app/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) =>
      const MaterialPage(child: CreateCommunityScreen()),
  '/r/:name': (route) => MaterialPage(
        child: CommunityScreen(
          name: route.pathParameters['name']!,
        ),
      ),
  '/mod-tools/:name': (route) => MaterialPage(
          child: ModToolsScreen(
        name: route.pathParameters['name']!,
      )),
  '/edit-community/:name': (route) => MaterialPage(
          child: EditCommunityScreen(
        name: route.pathParameters['name']!,
      )),
  '/add-mods/:name': (route) => MaterialPage(
          child: AddModsCommunityScreen(
        name: route.pathParameters['name']!,
      )),
  '/u/:uid/:isOwner': (route) => MaterialPage(
        child: UserProfileScreen(
          uid: route.pathParameters['uid']!,
          isOwner: route.pathParameters['isOwner']!,
        ),
      ),
  '/edit-screen/': (_) => const MaterialPage(child: EditUserProfileScreen()),
  '/add/post/:type': (route) => MaterialPage(
          child: AddTypePostCommunityScreen(
        type: route.pathParameters['type']!,
      )),
  '/post/:postId/comments': (route) => MaterialPage(
        child: CommentPostCommunityScreen(
          postId: route.pathParameters['postId']!,
        ),
      ),
});
