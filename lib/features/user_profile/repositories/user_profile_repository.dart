import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/constants/providers/firebase_providers.dart';
import '../../../core/failure.dart';
import '../../../core/type_def.dart';
import '../../../model/user_model.dart';


final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firestore: ref.watch(firestoreProvider));
});

class UserProfileRepository{

final FirebaseFirestore _firestore;
UserProfileRepository({required FirebaseFirestore firestore})
: _firestore = firestore;


CollectionReference get _users =>
_firestore.collection(FirebaseConstants.usersCollection);

FuturVoid editProfile(UserModel user) async {
  try {
    return right(_users.doc(user.uid).update(user.toMap()));
  }

  on FirebaseException catch(e){throw e.message!;}
  catch(e){return left(Failure(e.toString()));
  }}

}