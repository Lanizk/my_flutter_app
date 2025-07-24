import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/features/auth/controller/auth_conroller.dart';
import 'package:my_flutter_app/features/user_profile/repositories/user_profile_repository.dart';
import 'package:my_flutter_app/model/user_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/constants/providers/storage_repository_provider.dart';
import '../../../core/enums/enums.dart';
import '../../../core/utils.dart';
import '../../../model/post_model.dart';

final userProfileControllerProvider =
StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
      userProfileRepository: userProfileRepository,
      ref: ref,
      storageRepository:storageRepository);

});

final getUserPostsProvider=StreamProvider.family((ref, String uid){
  return ref.read(userProfileControllerProvider.notifier).getUSerPosts(uid);
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })
      : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository=storageRepository,
        super(false);

  void editProfile({
    required File? profileFile,
    required File? bannerFile,
    required BuildContext context,
    required String name

  }) async{
    state=true;

    UserModel user=_ref.read(userProvider)!;
    if(profileFile !=null){
      final res=await _storageRepository.storeFile(
          path: 'users/profile', id: user.uid, file: profileFile);
      res.fold((l)=>showSnackBar(context, l.message),
              (r)=>user=user.copyWith(profilePic:r));
    }

    if(bannerFile !=null){
      final res=await _storageRepository.storeFile(
          path: 'users/banner', id: user.uid, file: bannerFile);
      res.fold((l)=>showSnackBar(context, l.message),
              (r)=>user=user.copyWith(banner:r));
    }
    user = user.copyWith(name: name);

    final res=await _userProfileRepository.editProfile(user);
    state=false;
    res.fold(
          (l)=>showSnackBar(context, l.message),
          (r)  { _ref.read(userProvider.notifier).update((state)=>user);
            Routemaster.of(context).pop();
          }
    );
  }

  Stream <List<Post>> getUSerPosts(String uid)
  {
    return _userProfileRepository.getUSerPosts(uid);
  }


  void updateUserKarma(UserKarma karma) async{

   UserModel user=_ref.read(userProvider)!;
   user=user.copyWith(karma: user.karma+ karma.karma);

   final res= await _userProfileRepository.updateUserKarma(user);
   res.fold((l)=>null, (r)=>_ref.read(userProvider.notifier).update((state)=>user));
  }

}