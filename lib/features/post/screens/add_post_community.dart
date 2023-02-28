import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/features/auth/controller/auth_cubit.dart';
import 'package:reddit_app/features/auth/controller/auth_state.dart';
import 'package:routemaster/routemaster.dart';

class AddPostCommunityScreen extends StatelessWidget {
  const AddPostCommunityScreen({super.key});

  void navigateToTypePost(BuildContext context, String type) {
    Routemaster.of(context).push('add/post/$type');
  }

  @override
  Widget build(BuildContext context) {
    double cardHeightWidith = 120;
    double iconSize = 60;
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
          body: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => navigateToTypePost(context, 'Image'),
                child: SizedBox(
                  height: cardHeightWidith,
                  width: cardHeightWidith,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    color: state.themeData!.backgroundColor,
                    elevation: 16,
                    child: Icon(
                      Icons.image_outlined,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => navigateToTypePost(context, 'Text'),
                child: SizedBox(
                  height: cardHeightWidith,
                  width: cardHeightWidith,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    color: state.themeData!.backgroundColor,
                    elevation: 16,
                    child: Icon(
                      Icons.font_download_outlined,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => navigateToTypePost(context, 'Link'),
                child: SizedBox(
                  height: cardHeightWidith,
                  width: cardHeightWidith,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    color: state.themeData!.backgroundColor,
                    elevation: 16,
                    child: Icon(
                      Icons.link_outlined,
                      size: iconSize,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
