import 'package:equatable/equatable.dart';
import 'package:reddit_app/core/utils.dart';
import 'package:reddit_app/models/comment_model.dart';
import 'package:reddit_app/models/post_model.dart';

class PostState extends Equatable {
  final PostModel? postModel;
  final RequestState requestState;
  final String errorMessage;
  final List<PostModel> postModelList;
  final List<PostModel> postGuestModelList;
  final PostModel? postModelComment;
  final List<CommentModel> commentModelPost;

  const PostState({
    this.postModel,
    this.requestState = RequestState.none,
    this.errorMessage = '',
    this.postModelList = const [],
    this.postGuestModelList = const [],
    this.postModelComment,
    this.commentModelPost = const [],
  });

  PostState copyWith({
    final PostModel? postModel,
    final RequestState? requestState,
    final String? errorMessage,
    final List<PostModel>? postModelList,
    final List<PostModel>? postGuestModelList,
    final PostModel? postModelComment,
    final List<CommentModel>? commentModelPost,
  }) {
    return PostState(
      errorMessage: errorMessage ?? this.errorMessage,
      requestState: requestState ?? this.requestState,
      postModel: postModel ?? this.postModel,
      postModelList: postModelList ?? this.postModelList,
      postModelComment: postModelComment ?? this.postModelComment,
      commentModelPost: commentModelPost ?? this.commentModelPost,
      postGuestModelList: postGuestModelList ?? this.postGuestModelList,
    );
  }

  @override
  List<Object?> get props => [
        postModel,
        requestState,
        errorMessage,
        postModelList,
        postModelComment,
        commentModelPost,
        postGuestModelList,
      ];
}
