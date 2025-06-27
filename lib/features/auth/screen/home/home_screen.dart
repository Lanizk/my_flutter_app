import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/core/constants/constants.dart';
import 'package:my_flutter_app/features/auth/controller/auth_conroller.dart';
import 'package:my_flutter_app/features/auth/screen/drawer/community_list_drawer.dart';
import 'package:my_flutter_app/features/auth/screen/drawer/profiledrawer.dart';
import 'package:my_flutter_app/home/delegates/search_community_delegate.dart';
import 'package:my_flutter_app/theme/pallete.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}
  class _HomeScreenState extends ConsumerState<HomeScreen> {

  int _page=0;


    void displayDrawer(BuildContext context) {
      Scaffold.of(context).openDrawer();
    }

    void displayEndDrawer(BuildContext context) {
      Scaffold.of(context).openEndDrawer();
    }

    void onPageChanged(int page){
      setState(() {
        _page=page;
      });
    }

    @override
    Widget build(BuildContext context) {
      final user = ref.watch(userProvider)!;
      final currentTheme = ref.watch(themeNotifierProvider);

      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: false,
          leading: Builder(builder: (context) {
            return IconButton(
              onPressed: () => displayDrawer(context),
              icon: const Icon(Icons.menu),
            );
          }),
          actions: [
            IconButton(onPressed: () {
              showSearch(
                  context: context, delegate: SearchCommunityDelegate(ref));
            }, icon: const Icon(Icons.search)),

            Builder(
                builder: (context) {
                  return IconButton(
                    onPressed: () => displayEndDrawer(context),
                    icon: CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic),
                    ),
                  );
                }
            )
          ],
        ),

        body: Constants.tabwidgets[_page],
        drawer: CommunityListDrawer(),
        endDrawer: const ProfileDrawer(),
        bottomNavigationBar: CupertinoTabBar(
            activeColor: currentTheme.iconTheme.color,
            backgroundColor: currentTheme.scaffoldBackgroundColor,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.add), label: '')
            ],
        onTap: onPageChanged,
        currentIndex: _page,),
      );
    }
  }

