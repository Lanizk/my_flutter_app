// // ignore_for_file: public_member_api_docs, sort_constructors_first
 import 'package:flutter/material.dart';
 import 'package:flutter_riverpod/flutter_riverpod.dart';
 import 'package:my_flutter_app/common/error_text.dart';
 import 'package:my_flutter_app/common/loader.dart';
import 'package:my_flutter_app/features/communityr/controller/communitycontroller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../common/post_card.dart';
import '../../../model/community_model.dart';
import '../../auth/controller/auth_conroller.dart';






// class communityScreen extends ConsumerWidget {
//   final String name;
//   const communityScreen({
//     super.key,
//     required this.name,
//   });
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       body: ref.watch(getCommunityByNameProvider(name)).when(
//           data: (community) => NestedScrollView(
//               headerSliverBuilder: (context, innerBoxIsScrolled) {
//                 return [
//                   SliverAppBar(
//                     expandedHeight: 150,
//                     floating: true,
//                     snap: true,
//                     flexibleSpace: Stack(
//                       children: [
//                         Positioned.fill(
//                           child: Image.network(community.banner,
//                               fit: BoxFit.cover),
//                         )
//                       ],
//                     ),
//                   ),
//                   SliverPadding(
//                     padding: const EdgeInsets.all(16),
//                     sliver: SliverList(
//                         delegate: SliverChildListDelegate([
//                       Align(
//                         alignment: Alignment.topLeft,
//                         child: CircleAvatar(
//                           backgroundImage: NetworkImage(community.avatar),
//                           radius: 35,
//                         ),
//                       ),
//                       const SizedBox(height: 5),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             '${community.name}',
//                             style: const TextStyle(
//                               fontSize: 19,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           OutlinedButton(
//                               onPressed: () {}, child: const Text('Join'))
//                         ],
//                       )
//                     ])),
//                   )
//                 ];
//               },
//               body: const Text('Displaying Post')),
//           error: (error, stackTrace) => ErrorText(error: error.toString()),
//           loading: () => const Loader()),
//     );
//   }
// }




class communityScreen extends ConsumerWidget {
  final String name;
  const communityScreen({super.key, required this.name});

  // http://localhost:4000/r/flutter

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
    ref.read(communityControllerProvider.notifier).joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
        data: (community) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 150,
                floating: true,
                snap: true,
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        community.banner,
                        fit: BoxFit.cover,
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
                      Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(community.avatar),
                          radius: 35,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'r/${community.name}',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!isGuest)
                            community.mods.contains(user.uid)
                                ? OutlinedButton(
                              onPressed: () {
                                navigateToModTools(context);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              child: const Text('Mod Tools'),
                            )
                                : OutlinedButton(
                              onPressed: () => joinCommunity(ref, community, context),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              child: Text(community.members.contains(user.uid) ? 'Joined' : 'Join'),
                            ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          '${community.members.length} members',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
            body: ref.watch(getCommunityPostsProvider(name)).when(
              data: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final post = data[index];
                    return PostCard(post: post);
                  },
                );
              },
              error: (error,stackTrace){
                print(error.toString());
                return ErrorText(error: error.toString());
              },
              loading: () => const Loader(),

            )),

        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),

        ));

  }
}