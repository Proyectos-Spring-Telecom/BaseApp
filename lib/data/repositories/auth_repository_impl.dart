import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final bool _useMock;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
    bool useMock = true,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource,
        _useMock = useMock;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    if (_useMock) {
      await Future.delayed(const Duration(seconds: 1));
      
      if (email == 'admin@test.com' && password == '123456') {
        const mockUser = UserModel(
          id: '1',
          name: 'Usuario Demo',
          email: 'admin@test.com',
          isActive: true,
        );
        await _localDataSource.cacheUser(mockUser);
        await _localDataSource.cacheToken('mock_token_123');
        return mockUser;
      } else {
        throw Exception('Credenciales inválidas');
      }
    }

    final user = await _remoteDataSource.login(
      email: email,
      password: password,
    );
    await _localDataSource.cacheUser(user);
    return user;
  }

  @override
  Future<void> logout() async {
    if (!_useMock) {
      await _remoteDataSource.logout();
    }
    await _localDataSource.clearCache();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return _localDataSource.getCachedUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _localDataSource.getToken();
    return token != null;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_useMock) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (currentPassword != '123456') {
        throw Exception('Contraseña actual incorrecta');
      }
      return;
    }

    await _remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
