import 'package:equatable/equatable.dart';
import 'package:reddit_app/core/utils.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:reddit_app/models/post_model.dart';

class CommunityState extends Equatable {
  final List<CommunityModel> communityModel;
  final RequestState requestState;
  final String errorMessage;
  final CommunityModel? communityScreenModel;
  final List<CommunityModel> searchCommunityModel;
  final List<PostModel> postCommunityModel;

  const CommunityState({
    this.communityModel = const [],
    this.requestState = RequestState.loading,
    this.errorMessage = '',
    this.communityScreenModel,
    this.searchCommunityModel = const [],
    this.postCommunityModel = const [],
  });

  CommunityState copyWith({
    final List<CommunityModel>? communityModel,
    final RequestState? requestState,
    final String? errorMessage,
    final CommunityModel? communityScreenModel,
    final List<CommunityModel>? searchCommunityModel,
    final List<PostModel>? postCommunityModel,
  }) {
    return CommunityState(
      errorMessage: errorMessage ?? this.errorMessage,
      requestState: requestState ?? this.requestState,
      communityModel: communityModel ?? this.communityModel,
      communityScreenModel: communityScreenModel ?? this.communityScreenModel,
      searchCommunityModel: searchCommunityModel ?? this.searchCommunityModel,
      postCommunityModel: postCommunityModel ?? this.postCommunityModel,
    );
  }

  @override
  List<Object?> get props => [
        communityModel,
        requestState,
        errorMessage,
        communityScreenModel,
        searchCommunityModel,
        postCommunityModel,
      ];
}
