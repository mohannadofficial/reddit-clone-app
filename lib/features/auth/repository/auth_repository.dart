import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/constants/firebase_constants.dart';
import 'package:reddit_app/core/failure.dart';
import 'package:reddit_app/core/trype_defs.dart';
import 'package:reddit_app/models/post_model.dart';
import 'package:reddit_app/models/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
    required GoogleSignIn googleSignIn,
  })  : _auth = firebaseAuth,
        _firestore = firebaseFirestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _user =>
      _firestore.collection(FireBaseContants.usersCollection);

  CollectionReference get _post =>
      _firestore.collection(FireBaseContants.postsCollection);

  Stream<String> getCurrentUser() {
    return _auth.authStateChanges().map((User? user) {
      if (user != null) {
        return user.uid;
      } else {
        return '';
      }
    });
  }

  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential;

      userCredential = await _auth.signInWithCredential(credential);
      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'No Name',
          awards: const ['thankyou', 'rocket', 'til', 'helpful'],
          banner: AppContants.bannerDefault,
          profilePic:
              userCredential.user!.photoURL ?? AppContants.avatarDefault,
          isAuthenticated: true,
          karma: 0,
        );
        await _user.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInAsGuest() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          uid: userCredential.user!.uid,
          name: 'Guest',
          awards: const [],
          banner: AppContants.bannerDefault,
          profilePic: AppContants.avatarDefault,
          isAuthenticated: false,
          karma: 0,
        );
        await _user.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _user.doc(uid).snapshots().map(
          (event) => UserModel.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  Future<UserModel> getUserDataByCommunity(String uid) async {
    final res = await _user.doc(uid).get();
    return UserModel.fromMap(res.data() as Map<String, dynamic>);
  }

  Future<UserModel> getUserByUid(String pushUid) async {
    final res = await _user.doc(pushUid).get();
    return UserModel.fromMap(res.data() as Map<String, dynamic>);
  }

  // edit user

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_user.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // post

  Stream<List<PostModel>> getPostUser(String pushUid) {
    return _post
        .where('uid', isEqualTo: pushUid)
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
