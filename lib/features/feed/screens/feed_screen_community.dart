import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/common/card_post.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/core/services/services.dart';
import 'package:reddit_app/features/auth/controller/auth_cubit.dart';
import 'package:reddit_app/features/community/controller/community_cubit.dart';
import 'package:reddit_app/features/community/controller/community_state.dart';
import 'package:reddit_app/features/post/controller/post_cubit.dart';
import 'package:reddit_app/features/post/controller/post_state.dart';

class FeedsCommunityScreen extends StatelessWidget {
  const FeedsCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CommunityCubit, CommunityState>(
        builder: (context, state) {
          final isGuest = !sl<AuthCubit>().state.userModel!.isAuthenticated;
          sl<PostCubit>().fetchUserPost(state.communityModel);
          sl<PostCubit>().fetchGuestPost();
          return BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              if (state.postModelList.isNotEmpty ||
                  state.postGuestModelList.isNotEmpty) {
                if (!isGuest && state.postModelList.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.postModelList.length,
                    itemBuilder: (context, index) {
                      final post = state.postModelList[index];
                      return CardPostWidget(
                        postModel: post,
                      );
                    },
                  );
                }
                if (isGuest && state.postGuestModelList.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.postGuestModelList.length,
                    itemBuilder: (context, index) {
                      final postGuest = state.postGuestModelList[index];
                      return CardPostWidget(
                        postModel: postGuest,
                      );
                    },
                  );
                }
                return const Loader();
              } else {
                return const Loader();
              }
            },
          );
        },
      ),
    );
  }
}
