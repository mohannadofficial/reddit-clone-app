import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/services/services.dart';
import 'package:reddit_app/features/community/controller/community_cubit.dart';
import 'package:reddit_app/features/community/controller/community_state.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.close),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocBuilder<CommunityCubit, CommunityState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.searchCommunityModel.length,
          itemBuilder: (context, index) {
            final communities = state.searchCommunityModel[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(communities.avatar),
              ),
              title: Text('r/${communities.name}'),
              onTap: () => navigateToCommunity(context, communities),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    sl<CommunityCubit>().searchCommunity(query);
    return BlocBuilder<CommunityCubit, CommunityState>(
      builder: (context, state) {
        return ListView.builder(
          itemCount: state.searchCommunityModel.length,
          itemBuilder: (context, index) {
            final communities = state.searchCommunityModel[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(communities.avatar),
              ),
              title: Text('r/${communities.name}'),
              onTap: () => navigateToCommunity(context, communities),
            );
          },
        );
      },
    );
  }

  void navigateToCommunity(BuildContext context, CommunityModel community) {
    sl<CommunityCubit>().getPostCommunity(community.name);
    sl<CommunityCubit>().getCommunityByName(community.name);
    Routemaster.of(context).push('/r/${community.name}');
  }
}
