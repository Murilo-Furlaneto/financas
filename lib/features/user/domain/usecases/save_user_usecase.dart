import 'package:financas/core/result/result.dart';
import 'package:financas/features/auth/domain/entities/user_entity.dart';
import 'package:financas/features/user/domain/repository/user_repository.dart';

class SaveUserUseCase {
  final UserRepository repository;

  SaveUserUseCase(this.repository);

  Future<Result<void>> execute(User user) {
    return repository.saveUser(user);
  }
}
