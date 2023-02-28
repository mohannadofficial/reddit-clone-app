import 'dart:io';
import 'dart:math';
import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/failure.dart';
import 'package:reddit_app/core/services/storage_repository.dart';
import 'package:reddit_app/core/utils.dart';
import 'package:reddit_app/features/community/repository/community_repository.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:reddit_app/models/post_model.dart';
import 'package:routemaster/routemaster.dart';

import 'community_state.dart';

class CommunityCubit extends Cubit<CommunityState> {
  final CommunityRepository _communityRepository;
  final StorageRepository _storageRepository;
  CommunityCubit(
      {required CommunityRepository communityRepository,
      required StorageRepository storageRepository})
      : _communityRepository = communityRepository,
        _storageRepository = storageRepository,
        super(
          const CommunityState(),
        );

  void createNewCommunity(String name, BuildContext context) async {
    final CommunityModel communityModel = CommunityModel(
      name: name,
      id: name,
      avatar: AppContants.avatarDefault,
      banner: AppContants.bannerDefault,
      members: [uid],
      mods: [uid],
    );
    final res = await _communityRepository.createNewCommunity(communityModel);
    res.fold((l) {
      showSnackBar(context, l.message);
      emit(
        state.copyWith(
            errorMessage: l.message, requestState: RequestState.error),
      );
    }, (r) {
      showSnackBar(context, 'Community created successfully!');
      emit(
        state.copyWith(requestState: RequestState.loaded),
      );
      Routemaster.of(context).pop();
    });
  }

  void joinCommunity(
      {required BuildContext context,
      required String communityName,
      required bool isJoin}) async {
    Either<Failure, void> res;
    if (isJoin) {
      res = await _communityRepository.leaveCommunity(communityName);
    } else {
      res = await _communityRepository.joinCommunity(communityName);
    }
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) {
        if (isJoin) {
          showSnackBar(context, 'Community left successfully!');
        } else {
          showSnackBar(context, 'Community joined successfully!');
        }
      },
    );
  }

  void getUserCommunities() {
    final resu = _communityRepository.getUserCommunities(uid);
    resu.listen(
      (event) {
        emit(state.copyWith(communityModel: event));
      },
    );
  }

  void getCommunityByName(String name) {
    final res = _communityRepository.getCommunityByName(name);
    res.listen(
      (event) {
        emit(state.copyWith(communityScreenModel: event));
      },
    );
  }

  void editCommunity(
      {required File? bannerFile,
      required File? profileFile,
      required BuildContext context}) async {
    if (profileFile != null) {
      final res = await _storageRepository.storeFile(
          id: state.communityScreenModel!.id,
          path: 'communities/profile',
          file: profileFile);

      res.fold(
        (l) {
          state.copyWith(requestState: RequestState.error);
          return showSnackBar(context, l.message);
        },
        (r) => state.copyWith(
            communityScreenModel:
                state.communityScreenModel!.copyWith(avatar: r)),
      );
    }
    if (bannerFile != null) {
      final res = await _storageRepository.storeFile(
          id: state.communityScreenModel!.name,
          path: 'communities/banner',
          file: bannerFile);

      res.fold(
        (l) {
          state.copyWith(requestState: RequestState.error);
          return showSnackBar(context, l.message);
        },
        (r) => state.copyWith(
            communityScreenModel:
                state.communityScreenModel!.copyWith(banner: r)),
      );
    }
    final res =
        await _communityRepository.editCommunity(state.communityScreenModel!);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => Routemaster.of(context).pop(),
    );
  }

  void searchCommunity(String query) {
    final res = _communityRepository.searchCommunity(query);
    res.listen(
      (event) {
        emit(state.copyWith(searchCommunityModel: event));
      },
    );
  }

  void addModsToCommunity(
      BuildContext context, String nameCommunity, List<String> uidSet) async {
    final res =
        await _communityRepository.addModsToCommunity(nameCommunity, uidSet);
    res.fold(
      (l) {
        return showSnackBar(context, l.message);
      },
      (r) {
        Routemaster.of(context).pop();
      },
    );
  }

  void logOut() {
    emit(const CommunityState());
  }

  void getPostCommunity(String name) {
    final res = _communityRepository.getPostCommunity(name);
    res.listen(
      (event) => emit(
        state.copyWith(postCommunityModel: event),
      ),
    );
  }
}
