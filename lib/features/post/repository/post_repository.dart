import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:my_flutter_app/core/constants/firebase_constants.dart';

import '../../../core/constants/providers/firebase_providers.dart';
import '../../../core/failure.dart';
import '../../../core/type_def.dart';
import '../../../model/community_model.dart';
import '../../../model/post_model.dart';

final postRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(firestoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;

  PostRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _posts=> _firestore.collection(FirebaseConstants.postsCollection);


  FuturVoid addPost(Post post) async {
     try {
       return right(_posts.doc(post.id).set(post.toMap()));

    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>>  fetchUserPosts(List<Community> communities) {

    return _posts.where('communityName', whereIn: communities.map((e)=>e.name).toList())
                 .orderBy('createdAt', descending: true)
                  .snapshots()
                  .map(
        (event)=>event.docs
            .map(
            (e)=>Post.fromMap(e.data()  as  Map<String, dynamic>,),
        ).toList()
        );

  }
}