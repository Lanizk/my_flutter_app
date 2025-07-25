import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/common/error_text.dart';
import 'package:my_flutter_app/common/loader.dart';
import 'package:my_flutter_app/common/post_card.dart';
import 'package:my_flutter_app/features/communityr/controller/communitycontroller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../model/community_model.dart';
import '../../auth/controller/auth_conroller.dart';
import '../controller/user_profile_controller.dart';


class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});

void navigateToEditUser(BuildContext context){
  Routemaster.of(context).push('/edit-profile/$uid');
}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
        data: (community) => NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 250,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          user.profilePic,
                          fit: BoxFit.cover,
                        ),
                      ),

                       Container(
                         alignment: Alignment.bottomLeft,
                         padding: const EdgeInsets.all(20).copyWith(bottom:70),
                         child: CircleAvatar(
                            backgroundImage: NetworkImage(community.profilePic),
                            radius: 45,
                          ),
                       ),

                      Container(

                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(20),
                        child: OutlinedButton(
                          onPressed: ()=>navigateToEditUser(context),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                          ),
                          child:const Text('Edit Profile'),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'u/${user.name}',
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                          ],
                        ),
                        Container(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              '${user.karma} karma',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(thickness: 2,)
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: ref.watch(getUserPostsProvider(uid)).when(
                data: (data){
                  return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index){
                            final post=data[index];
                            return PostCard(post: post);
                      });
                },
                error: (error,stackTrace){
                  print(error.toString());
                  return ErrorText(error: error.toString());
                },
                loading: () => const Loader(),

    )),

        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      ),
    );
  }
}