import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/common/post_card.dart';
import 'package:my_flutter_app/features/communityr/controller/communitycontroller.dart';
import 'package:my_flutter_app/features/post/controller/post_controller.dart';

import '../../common/error_text.dart';
import '../../common/loader.dart';


class FeedScreen extends ConsumerWidget{

  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  ref.watch(userCommunitiesProvider).when(
        data: (communities)=>ref.watch(userPostsProvider(communities)).when(
           data: (data){
             return ListView.builder(
                 itemCount: data.length,
                 itemBuilder: (BuildContext context, int index){
                   final post=data[index];
                   return PostCard(post :post);
                 });
           },
            error: (error, StackTrace) {
               print(error);
              return ErrorText(error: error.toString());

            },
            loading: () => const Loader()),

        error: (error, StackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}