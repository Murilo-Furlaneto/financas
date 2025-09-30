import 'package:financas/domain/model/user/user_model.dart';
import 'package:flutter/material.dart';

abstract class FirebaseRepository {
  Future<void> loginFirebase(String email, String senha, BuildContext context);
  Future<void> signUpFirebase(String nome, String email, String senha);
  Future<void> exitAccoutnFirebase();
  Future<User> getUserInformation();
  Future<void> updateUser(User user);
  Future<void> updatePassword(String novaSenha);
  Future<void> sendPasswordResetEmail(String email);
  Future<User> getCurrentUser();
}
