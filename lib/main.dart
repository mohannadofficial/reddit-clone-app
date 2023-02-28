import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/services/services.dart';
import 'package:reddit_app/core/utils.dart';
import 'package:reddit_app/features/auth/controller/auth_cubit.dart';
import 'package:reddit_app/features/auth/controller/auth_state.dart';
import 'package:reddit_app/features/community/controller/community_cubit.dart';
import 'package:reddit_app/features/post/controller/post_cubit.dart';
import 'package:reddit_app/firebase_options.dart';
import 'package:reddit_app/router.dart';
import 'package:routemaster/routemaster.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ServicesLocator().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<AuthCubit>()
            ..getTheme()
            ..getCurrentUser(),
        ),
        BlocProvider(
          create: (context) => sl<CommunityCubit>()..getUserCommunities(),
        ),
        BlocProvider(
          create: (context) => sl<PostCubit>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Reddit App',
          theme: state.themeData,
          routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
            if (state.requestState == RequestState.loaded) {
              return loggedInRoute;
            } else {
              return loggedOutRoute;
            }
          }),
          routeInformationParser: const RoutemasterParser(),
        );
      },
    );
  }
}
