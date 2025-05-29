// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/common/error_text.dart';
import 'package:my_flutter_app/common/loader.dart';
import 'package:my_flutter_app/features/communityr/controller/communitycontroller.dart';

class communityScreen extends ConsumerWidget {
  final String name;
  const communityScreen({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
          data: (community) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    expandedHeight: 150,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(child: Image.network(community.banner))
                      ],
                    ),
                  )
                ];
              },
              body: const Text('Displaying Post')),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
