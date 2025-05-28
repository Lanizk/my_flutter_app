import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/common/error_text.dart';
import 'package:my_flutter_app/common/loader.dart';
import 'package:my_flutter_app/features/communityr/controller/communitycontroller.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
        child: SafeArea(
            child: Column(
      children: [
        ListTile(
          title: Text('Create a Community'),
          leading: Icon(Icons.add),
          onTap: () => navigateToCreateCommunity(context),
        ),
        ref.watch(userCommunitiesProvider).when(
            data: (communities) => Expanded(
                  child: ListView.builder(
                      itemCount: communities.length,
                      itemBuilder: (BuildContext context, int index) {
                        final community = communities[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(community.avatar),
                          ),
                          title: Text('r/${community.name}'),
                          onTap: () {},
                        );
                      }),
                ),
            error: (error, StackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader()),
      ],
    )));
  }
}
