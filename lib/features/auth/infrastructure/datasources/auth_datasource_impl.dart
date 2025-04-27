import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/core/data/models/api_response_model.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/auth/check-status',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      final genericResponse = ApiResponse.fromJson(response.data);
      return UserMapper.fromJson(genericResponse.data);
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token incorrecto');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio
          .post('/auth/login', data: {'username': email, 'password': password});

      if (response.statusCode == 200) {
        // Assuming the status code for success is 200
        print(response.data); // To check the structure in debug
        return UserMapper.fromJson(response.data);
      } else {
        throw CustomError('Error de autenticación');
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales incorrectas');
      } else if (e.type == DioErrorType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      } else {
        throw CustomError('Error personalizado en auth_datasource_impl');
      }
    } catch (e) {
      throw Exception('Error general del sistema');
    }
  }
}
