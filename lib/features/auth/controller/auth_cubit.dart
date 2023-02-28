import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/services/services.dart';
import 'package:reddit_app/core/services/storage_repository.dart';
import 'package:reddit_app/core/utils.dart';
import 'package:reddit_app/features/auth/controller/auth_state.dart';
import 'package:reddit_app/features/auth/repository/auth_repository.dart';
import 'package:reddit_app/features/community/controller/community_cubit.dart';
import 'package:reddit_app/features/community/controller/community_state.dart';
import 'package:reddit_app/models/user_model.dart';
import 'package:reddit_app/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
      {required AuthRepository authRepository,
      required StorageRepository storageRepository,
      ThemeModes mods = ThemeModes.dark})
      : _authRepository = authRepository,
        _storageRepository = storageRepository,
        _mods = mods,
        super(const AuthState());

  final AuthRepository _authRepository;
  final StorageRepository _storageRepository;
  ThemeModes _mods;
  bool loginFromLogOut = false;

  // check of login or not
  void getCurrentUser() async {
    final userCheck = await _authRepository.getCurrentUser().first;
    if (userCheck != '') {
      emit(state.copyWith(
        requestState: RequestState.loaded,
      ));
      final user = _authRepository.getUserData(userCheck);
      user.listen(
        (event) {
          uid = event.uid;
          emit(
            state.copyWith(
              userModel: event,
            ),
          );
        },
      );
    } else {
      emit(state.copyWith(requestState: RequestState.none));
    }
  }

  Future<UserModel> getUserDataByCommunity(String uid) async {
    final res = await _authRepository.getUserDataByCommunity(uid);
    return res;
  }

  void getUserByUid(String pushUid) async {
    final user = await _authRepository.getUserByUid(pushUid);
    emit(state.copyWith(userModelScreen: user));
  }

  // login
  void signInWithGoogle(BuildContext context, bool isFromLogin) async {
    emit(state.copyWith(requestState: RequestState.loading));
    final user = await _authRepository.signInWithGoogle(isFromLogin);
    user.fold((l) {
      showSnackBar(context, l.message);
      emit(
        state.copyWith(
            errorMessage: l.message, requestState: RequestState.error),
      );
    }, (r) {
      uid = r.uid;
      emit(
        state.copyWith(userModel: r, requestState: RequestState.loaded),
      );
    });
    if (loginFromLogOut) {
      sl<CommunityCubit>().getUserCommunities();
    }
  }

  void signInAsGuest(BuildContext context) async {
    emit(state.copyWith(requestState: RequestState.loading));
    final user = await _authRepository.signInAsGuest();
    user.fold((l) {
      showSnackBar(context, l.message);
      emit(
        state.copyWith(
            errorMessage: l.message, requestState: RequestState.error),
      );
    }, (r) {
      uid = r.uid;
      emit(
        state.copyWith(userModel: r, requestState: RequestState.loaded),
      );
    });
    // if (loginFromLogOut) {
    //   sl<CommunityCubit>().getUserCommunities();
    // }
  }

  void logOut() {
    loginFromLogOut = true;
    _authRepository.logOut();
    sl<CommunityCubit>().logOut();
    uid = '';
    emit(state.copyWith(requestState: RequestState.none));
  }

  // edit user

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

    state.copyWith(userModel: state.userModel!.copyWith(name: name));

    final res = await _authRepository.editProfile(state.userModel!);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  // Theme
  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');
    if (theme == 'light') {
      _mods = ThemeModes.light;
      emit(state.copyWith(themeData: Pallete.lightModeAppTheme));
    } else {
      _mods = ThemeModes.dark;
      emit(state.copyWith(themeData: Pallete.darkModeAppTheme));
    }
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_mods == ThemeModes.light) {
      _mods = ThemeModes.dark;
      prefs.setString('theme', 'dark');
      emit(state.copyWith(themeData: Pallete.darkModeAppTheme));
    } else {
      _mods = ThemeModes.light;
      prefs.setString('theme', 'light');
      emit(state.copyWith(themeData: Pallete.lightModeAppTheme));
    }
  }

  // Bottom Index
  void onPageChanged(int index) {
    emit(
      state.copyWith(currentIndex: index),
    );
  }

  // post

  void getPostUser(String pushUid) {
    final res = _authRepository.getPostUser(pushUid);
    res.listen(
      (event) {
        emit(
          state.copyWith(postUserModel: event),
        );
      },
    );
  }
}
