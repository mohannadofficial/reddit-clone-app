import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/common/card_post.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/services/services.dart';
import 'package:reddit_app/features/community/controller/community_cubit.dart';
import 'package:routemaster/routemaster.dart';

import '../../auth/controller/auth_cubit.dart';
import '../controller/community_state.dart';

class CommunityScreen extends StatelessWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  void navigateToModToosl(BuildContext context, String name) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(
      {required String communityName,
      required BuildContext context,
      required bool isJoin}) {
    sl<CommunityCubit>().joinCommunity(
        communityName: communityName, context: context, isJoin: isJoin);
  }

  @override
  Widget build(BuildContext context) {
    final bool isAuthenticated =
        sl<AuthCubit>().state.userModel!.isAuthenticated;
    return Scaffold(
      body: BlocBuilder<CommunityCubit, CommunityState>(
        builder: (context, state) {
          final community = state.communityScreenModel;

          if (community == null) {
            return const Loader();
          }

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          community.banner,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Align(
                          alignment: Alignment.topLeft,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                            radius: 35,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'r/${community.name}',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isAuthenticated)
                              community.mods.contains(uid)
                                  ? OutlinedButton(
                                      onPressed: () => navigateToModToosl(
                                          context, community.name),
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                      ),
                                      child: const Text('Mod Tools'),
                                    )
                                  : OutlinedButton(
                                      onPressed: () {
                                        final isJoin =
                                            community.members.contains(uid);

                                        joinCommunity(
                                            communityName: community.name,
                                            context: context,
                                            isJoin: isJoin);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25),
                                      ),
                                      child: Text(
                                          community.members.contains(uid)
                                              ? 'Joined'
                                              : 'Join'),
                                    ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            '${community.members.length} members',
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: BlocBuilder<CommunityCubit, CommunityState>(
              builder: (context, state) {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: state.postCommunityModel.length,
                  itemBuilder: (context, index) {
                    final post = state.postCommunityModel[index];
                    return CardPostWidget(
                      postModel: post,
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
