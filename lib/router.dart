import 'package:flutter/material.dart';
import 'package:my_flutter_app/features/auth/screen/home/home_screen.dart';
import 'package:my_flutter_app/features/auth/screen/login_screen.dart';
import 'package:my_flutter_app/features/communityr/screens/community_screen.dart';
import 'package:my_flutter_app/features/communityr/screens/create_community_screens.dart';
import 'package:my_flutter_app/features/communityr/screens/edit_community_screen.dart';
import 'package:my_flutter_app/features/communityr/screens/mod_tools_screen.dart';
import 'package:routemaster/routemaster.dart';

final logedOutRoute =
    RouteMap(routes: {'/': (_) => const MaterialPage(child: LoginScreen())});

final logedInRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: HomeScreen()),
  '/create-community': (_) => MaterialPage(child: CreateCommunityScreen()),
  '/r/:name': (route) => MaterialPage(
          child: communityScreen(
        name: route.pathParameters['name']!,
      )),
  '/mod-tools/:name': (routeData) => MaterialPage(child: ModToolsScreen(
    name:routeData.pathParameters['name']!,
  )),
  '/edit-community/:name': (routeData) => MaterialPage(child: EditCommunityScreen(
    name:routeData.pathParameters['name']!,
  )),
});
