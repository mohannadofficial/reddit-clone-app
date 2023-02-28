import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/core/services/services.dart';
import 'package:reddit_app/features/auth/controller/auth_cubit.dart';
import 'package:reddit_app/features/community/controller/community_cubit.dart';
import 'package:reddit_app/features/community/controller/community_state.dart';
import 'package:reddit_app/models/user_model.dart';

class AddModsCommunityScreen extends StatefulWidget {
  final String name;
  const AddModsCommunityScreen({super.key, required this.name});

  @override
  State<AddModsCommunityScreen> createState() => _AddModsCommunityScreenState();
}

class _AddModsCommunityScreenState extends State<AddModsCommunityScreen> {
  Set<String> setUid = {};
  int ctr = 0;

  void addUid(String uid) {
    setState(() {
      setUid.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      setUid.remove(uid);
    });
  }

  void save(
    BuildContext context,
    String nameCommunity,
  ) {
    sl<CommunityCubit>()
        .addModsToCommunity(context, nameCommunity, setUid.toList());
  }

  List<UserModel> userModelList = [];
  void getMembers() async {
    for (var element
        in sl<CommunityCubit>().state.communityScreenModel!.members) {
      userModelList.add(await sl<AuthCubit>().getUserDataByCommunity(element));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getMembers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: (() => save(context, widget.name)),
            icon: const Icon(
              Icons.done,
            ),
          ),
        ],
      ),
      body: BlocBuilder<CommunityCubit, CommunityState>(
        builder: (context, state) {
          if (userModelList.isEmpty) {
            return const Loader();
          } else {
            ctr++;
            return ListView.builder(
              itemCount: state.communityScreenModel!.members.length,
              itemBuilder: (context, index) {
                final idUid = userModelList[index].uid;

                if (state.communityScreenModel!.mods.contains(idUid) &&
                    ctr == 1) {
                  setUid.add(idUid);
                }
                return CheckboxListTile(
                  value: setUid.contains(idUid),
                  onChanged: (value) {
                    if (value!) {
                      addUid(idUid);
                    } else {
                      removeUid(idUid);
                    }
                  },
                  title: Text(userModelList[index].name),
                );
              },
            );
          }
        },
      ),
    );
  }
}
