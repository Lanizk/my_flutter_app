import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/core/utils.dart';
import 'package:my_flutter_app/features/user_profile/controller/user_profile_controller.dart';
import 'package:my_flutter_app/model/post_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/providers/storage_repository_provider.dart';
import '../../../core/enums/enums.dart';
import '../../../model/comments_model.dart';
import '../../../model/community_model.dart';
import '../../auth/controller/auth_conroller.dart';
import '../repository/post_repository.dart';


final postControllerProvider =
StateNotifierProvider<PostController, bool>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return PostController(
      postRepository: postRepository, ref: ref,storageRepository:storageRepository);

});

final userPostsProvider = StreamProvider.family((ref, List<Community> communities) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.fetchUserPosts(communities);
});

final getPostByIdProvider =StreamProvider.family((ref, String postId){
  final postController=ref.watch(postControllerProvider.notifier);
  return postController.getPostById(postId);
});

final getPostCommentsProvider =StreamProvider.family((ref, String postId){
  final postController=ref.watch(postControllerProvider.notifier);
  return postController.fetchPostComment(postId);
});

class PostController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;

  PostController({
    required PostRepository postRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })
      : _postRepository = postRepository,
        _ref = ref,
        _storageRepository=storageRepository,
        super(false);


  void shareTextPost({

    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description
})
  async{
    state=true;
    String postId=const Uuid().v1();
    final user=_ref.read(userProvider)!;

    final Post post=Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'text',
        createdAt: DateTime.now(),
        awards: [],
        description: description);

     final res= await  _postRepository.addPost(post);
     _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.textPost);
     state=false;
     res.fold((l)=>showSnackBar(context, l.message), (r){
       showSnackBar(context, 'Posted Successfully ');
       Routemaster.of(context).pop();
     });
  }

  void shareLinkPost({

    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link
  })
  async{
    state=true;
    String postId=const Uuid().v1();
    final user=_ref.read(userProvider)!;

    final Post post=Post(
        id: postId,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upvotes: [],
        downvotes: [],
        commentCount: 0,
        username: user.name,
        uid: user.uid,
        type: 'text',
        createdAt: DateTime.now(),
        awards: [],
        link: link);

    final res= await  _postRepository.addPost(post);
    _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.linkPost);
    state=false;
    res.fold((l)=>showSnackBar(context, l.message), (r){
      showSnackBar(context, 'Posted Successfully ');
      Routemaster.of(context).pop();
    });
  }

  void shareImagePost({

    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? file,
  })
  async {
    state = true;
    String postId = const Uuid().v1();
    final user = _ref.read(userProvider)!;
    final imageRes = await _storageRepository.storeFile(
      path: 'posts/${selectedCommunity.name}',
      id: postId,
      file: file,
    );

    imageRes.fold((l) => showSnackBar(context, l.message), (r) async {
      final Post post = Post(
          id: postId,
          title: title,
          communityName: selectedCommunity.name,
          communityProfilePic: selectedCommunity.avatar,
          upvotes: [],
          downvotes: [],
          commentCount: 0,
          username: user.name,
          uid: user.uid,
          type: 'text',
          createdAt: DateTime.now(),
          awards: [],
          link: r);

      final res = await _postRepository.addPost(post);
      _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.imagePost);
      state = false;
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Posted Successfully ');
        Routemaster.of(context).pop();
      });
    });
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities) {
    if (communities.isNotEmpty) {
      return _postRepository.fetchUserPosts(communities);
    }
    return Stream.value([]);
  }

    void deletePost(Post post, BuildContext context) async {
      final res = await _postRepository.deletePost(post);
      _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.deletePost);
      res.fold((l) => null, (r) => showSnackBar(context, 'Post Deleted successfully!'));
    }

  void upvote(Post post) async{
    final uid=_ref.read(userProvider)!.uid;
    _postRepository.upvote(post, uid);
  }

  void downvote(Post post) async{
    final uid=_ref.read(userProvider)!.uid;
    _postRepository.downvote(post, uid);
  }

  Stream <Post> getPostById( String postId){
    return _postRepository.getPostById(postId);
  }

  void addComment({

    required BuildContext context,
    required String text,
    required Post post,
})

  async{

    final user= _ref.read(userProvider)!;
    String commentId=const Uuid().v1();
    Comment comment=Comment(
      id:commentId,
      text:text,
      createdAt:DateTime.now(),
      postId:post.id,
      username:user.name,
      profilePic:user.profilePic
    );

    _postRepository.addComment(comment);

    final res= await _postRepository.addComment(comment);
    _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.comment);
    res.fold((l)=>showSnackBar(context, l.message), (r)=>null);
  }


  Stream<List<Comment>> fetchPostComment(String postId) {

      return _postRepository.getCommentOfPost(postId);
    }

  }
