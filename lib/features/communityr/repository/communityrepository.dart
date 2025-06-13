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


  FuturVoid joinCommunity( String communityName, String userId) async{
    try{

     return right( _communities.doc(communityName).update({
        'members':FieldValue.arrayUnion([userId]),
      }));
    }

        on FirebaseException catch(e){
      throw e.message!;
        }

    catch (e){
      return left(Failure(e.toString()));
    }
  }

  FuturVoid leaveCommunity( String communityName, String userId) async{
    try{

      return right( _communities.doc(communityName).update({
        'members':FieldValue.arrayRemove([userId]),
      }));
    }

    on FirebaseException catch(e){
      throw e.message!;
    }

    catch (e){
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

  Stream<Community> getCommunityByName(String name) {
    return _communities.doc(name).snapshots().map(
        (event) => Community.fromMap(event.data() as Map<String, dynamic>));
  }

  FuturVoid editCommunity(Community community) async {
    try {
      return right(_communities.doc(community.name).update(community.toMap()));
    }

        on FirebaseException catch(e){throw e.message!;}
        catch(e){return left(Failure(e.toString()));
  }}

  FuturVoid addMods(String communityName, List<String> uids) async {
    try {
      return right(_communities.doc(communityName).update({'mods':uids,}));
    }

    on FirebaseException catch(e){throw e.message!;}
    catch(e){return left(Failure(e.toString()));
    }}

  Stream<List<Community>> searchCommunity(String query){
     return _communities
         .where('name',isGreaterThanOrEqualTo: query.isEmpty? null :query,
     isLessThan: query.isEmpty ? null
     :query.substring(0,query.length-1)+String.fromCharCode(query.codeUnitAt(query.length-1)+1,))
         .snapshots()
    .map((event){
      List<Community> communities=[];
      for(var community in event.docs){
        communities.add(Community.fromMap(community.data() as Map<String,dynamic>));
      }
      return communities;
     });
  }

  CollectionReference get _communities =>
      _firestore.collection(FirebaseConstants.communitiesCollection);
}
