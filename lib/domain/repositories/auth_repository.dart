import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String email,
    required String password,
  });
  
  Future<void> logout();
  
  Future<UserEntity?> getCurrentUser();
  
  Future<bool> isLoggedIn();
  
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
