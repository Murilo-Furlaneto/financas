import 'package:financas/domain/entities/user/user_entity.dart';

abstract class UserRepository {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> updateUser(User user);
  Future<void> deleteUser(String email);
}
