import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/common/sign_in_button.dart';
import 'package:reddit_app/features/auth/controller/auth_cubit.dart';
import 'package:reddit_app/features/community/controller/community_cubit.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/services/services.dart';
import '../../community/controller/community_state.dart';

class CommunityDrawer extends StatelessWidget {
  const CommunityDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, CommunityModel community) {
    sl<CommunityCubit>().getCommunityByName(community.name);
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context) {
    final bool isAuthenticated =
        sl<AuthCubit>().state.userModel!.isAuthenticated;
    return Drawer(
      child: SafeArea(
          child: Column(
        children: [
          if (isAuthenticated)
            ListTile(
              title: const Text('Create a community'),
              leading: const Icon(Icons.add),
              onTap: () => navigateToCreateCommunity(context),
            ),
          if (!isAuthenticated) const SignInButton(isLoginFrom: false),
          if (isAuthenticated)
            BlocBuilder<CommunityCubit, CommunityState>(
              builder: (context, state) {
                if (state.communityModel.isEmpty) {
                  sl<CommunityCubit>().getUserCommunities();
                }
                state.communityModel.length;
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.communityModel.length,
                    itemBuilder: (context, index) {
                      final community = state.communityModel[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(community.avatar),
                        ),
                        title: Text('r/${community.name}'),
                        onTap: () => navigateToCommunity(context, community),
                      );
                    },
                  ),
                );
              },
            ),
        ],
      )),
    );
  }
}
