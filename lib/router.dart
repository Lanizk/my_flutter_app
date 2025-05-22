import 'package:flutter/material.dart';
import 'package:my_flutter_app/features/auth/screen/home/home_screen.dart';
import 'package:my_flutter_app/features/auth/screen/login_screen.dart';
import 'package:my_flutter_app/features/communityr/screens/create_community_screens.dart';
import 'package:routemaster/routemaster.dart';

final logedOutRoute =
    RouteMap(routes: {'/': (_) => const MaterialPage(child: LoginScreen())});

final logedInRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: HomeScreen()),
  '/create-community': (_) => MaterialPage(child: CreateCommunityScreen()),
});
