import 'package:financas/core/result/result.dart';
import 'package:financas/features/auth/domain/entities/user_entity.dart';

abstract class FirebaseRepository {
  Future<Result<void>> loginFirebase(String email, String senha);
  Future<Result<void>> signUpFirebase(String nome, String email, String senha);
  Future<Result<void>> exitAccountFirebase();
  Future<Result<User>> getUserInformation();
  Future<Result<void>> updateUser(User user);
  Future<Result<void>> updatePassword(String novaSenha);
  Future<Result<void>> sendPasswordResetEmail(String email);
  Future<Result<User>> getCurrentUser();
}
