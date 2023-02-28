import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/constants/firebase_constants.dart';
import 'package:reddit_app/core/failure.dart';
import 'package:reddit_app/core/trype_defs.dart';
import 'package:reddit_app/models/comment_model.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:reddit_app/models/post_model.dart';

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({
    required FirebaseFirestore firebaseFirestore,
  }) : _firestore = firebaseFirestore;

  CollectionReference get _post =>
      _firestore.collection(FireBaseContants.postsCollection);

  CollectionReference get _user =>
      _firestore.collection(FireBaseContants.usersCollection);

  CollectionReference get _comment =>
      _firestore.collection(FireBaseContants.commentsCollection);

  FutureVoid addPost(PostModel postModel) async {
    try {
      return right(
        await _post.doc(postModel.id).set(
              postModel.toMap(),
            ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<PostModel>> fetchUserPost(List<CommunityModel> communites) {
    return _post
        .where(
          'communityName',
          whereIn: communites
              .map(
                (e) => e.name,
              )
              .toList(),
        )
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => PostModel.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  Stream<List<PostModel>> fetchGuestPost() {
    return _post
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => PostModel.fromMap(e.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }

  FutureVoid deletePost(PostModel postModel) async {
    try {
      return right(await _post.doc(postModel.id).delete());
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void upvotes(PostModel postModel) async {
    if (postModel.downvotes.contains(uid)) {
      await _post.doc(postModel.id).update({
        'downvotes': FieldValue.arrayRemove([uid]),
      });
    }

    if (postModel.upvotes.contains(uid)) {
      await _post.doc(postModel.id).update({
        'upvotes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await _post.doc(postModel.id).update({
        'upvotes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  void downvotes(PostModel postModel) async {
    if (postModel.upvotes.contains(uid)) {
      await _post.doc(postModel.id).update({
        'upvotes': FieldValue.arrayRemove([uid]),
      });
    }

    if (postModel.downvotes.contains(uid)) {
      await _post.doc(postModel.id).update({
        'downvotes': FieldValue.arrayRemove([uid]),
      });
    } else {
      await _post.doc(postModel.id).update({
        'downvotes': FieldValue.arrayUnion([uid]),
      });
    }
  }

  Stream<PostModel> getPostByid(String idPost) {
    return _post.doc(idPost).snapshots().map(
      (event) {
        return PostModel.fromMap(event.data() as Map<String, dynamic>);
      },
    );
  }

  FutureVoid addCommentPost(CommentModel commentModel) async {
    try {
      return right(_comment.doc(commentModel.id).set(commentModel.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<CommentModel>> getCommentPost(String postId) {
    return _comment
        .where('postId', isEqualTo: postId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => CommentModel.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }

  FutureVoid awardPost(
    PostModel postModel,
    String award,
    String senderId,
  ) async {
    try {
      await _post.doc(postModel.id).update({
        'awards': FieldValue.arrayUnion([award]),
      });
      await _user.doc(senderId).update({
        'awards': FieldValue.arrayRemove([award]),
      });

      return right(
        await _user.doc(postModel.uid).update({
          'awards': FieldValue.arrayUnion([award])
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
