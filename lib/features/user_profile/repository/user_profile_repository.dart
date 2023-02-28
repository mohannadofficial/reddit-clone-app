import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:reddit_app/core/constants/firebase_constants.dart';
import 'package:reddit_app/core/failure.dart';
import 'package:reddit_app/core/trype_defs.dart';
import 'package:reddit_app/core/utils.dart';
import 'package:reddit_app/models/user_model.dart';

class UserProfileRepostiry {
  final FirebaseFirestore _firebaseFirestore;
  UserProfileRepostiry({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _user =>
      _firebaseFirestore.collection(FireBaseContants.usersCollection);

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_user.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid updateKarma(UserModel user, int karma) async {
    try {
      return right(_user.doc(user.uid).update({'karma': karma}));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
