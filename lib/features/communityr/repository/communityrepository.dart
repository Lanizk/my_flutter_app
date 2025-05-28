import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:my_flutter_app/core/constants/firebase_constants.dart';
import 'package:my_flutter_app/core/constants/providers/firebase_providers.dart';
import 'package:my_flutter_app/core/failure.dart';
import 'package:my_flutter_app/core/type_def.dart';
import 'package:my_flutter_app/model/community_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});

class CommunityRepository {
  final FirebaseFirestore _firestore;
  CommunityRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FuturVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if (communityDoc.exists) {
        throw 'Commmunity with the same name already exist!';
      }

      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities
        .where('members', arrayContains: uid)
        .snapshots()
        .map((event) {
      List<Community> communities = [];
      for (var doc in event.docs) {
        communities.add(Community.fromMap(doc.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}
