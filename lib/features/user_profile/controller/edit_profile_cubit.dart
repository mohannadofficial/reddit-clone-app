import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/services/services.dart';
import 'package:reddit_app/core/services/storage_repository.dart';
import 'package:reddit_app/core/utils.dart';
import 'package:reddit_app/features/auth/controller/auth_cubit.dart';
import 'package:reddit_app/features/auth/controller/auth_state.dart';
import 'package:reddit_app/features/user_profile/repository/user_profile_repository.dart';
import 'package:routemaster/routemaster.dart';

class EditProfileCubit extends Cubit<AuthState> {
  final UserProfileRepostiry _profileRepostiry;
  final StorageRepository _storageRepository;
  EditProfileCubit(
      {required UserProfileRepostiry userProfileRepostiry,
      required StorageRepository storageRepository})
      : _profileRepostiry = userProfileRepostiry,
        _storageRepository = storageRepository,
        super(sl<AuthCubit>().state);

  void editUserProfile(
      {required File? bannerFile,
      required File? profileFile,
      required String name,
      required BuildContext context}) async {
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
          id: state.userModel!.uid, path: 'users/profile', file: profileFile);

      res.fold(
        (l) {
          state.copyWith(requestState: RequestState.error);
          return showSnackBar(context, l.message);
        },
        (r) => state.copyWith(
            userModel: state.userModel!.copyWith(
          profilePic: r,
        )),
      );
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
          id: state.userModel!.uid, path: 'user/banner', file: bannerFile);

      res.fold(
        (l) {
          state.copyWith(requestState: RequestState.error);
          return showSnackBar(context, l.message);
        },
        (r) => state.copyWith(userModel: state.userModel!.copyWith(banner: r)),
      );
    }

    emit(state.copyWith(userModel: state.userModel!.copyWith(name: name)));

    final res = await _profileRepostiry.editProfile(state.userModel!);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  void updateKarm(UserKarma karma) async {
    final res = await _profileRepostiry.updateKarma(
        state.userModel!, state.userModel!.karma + karma.karma);
    res.fold(
      (l) => null,
      (r) => emit(state),
    );
  }
}
