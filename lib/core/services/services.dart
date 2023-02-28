import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_app/core/services/storage_repository.dart';
import 'package:reddit_app/features/auth/controller/auth_cubit.dart';
import 'package:reddit_app/features/auth/repository/auth_repository.dart';
import 'package:reddit_app/features/community/controller/community_cubit.dart';
import 'package:reddit_app/features/community/repository/community_repository.dart';
import 'package:reddit_app/features/post/controller/post_cubit.dart';
import 'package:reddit_app/features/post/repository/post_repository.dart';
import 'package:reddit_app/features/user_profile/controller/edit_profile_cubit.dart';
import 'package:reddit_app/features/user_profile/repository/user_profile_repository.dart';

final sl = GetIt.instance;

class ServicesLocator {
  void init() {
    // Repostiory
    sl.registerLazySingleton<AuthRepository>(() => AuthRepository(
        firebaseAuth: sl(), firebaseFirestore: sl(), googleSignIn: sl()));

    sl.registerLazySingleton<CommunityRepository>(
        () => CommunityRepository(firebaseFirestore: sl()));
    sl.registerLazySingleton<StorageRepository>(
        () => StorageRepository(firebaseStorage: sl()));

    sl.registerLazySingleton<UserProfileRepostiry>(
        () => UserProfileRepostiry(firebaseFirestore: sl()));

    sl.registerLazySingleton<PostRepository>(
      () => PostRepository(firebaseFirestore: sl()),
    );

    // Controller
    sl.registerLazySingleton<AuthCubit>(
      () => AuthCubit(authRepository: sl(), storageRepository: sl()),
    );

    sl.registerLazySingleton<CommunityCubit>(
      () => CommunityCubit(communityRepository: sl(), storageRepository: sl()),
    );

    sl.registerLazySingleton<EditProfileCubit>(
      () =>
          EditProfileCubit(storageRepository: sl(), userProfileRepostiry: sl()),
    );

    sl.registerLazySingleton<PostCubit>(
      () => PostCubit(postRepository: sl(), storageRepository: sl()),
    );

    // FirebaseInstance
    sl.registerLazySingleton<FirebaseAuth>(
      () => FirebaseAuth.instance,
    );
    sl.registerLazySingleton<FirebaseStorage>(
      () => FirebaseStorage.instance,
    );
    sl.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
    sl.registerLazySingleton<GoogleSignIn>(
      () => GoogleSignIn(),
    );
  }
}
