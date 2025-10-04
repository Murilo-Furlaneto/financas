import 'package:financas/data/repositories/user_repository.dart';
import 'package:financas/domain/model/user/user_model.dart';
import 'package:financas/data/database/local/sqlite.dart';

class UserRepositoryImpl implements UserRepository {
  final SqliteDataBase _database;

  UserRepositoryImpl(this._database);

  @override
  Future<void> saveUser(User user) async {
    await _database.saveUser(user);
  }

  @override
  Future<User?> getUser() async {
    return _database.getUser();
  }

  @override
  Future<void> updateUser(User user) async {
    await _database.updateUser(user);
  }

  @override
  Future<void> deleteUser(String email) async {
    await _database.deleteUser(email);
  }
}
