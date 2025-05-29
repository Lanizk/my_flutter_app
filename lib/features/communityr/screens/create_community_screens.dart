import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/common/loader.dart';
import 'package:my_flutter_app/features/communityr/controller/communitycontroller.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    ref
        .read(communityControllerProvider.notifier)
        .createCommunity(communityNameController.text.trim(), context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Community Name'),
        ),
        body: isLoading
            ? Loader()
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text('Community Name')),
                    const SizedBox(height: 10),
                    TextField(
                      controller: communityNameController,
                      decoration: InputDecoration(
                        hintText: 'r/Community Name',
                        filled: true,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(18),
                      ),
                      maxLength: 21,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: createCommunity,
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                        child: const Text(
                          'Create Community',
                          style: TextStyle(fontSize: 17),
                        ))
                  ],
                )));
  }
}
