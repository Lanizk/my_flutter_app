import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/common/post_card.dart';
import 'package:my_flutter_app/features/post/controller/post_controller.dart';
import 'package:my_flutter_app/features/post/widget/comment_card.dart';

import '../../../common/error_text.dart';
import '../../../common/loader.dart';
import '../../../model/post_model.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postID;
  const CommentScreen({super.key, required this.postID});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {

  final commentController=TextEditingController();

  @override
  void dispose(){
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post){
      ref.read(postControllerProvider.notifier).addComment(
          context: context,
          text: commentController.text.trim(),
          post: post);

      setState(() {
        commentController.text='';
      });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postID)).when(
          data: (data){

            return Column(
              children: [
                PostCard(post: data),
                TextField(
                  onSubmitted: (val)=>addComment(data),
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'What are your Thoughts?',
                    filled: true,
                     border: InputBorder.none
                  ),
                ),
                ref.watch(getPostCommentsProvider(widget.postID)).when(
                    data: (data){
                      return Expanded(
                        child: ListView.builder(
                            itemCount: data.length,
                            itemBuilder: (BuildContext context, int index)
                        {
                          final comment= data[index];
                          return CommentCard(comment: comment);
                        }),
                      );
                    },
                    error: (error, StackTrace) {
                      print(error.toString());
                      return ErrorText(error: error.toString());
            },
                    loading: () => const Loader())
              ],
            );
          },
          error: (error, StackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader())
    );
  }
}
