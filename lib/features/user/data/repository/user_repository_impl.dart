import 'package:financas/core/result/result.dart';
import 'package:financas/core/database/local/sqlite.dart';
import 'package:financas/features/user/domain/repository/user_repository.dart';
import 'package:financas/features/auth/domain/entities/user_entity.dart';

class UserRepositoryImpl implements UserRepository {
  final SqliteDataBase _database;

  UserRepositoryImpl(this._database);

  @override
  Future<Result<void>> saveUser(User user) async {
    try {
      await _database.saveUser(user);
      return const Success(null);
    } catch (e) {
      return Failure('Erro ao salvar usuário: ${e.toString()}');
    }
  }

  @override
  Future<Result<User?>> getUser() async {
    try {
      final user = await _database.getUser();
      return Success(user);
    } catch (e) {
      return Failure('Erro ao buscar usuário: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> updateUser(User user) async {
    try {
      await _database.updateUser(user);
      return const Success(null);
    } catch (e) {
      return Failure('Erro ao atualizar usuário: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> deleteUser(String email) async {
    try {
      await _database.deleteUser(email);
      return const Success(null);
    } catch (e) {
      return Failure('Erro ao deletar usuário: ${e.toString()}');
    }
  }
}
