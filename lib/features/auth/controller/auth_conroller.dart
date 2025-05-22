import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_flutter_app/core/utils.dart';
import 'package:my_flutter_app/features/auth/repository/auth_repository.dart';
import 'package:my_flutter_app/model/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
    (ref) => AuthController(
        authrepository: ref.watch(authRepositoryProvider), ref: ref));

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authrepository;
  final Ref _ref;
  AuthController({required AuthRepository authrepository, required ref})
      : _authrepository = authrepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authrepository.authStateChange;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authrepository.signInWithGoogle();
    state = false;
    user.fold(
        (l) => showSnackBar(context, l.message),
        (UserModel) =>
            _ref.read(userProvider.notifier).update((state) => UserModel));
  }

  Stream<UserModel> getUserData(String uid) {
    return _authrepository.getUserData(uid);
  }
}
