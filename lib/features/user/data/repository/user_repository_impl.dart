import 'dart:developer';
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
      log('Saving user: ${user.email}', name: 'UserRepositoryImpl.saveUser');
      await _database.saveUser(user);
      log('User saved successfully', name: 'UserRepositoryImpl.saveUser');
      return const Success(null);
    } catch (e) {
      log('Error saving user: $e', name: 'UserRepositoryImpl.saveUser', error: e);
      return Failure('Erro ao salvar usuário: ${e.toString()}');
    }
  }

  @override
  Future<Result<User?>> getUser() async {
    try {
      log('Fetching user from database', name: 'UserRepositoryImpl.getUser');
      final user = await _database.getUser();
      log('User fetched: ${user?.email ?? 'null'}', name: 'UserRepositoryImpl.getUser');
      return Success(user);
    } catch (e) {
      log('Error fetching user: $e', name: 'UserRepositoryImpl.getUser', error: e);
      return Failure('Erro ao buscar usuário: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> updateUser(User user) async {
    try {
      log('Updating user: ${user.email}', name: 'UserRepositoryImpl.updateUser');
      await _database.updateUser(user);
      log('User updated successfully', name: 'UserRepositoryImpl.updateUser');
      return const Success(null);
    } catch (e) {
      log('Error updating user: $e', name: 'UserRepositoryImpl.updateUser', error: e);
      return Failure('Erro ao atualizar usuário: ${e.toString()}');
    }
  }

  @override
  Future<Result<void>> deleteUser(String email) async {
    try {
      log('Deleting user with email: $email', name: 'UserRepositoryImpl.deleteUser');
      await _database.deleteUser(email);
      log('User deleted successfully', name: 'UserRepositoryImpl.deleteUser');
      return const Success(null);
    } catch (e) {
      log('Error deleting user: $e', name: 'UserRepositoryImpl.deleteUser', error: e);
      return Failure('Erro ao deletar usuário: ${e.toString()}');
    }
  }
}
