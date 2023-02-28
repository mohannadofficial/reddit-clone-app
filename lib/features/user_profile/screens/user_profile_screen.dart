import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/common/card_post.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/features/auth/controller/auth_cubit.dart';
import 'package:reddit_app/features/auth/controller/auth_state.dart';
import 'package:reddit_app/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends StatelessWidget {
  final String isOwner;
  final String uid;
  const UserProfileScreen(
      {super.key, required this.isOwner, required this.uid});

  void navigateToEditProfile(BuildContext context) {
    Routemaster.of(context).push('/edit-screen/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final UserModel? user;
          if (isOwner == 'False') {
            user = state.userModelScreen;
          } else {
            user = state.userModel;
          }

          if (user == null) {
            return const Loader();
          }

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 250,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          user!.banner,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(20).copyWith(bottom: 70),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePic),
                          radius: 45,
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(20),
                        child: OutlinedButton(
                          onPressed: () => navigateToEditProfile(context),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                          ),
                          child: const Text('Edit Profile'),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'u/${user.name}',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            '${user.karma} karma',
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(thickness: 2),
                      ],
                    ),
                  ),
                )
              ];
            },
            body: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: state.postUserModel.length,
              itemBuilder: (context, index) {
                final post = state.postUserModel[index];
                return CardPostWidget(
                  postModel: post,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
