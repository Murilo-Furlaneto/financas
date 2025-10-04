import 'package:financas/domain/model/user/user_model.dart';

abstract class UserRepository {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> updateUser(User user);
  Future<void> deleteUser(String email);
}
