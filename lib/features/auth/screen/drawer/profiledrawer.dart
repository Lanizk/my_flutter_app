import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/features/auth/controller/auth_conroller.dart';
import 'package:my_flutter_app/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';


class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logOut();
  }
   void navigateToUserProfile(BuildContext context,String uid){
    Routemaster.of(context).push('u/$uid');
   }

   void toggleTheme(WidgetRef ref) {

    ref.read(themeNotifierProvider.notifier).toggleTheme();
   }

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    final user=ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(child:
      Column(children: [
        CircleAvatar(
          backgroundImage: NetworkImage(user.profilePic),
          radius: 70,
        ),
        const SizedBox(height: 10,),
        Text('u/${user.name}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),),
        const SizedBox(height: 10,),
        const Divider(),

        ListTile(
          title: Text('My Profile'),
          leading: Icon(Icons.person),
          onTap: () =>navigateToUserProfile(context, user.uid),
        ),

        ListTile(
          title: Text('Log Out'),
          leading: Icon(Icons.logout, color: Pallete.redColor,),
          onTap: () =>logOut(ref)
        ),

        Switch.adaptive(value: ref.watch(themeNotifierProvider.notifier).mode==ThemeMode.dark,
            onChanged: (val)=>toggleTheme(ref))
      ],)),
    );
  }
}
