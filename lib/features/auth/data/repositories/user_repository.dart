import 'package:financas/core/result/result.dart';
import 'package:financas/features/auth/domain/entities/user_entity.dart';

abstract class UserRepository {
  Future<Result<void>> saveUser(User user);
  Future<Result<User?>> getUser();
  Future<Result<void>> updateUser(User user);
  Future<Result<void>> deleteUser(String email);
}
