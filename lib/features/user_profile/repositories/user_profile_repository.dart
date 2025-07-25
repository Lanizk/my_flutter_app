import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../core/constants/firebase_constants.dart';
import '../../../core/constants/providers/firebase_providers.dart';
import '../../../core/failure.dart';
import '../../../core/type_def.dart';
import '../../../model/post_model.dart';
import '../../../model/user_model.dart';


final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firestore: ref.watch(firestoreProvider));
});

class UserProfileRepository{

final FirebaseFirestore _firestore;
UserProfileRepository({required FirebaseFirestore firestore})
: _firestore = firestore;

final CollectionReference _posts = FirebaseFirestore.instance.collection('posts');

CollectionReference get _users =>
_firestore.collection(FirebaseConstants.usersCollection);

FuturVoid editProfile(UserModel user) async {
  try {
    return right(_users.doc(user.uid).update(user.toMap()));
  }

  on FirebaseException catch(e){throw e.message!;}
  catch(e){return left(Failure(e.toString()));
  }}


  Stream <List<Post>> getUSerPosts(String uid){

  return _posts.
  where('uid', isEqualTo: uid)
      .orderBy('createdAt',descending:true)
      .snapshots()
      .map((event) =>event.docs
      .map((e)=>Post.fromMap(
    e.data() as Map<String, dynamic>
    )).toList());
 }

FuturVoid updateUserKarma(UserModel user) async {
  try {
    return right(_users.doc(user.uid).update({'karma':user.karma})
    );
  }
  on FirebaseException catch(e){throw e.message!;}
  catch(e){return left(Failure(e.toString()));
  }}

}

