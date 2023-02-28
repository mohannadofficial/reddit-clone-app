import 'package:flutter/material.dart';
import 'package:reddit_app/features/community/controller/community_cubit.dart';

import '../../../core/services/services.dart';

class CreateCommunityScreen extends StatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  State<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createNewCommunity(BuildContext context) {
    sl<CommunityCubit>()
        .createNewCommunity(communityNameController.text, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create a community'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Community name'),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: communityNameController,
            decoration: const InputDecoration(
              hintText: 'r/ Community_name',
              border: InputBorder.none,
              filled: true,
              contentPadding: EdgeInsetsDirectional.all(10),
            ),
            maxLength: 21,
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () => createNewCommunity(context),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text(
              'Create a community',
              style: TextStyle(fontSize: 17),
            ),
          ),
        ]),
      ),
    );
  }
}
