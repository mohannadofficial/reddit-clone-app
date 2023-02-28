import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/services/services.dart';
import 'package:reddit_app/features/auth/controller/auth_cubit.dart';
import 'package:reddit_app/features/auth/controller/auth_state.dart';
import 'package:reddit_app/features/community/controller/community_cubit.dart';
import 'package:reddit_app/features/community/controller/community_state.dart';
import 'package:reddit_app/features/post/controller/post_cubit.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:reddit_app/models/post_model.dart';
import 'package:reddit_app/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class CardPostWidget extends StatelessWidget {
  final PostModel postModel;
  const CardPostWidget({
    super.key,
    required this.postModel,
  });

  void deletePost(BuildContext context) {
    sl<PostCubit>().deletePost(context, postModel);
  }

  void upvotesPost() {
    sl<PostCubit>().upvotes(postModel);
  }

  void downvotesPost() {
    sl<PostCubit>().downvotes(postModel);
  }

  void navigateToCommunity(BuildContext context) {
    sl<CommunityCubit>().getPostCommunity(postModel.communityName);
    sl<CommunityCubit>().getCommunityByName(postModel.communityName);
    Routemaster.of(context).push('/r/${postModel.communityName}');
  }

  void navigateToUserProfile(BuildContext context) {
    sl<AuthCubit>().getPostUser(postModel.uid);
    sl<AuthCubit>().getUserByUid(postModel.uid);
    Routemaster.of(context).push('/u/${postModel.uid}/False');
  }

  void navigateToCommentPost(BuildContext context) {
    Routemaster.of(context).push('/post/${postModel.id}/comments');
  }

  void awardPost({required String award, required BuildContext context}) {
    sl<PostCubit>()
        .awardPost(award: award, postModel: postModel, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = postModel.type == 'Image';
    final isTypeText = postModel.type == 'Text';
    final isTypeLink = postModel.type == 'Link';
    final bool isAuthenticated =
        sl<AuthCubit>().state.userModel!.isAuthenticated;
    return Column(
      children: [
        Container(
          //color: currentTheme.drawerTheme.backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => navigateToCommunity(context),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            postModel.communityProfilePic,
                          ),
                          radius: 18,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => navigateToCommunity(context),
                              child: Text(
                                'r/${postModel.communityName}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => navigateToUserProfile(context),
                              child: Text(
                                'u/${postModel.username}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (postModel.uid == uid)
                    IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Pallete.redColor,
                      ),
                      onPressed: () => deletePost(context),
                    ),
                ],
              ),
              if (postModel.awards.isNotEmpty) ...[
                const SizedBox(height: 5),
                SizedBox(
                  height: 25,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: postModel.awards.length,
                    itemBuilder: (BuildContext context, int index) {
                      final award = postModel.awards[index];
                      return Image.asset(
                        AppContants.awards[award]!,
                        height: 23,
                      );
                    },
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  postModel.title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (isTypeImage)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    postModel.link!,
                    fit: BoxFit.cover,
                  ),
                ),
              if (isTypeLink)
                AnyLinkPreview(
                  displayDirection: UIDirection.uiDirectionHorizontal,
                  link: postModel.link!,
                ),
              if (isTypeText)
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10),
                  child: Text(
                    postModel.description!,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          AppContants.up,
                          size: 30,
                          color: postModel.upvotes.contains(uid)
                              ? Pallete.redColor
                              : null,
                        ),
                        onPressed:
                            isAuthenticated ? () => upvotesPost() : () {},
                      ),
                      Text(
                        '${postModel.upvotes.length - postModel.downvotes.length == 0 ? 'Vote' : postModel.upvotes.length - postModel.downvotes.length}',
                        style: const TextStyle(fontSize: 17),
                      ),
                      IconButton(
                        icon: Icon(
                          AppContants.down,
                          size: 30,
                          color: postModel.downvotes.contains(uid)
                              ? Pallete.redColor
                              : null,
                        ),
                        onPressed:
                            isAuthenticated ? () => downvotesPost() : () {},
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.comment,
                        ),
                        onPressed: () => navigateToCommentPost(context),
                      ),
                      Text(
                        '${postModel.commentCount == 0 ? 'Comment' : postModel.commentCount}',
                        style: const TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                  BlocBuilder<CommunityCubit, CommunityState>(
                    builder: (context, state) {
                      if (state.communityModel.isNotEmpty) {
                        CommunityModel? communityMod;
                        for (var element in state.communityModel) {
                          if (element.name == postModel.communityName) {
                            communityMod = element;
                          }
                        }
                        if (communityMod!.mods.contains(uid)) {
                          return IconButton(
                            icon: const Icon(Icons.admin_panel_settings),
                            onPressed: () => deletePost(context),
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    },
                  ),
                  BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      return IconButton(
                        icon: const Icon(Icons.card_giftcard_outlined),
                        onPressed: isAuthenticated
                            ? () => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: GridView.builder(
                                        shrinkWrap: true,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4,
                                        ),
                                        itemCount:
                                            state.userModel!.awards.length,
                                        itemBuilder: (context, index) {
                                          final award =
                                              state.userModel!.awards[index];
                                          return GestureDetector(
                                            onTap: () => awardPost(
                                                award: award, context: context),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.asset(
                                                  AppContants.awards[award]!),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                )
                            : () {},
                      );
                    },
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
