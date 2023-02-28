import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:reddit_app/core/utils.dart';
import 'package:reddit_app/models/post_model.dart';
import 'package:reddit_app/models/user_model.dart';

class AuthState extends Equatable {
  final UserModel? userModel;
  final RequestState requestState;
  final String errorMessage;
  final UserModel? userModelScreen;
  final ThemeData? themeData;
  final int currentIndex;
  final List<PostModel> postUserModel;

  const AuthState({
    this.userModel,
    this.requestState = RequestState.loading,
    this.errorMessage = '',
    this.userModelScreen,
    this.themeData,
    this.currentIndex = 0,
    this.postUserModel = const [],
  });

  AuthState copyWith({
    final UserModel? userModel,
    final RequestState? requestState,
    final String? errorMessage,
    final UserModel? userModelScreen,
    final ThemeData? themeData,
    final int? currentIndex,
    final List<PostModel>? postUserModel,
  }) {
    return AuthState(
      errorMessage: errorMessage ?? this.errorMessage,
      requestState: requestState ?? this.requestState,
      userModel: userModel ?? this.userModel,
      userModelScreen: userModelScreen ?? this.userModelScreen,
      themeData: themeData ?? this.themeData,
      currentIndex: currentIndex ?? this.currentIndex,
      postUserModel: postUserModel ?? this.postUserModel,
    );
  }

  @override
  List<Object?> get props => [
        userModel,
        requestState,
        errorMessage,
        userModelScreen,
        themeData,
        currentIndex,
        postUserModel,
      ];
}
