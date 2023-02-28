import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/services/services.dart';
import 'package:reddit_app/core/utils.dart';
import 'package:reddit_app/features/community/controller/community_cubit.dart';
import 'package:reddit_app/features/community/controller/community_state.dart';
import 'package:reddit_app/features/post/controller/post_cubit.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:reddit_app/theme/pallete.dart';
import 'dart:io';

class AddTypePostCommunityScreen extends StatefulWidget {
  final String type;

  const AddTypePostCommunityScreen({super.key, required this.type});

  @override
  State<AddTypePostCommunityScreen> createState() =>
      _AddTypePostCommunityScreenState();
}

class _AddTypePostCommunityScreenState
    extends State<AddTypePostCommunityScreen> {
  final textTitleController = TextEditingController();
  final textDescriptionController = TextEditingController();
  final textlinkController = TextEditingController();
  File? bannerFile;
  var postCubit = sl<PostCubit>();
  List<CommunityModel> communites = [];
  CommunityModel? selectedCommunity;

  void sharePost() {
    if (widget.type == 'Image' &&
        textTitleController.text.isNotEmpty &&
        bannerFile != null) {
      postCubit.shareImagePost(
        context: context,
        image: bannerFile!,
        selectedCommunity: selectedCommunity ?? communites[0],
        title: textTitleController.text.trim(),
      );
    } else if (widget.type == 'Text' &&
        textTitleController.text.isNotEmpty &&
        textDescriptionController.text.isNotEmpty) {
      postCubit.shareTextPost(
        context: context,
        description: textDescriptionController.text.trim(),
        selectedCommunity: selectedCommunity ?? communites[0],
        title: textTitleController.text.trim(),
      );
    } else if (widget.type == 'Link' &&
        textTitleController.text.isNotEmpty &&
        textlinkController.text.isNotEmpty) {
      postCubit.shareLinkPost(
        context: context,
        link: textlinkController.text.trim(),
        selectedCommunity: selectedCommunity ?? communites[0],
        title: textTitleController.text.trim(),
      );
    } else {
      showSnackBar(context, 'Please enter all the fields');
    }
  }

  void selectBannerImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  @override
  void dispose() {
    textTitleController.dispose();
    textDescriptionController.dispose();
    textlinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typeIsImage = widget.type == 'Image';
    final typeIsText = widget.type == 'Text';
    final typeIsLink = widget.type == 'Link';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Post ${widget.type}'),
        actions: [
          TextButton(
            onPressed: sharePost,
            child: const Text('Share'),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textTitleController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Enter Title Here',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
                maxLength: 30,
              ),
            ),
            if (typeIsImage)
              GestureDetector(
                onTap: selectBannerImage,
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(10),
                  dashPattern: const [10, 4],
                  strokeCap: StrokeCap.round,
                  color: Pallete.darkModeAppTheme.textTheme.bodyText2!.color!,
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: bannerFile != null
                        ? Image.file(bannerFile!)
                        : const Center(
                            child: Icon(
                              Icons.camera_alt_outlined,
                              size: 40,
                            ),
                          ),
                  ),
                ),
              ),
            if (typeIsText)
              TextField(
                controller: textDescriptionController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Enter Description Here',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
                maxLines: 5,
              ),
            if (typeIsLink)
              TextField(
                controller: textlinkController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Enter Link Here',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
              ),
            const SizedBox(
              height: 20,
            ),
            const Align(
              alignment: Alignment.topLeft,
              child: Text('Select Community'),
            ),
            BlocBuilder<CommunityCubit, CommunityState>(
              builder: (context, state) {
                communites = state.communityModel;
                return DropdownButton(
                  value: selectedCommunity ?? communites[0],
                  items: state.communityModel
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCommunity = value;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
