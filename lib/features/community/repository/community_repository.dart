import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/constants/firebase_constants.dart';
import 'package:reddit_app/core/failure.dart';
import 'package:reddit_app/core/trype_defs.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:reddit_app/models/post_model.dart';

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({
    required FirebaseFirestore firebaseFirestore,
  }) : _firestore = firebaseFirestore;

  CollectionReference get _communites =>
      _firestore.collection(FireBaseContants.communitiesCollection);

  CollectionReference get _post =>
      _firestore.collection(FireBaseContants.postsCollection);

  FutureVoid createNewCommunity(CommunityModel communityModel) async {
    try {
      final communityDoc = await _communites.doc(communityModel.name).get();

      if (communityDoc.exists) {
        throw 'Community with the same name already exists!';
      }
      return right(
        _communites.doc(communityModel.name).set(
              communityModel.toMap(),
            ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(
        Failure(
          e.toString(),
        ),
      );
    }
  }

  FutureVoid joinCommunity(String communityName) async {
    try {
      return right(await _communites.doc(communityName).update({
        'members': FieldValue.arrayUnion([uid])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName) async {
    try {
      return right(await _communites.doc(communityName).update({
        'members': FieldValue.arrayRemove([uid])
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addModsToCommunity(
      String nameCommunity, List<String> uidSet) async {
    try {
      return right(await _communites.doc(nameCommunity).update({
        'mods': uidSet,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<CommunityModel>> getUserCommunities(String uid) {
    return _communites.where('members', arrayContains: uid).snapshots().map(
      (event) {
        List<CommunityModel> communities = [];
        for (var community in event.docs) {
          communities.add(
            CommunityModel.fromMap(community.data() as Map<String, dynamic>),
          );
        }
        return communities;
      },
    );
  }

  Stream<CommunityModel> getCommunityByName(String name) {
    return _communites.doc(name).snapshots().map(
          (event) =>
              CommunityModel.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  FutureEither<void> editCommunity(CommunityModel communityModel) async {
    try {
      return right(
        await _communites.doc(communityModel.name).update(
              communityModel.toMap(),
            ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Stream<List<CommunityModel>> searchCommunity(String query) {
    return _communites
        .where('name',
            isGreaterThan: query.isEmpty ? 0 : query,
            isLessThan: query.isEmpty
                ? null
                : query.substring(0, query.length - 1) +
                    String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
        .snapshots()
        .map(
      (event) {
        List<CommunityModel> communities = [];
        for (var community in event.docs) {
          communities.add(
              CommunityModel.fromMap(community.data() as Map<String, dynamic>));
        }
        return communities;
      },
    );
  }

  Stream<List<PostModel>> getPostCommunity(String name) {
    return _post
        .where('communityName', isEqualTo: name)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (event) => event.docs
              .map(
                (e) => PostModel.fromMap(
                  e.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }
}
