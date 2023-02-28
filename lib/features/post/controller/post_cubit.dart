import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/services/services.dart';
import 'package:reddit_app/core/services/storage_repository.dart';
import 'package:reddit_app/core/utils.dart';
import 'package:reddit_app/features/auth/controller/auth_cubit.dart';
import 'package:reddit_app/features/post/controller/post_state.dart';
import 'package:reddit_app/features/post/repository/post_repository.dart';
import 'package:reddit_app/models/comment_model.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:reddit_app/models/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import '../../user_profile/controller/edit_profile_cubit.dart';

class PostCubit extends Cubit<PostState> {
  final PostRepository _postRepository;
  final StorageRepository _storageRepository;
  PostCubit(
      {required PostRepository postRepository,
      required StorageRepository storageRepository})
      : _postRepository = postRepository,
        _storageRepository = storageRepository,
        super(
          const PostState(),
        );

  void shareTextPost({
    required BuildContext context,
    required String title,
    required CommunityModel selectedCommunity,
    required String description,
  }) async {
    String postId = const Uuid().v1();
    final user = sl<AuthCubit>().state.userModel!;

    final PostModel post = PostModel(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: const [],
      downvotes: const [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'Text',
      createdAt: DateTime.now(),
      awards: const [],
      description: description,
    );

    final res = await _postRepository.addPost(post);

    res.fold(
      (l) {
        emit(state.copyWith(
            requestState: RequestState.error, errorMessage: l.message));
      },
      (r) {
        sl<EditProfileCubit>().updateKarm(UserKarma.typeText);
        emit(
          state.copyWith(postModel: post, requestState: RequestState.loaded),
        );
        showSnackBar(context, 'Post Added Successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required CommunityModel selectedCommunity,
    required String link,
  }) async {
    String postId = const Uuid().v1();
    final user = sl<AuthCubit>().state.userModel!;

    final PostModel post = PostModel(
      id: postId,
      title: title,
      communityName: selectedCommunity.name,
      communityProfilePic: selectedCommunity.avatar,
      upvotes: const [],
      downvotes: const [],
      commentCount: 0,
      username: user.name,
      uid: user.uid,
      type: 'Link',
      createdAt: DateTime.now(),
      awards: const [],
      link: link,
    );

    final res = await _postRepository.addPost(post);

    res.fold(
      (l) {
        emit(state.copyWith(
            requestState: RequestState.error, errorMessage: l.message));
      },
      (r) {
        sl<EditProfileCubit>().updateKarm(UserKarma.typeLink);
        emit(
          state.copyWith(postModel: post, requestState: RequestState.loaded),
        );
        showSnackBar(context, 'Post Added Successfully');
        Routemaster.of(context).pop();
      },
    );
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required CommunityModel selectedCommunity,
    required File image,
  }) async {
    String postId = const Uuid().v1();
    final user = sl<AuthCubit>().state.userModel!;
    final resImage = await _storageRepository.storeFile(
        id: postId, path: 'post/${selectedCommunity.name}', file: image);

    resImage.fold(
      (l) => emit(
        state.copyWith(
            errorMessage: l.message, requestState: RequestState.error),
      ),
      (r) async {
        final PostModel post = PostModel(
          id: postId,
          title: title,
          communityName: selectedCommunity.name,
          communityProfilePic: selectedCommunity.avatar,
          upvotes: const [],
          downvotes: const [],
          commentCount: 0,
          username: user.name,
          uid: user.uid,
          type: 'Image',
          createdAt: DateTime.now(),
          awards: const [],
          link: r,
        );

        final res = await _postRepository.addPost(post);

        res.fold(
          (l) {
            emit(state.copyWith(
                requestState: RequestState.error, errorMessage: l.message));
          },
          (r) {
            sl<EditProfileCubit>().updateKarm(UserKarma.typeImg);
            emit(
              state.copyWith(
                  postModel: post, requestState: RequestState.loaded),
            );
            showSnackBar(context, 'Post Added Successfully');
            Routemaster.of(context).pop();
          },
        );
      },
    );
  }

  void fetchUserPost(List<CommunityModel> communites) {
    if (communites.isNotEmpty) {
      final res = _postRepository.fetchUserPost(communites);
      res.listen(
        (event) {
          emit(state.copyWith(postModelList: event));
        },
      );
    }
  }

  void fetchGuestPost() {
    final res = _postRepository.fetchGuestPost();
    res.listen(
      (event) {
        emit(state.copyWith(postGuestModelList: event));
      },
    );
  }

  void deletePost(BuildContext contex, PostModel postModel) async {
    final res = await _postRepository.deletePost(postModel);
    res.fold(
      (l) {
        showSnackBar(contex, l.message);
        emit(
          state.copyWith(
              requestState: RequestState.error, errorMessage: l.message),
        );
      },
      (r) {
        sl<EditProfileCubit>().updateKarm(UserKarma.deletePost);
        showSnackBar(contex, 'Post Removed Successfully');
        emit(
          state.copyWith(requestState: RequestState.loaded),
        );
      },
    );
  }

  void upvotes(PostModel postModel) async {
    _postRepository.upvotes(postModel);
    // Don't need to emit state Because Stream State Above
  }

  void downvotes(PostModel postModel) async {
    _postRepository.downvotes(postModel);
  }

  void getPostByid(String idPost) {
    final res = _postRepository.getPostByid(idPost);
    res.listen(
      (event) {
        emit(state.copyWith(postModelComment: event));
      },
    );
  }

  void addCommentPost(
      {required BuildContext context,
      required String text,
      required PostModel postModel}) async {
    String id = const Uuid().v1();
    final CommentModel commentModel = CommentModel(
      id: id,
      createdAt: DateTime.now(),
      text: text,
      postId: postModel.id,
      username: sl<AuthCubit>().state.userModel!.name,
      profilePic: sl<AuthCubit>().state.userModel!.profilePic,
    );
    final res = await _postRepository.addCommentPost(commentModel);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => sl<EditProfileCubit>().updateKarm(UserKarma.comment),
    );
  }

  void getCommentPost(String postId) {
    final res = _postRepository.getCommentPost(postId);
    res.listen(
      (event) {
        emit(state.copyWith(commentModelPost: event));
      },
    );
  }

  void awardPost(
      {required PostModel postModel,
      required String award,
      required BuildContext context}) async {
    final res = await _postRepository.awardPost(postModel, award, uid);
    res.fold(
      (l) => null,
      (r) {
        sl<EditProfileCubit>().updateKarm(UserKarma.award);
        Routemaster.of(context).pop();
      },
    );
  }
}
