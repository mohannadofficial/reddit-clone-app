import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/services/services.dart';
import 'package:reddit_app/core/utils.dart';
import 'package:reddit_app/features/auth/controller/auth_cubit.dart';
import 'package:reddit_app/features/auth/controller/auth_state.dart';
import 'package:reddit_app/features/user_profile/controller/edit_profile_cubit.dart';
import 'package:reddit_app/theme/pallete.dart';

class EditUserProfileScreen extends StatefulWidget {
  const EditUserProfileScreen({super.key});

  @override
  State<EditUserProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditUserProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: sl<AuthCubit>().state.userModel!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(String name) {
    sl<AuthCubit>().editUserProfile(
        bannerFile: bannerFile,
        context: context,
        profileFile: profileFile,
        name: name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: () => save(nameController.text),
            child: const Text('Save'),
          ),
        ],
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
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
                              : state.userModel!.banner.isEmpty ||
                                      state.userModel!.banner ==
                                          AppContants.bannerDefault
                                  ? const Center(
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        size: 40,
                                      ),
                                    )
                                  : Image.network(state.userModel!.banner),
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
                                backgroundImage:
                                    NetworkImage(state.userModel!.profilePic),
                                radius: 32,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'Name',
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(18),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }
}
