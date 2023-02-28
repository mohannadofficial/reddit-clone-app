import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/services/services.dart';
import 'package:reddit_app/core/utils.dart';
import 'package:reddit_app/features/community/controller/community_cubit.dart';
import 'package:reddit_app/features/community/controller/community_state.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:reddit_app/theme/pallete.dart';

class EditCommunityScreen extends StatefulWidget {
  final String name;
  const EditCommunityScreen({super.key, required this.name});

  @override
  State<EditCommunityScreen> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends State<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save() {
    sl<CommunityCubit>().editCommunity(
        bannerFile: bannerFile, context: context, profileFile: profileFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Community'),
        actions: [
          TextButton(
            onPressed: save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: BlocBuilder<CommunityCubit, CommunityState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: selectBannerImage,
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        radius: const Radius.circular(10),
                        dashPattern: const [10, 4],
                        strokeCap: StrokeCap.round,
                        color: Pallete
                            .darkModeAppTheme.textTheme.bodyText2!.color!,
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: bannerFile != null
                              ? Image.file(bannerFile!)
                              : state.communityScreenModel!.banner.isEmpty ||
                                      state.communityScreenModel!.banner ==
                                          AppContants.bannerDefault
                                  ? const Center(
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        size: 40,
                                      ),
                                    )
                                  : Image.network(
                                      state.communityScreenModel!.banner),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: GestureDetector(
                        onTap: selectProfileImage,
                        child: profileFile != null
                            ? CircleAvatar(
                                backgroundImage: FileImage(profileFile!),
                                radius: 32,
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(
                                    state.communityScreenModel!.avatar),
                                radius: 32,
                              ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
          );
        },
      ),
    );
  }
}
