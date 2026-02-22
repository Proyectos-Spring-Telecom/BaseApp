import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<UserEntity> getProfile();
  
  Future<UserEntity> updateProfile({
    String? name,
    String? avatarUrl,
  });
}
