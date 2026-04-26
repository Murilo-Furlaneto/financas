import 'package:financas/core/result/result.dart';
import 'package:financas/features/auth/domain/entities/user_entity.dart';
import 'package:financas/features/auth/domain/repository/firebase_repository.dart';
import 'package:financas/features/user/domain/repository/user_repository.dart';

class UpdateUserUseCase {
  final FirebaseRepository firebaseRepository;
  final UserRepository userRepository;

  UpdateUserUseCase({
    required this.firebaseRepository,
    required this.userRepository,
  });

  Future<Result<void>> execute(User user) async {
    final result = await firebaseRepository.updateUser(user);
    if (result is Success) {
      return await userRepository.updateUser(user);
    }
    return result;
  }
}
