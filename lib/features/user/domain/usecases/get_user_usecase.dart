import 'package:financas/core/result/result.dart';
import 'package:financas/features/auth/domain/entities/user_entity.dart';
import 'package:financas/features/user/domain/repository/user_repository.dart';

class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  Future<Result<User?>> execute() {
    return repository.getUser();
  }
}
