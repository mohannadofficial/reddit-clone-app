import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/common/card_post.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/core/services/services.dart';
import 'package:reddit_app/features/post/controller/post_cubit.dart';
import 'package:reddit_app/features/post/controller/post_state.dart';
import 'package:reddit_app/features/post/widgets/comment_card.dart';
import 'package:reddit_app/models/post_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../auth/controller/auth_cubit.dart';

class CommentPostCommunityScreen extends StatefulWidget {
  final String postId;
  const CommentPostCommunityScreen({super.key, required this.postId});

  @override
  State<CommentPostCommunityScreen> createState() =>
      _CommentPostCommunityScreenState();
}

class _CommentPostCommunityScreenState
    extends State<CommentPostCommunityScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  @override
  void initState() {
    super.initState();
    sl<PostCubit>().getPostByid(widget.postId);
    sl<PostCubit>().getCommentPost(widget.postId);
  }

  void navigateToFeedScreen(BuildContext context) {
    Routemaster.of(context).pop();
  }

  void addCommentToPost(
      {required PostModel postModel, required BuildContext context}) {
    sl<PostCubit>().addCommentPost(
      postModel: postModel,
      context: context,
      text: commentController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isAuthenticated =
        sl<AuthCubit>().state.userModel!.isAuthenticated;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
          onPressed: () => navigateToFeedScreen(context),
        ),
      ),
      body: BlocBuilder<PostCubit, PostState>(
        builder: (context, state) {
          if (state.postModelComment == null) {
            return const Loader();
          }
          return Column(
            children: [
              CardPostWidget(
                postModel: state.postModelComment!,
              ),
              if (isAuthenticated)
                TextField(
                  onSubmitted: (value) {
                    addCommentToPost(
                      context: context,
                      postModel: state.postModelComment!,
                    );
                    commentController.text = '';
                  },
                  controller: commentController,
                  decoration: const InputDecoration(
                    hintText: 'What are your thoughts?',
                    filled: true,
                    border: InputBorder.none,
                  ),
                ),
              if (state.commentModelPost.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: state.commentModelPost.length,
                    itemBuilder: (context, index) {
                      final comment = state.commentModelPost[index];
                      return CommentCardWidget(
                        commentModel: comment,
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
