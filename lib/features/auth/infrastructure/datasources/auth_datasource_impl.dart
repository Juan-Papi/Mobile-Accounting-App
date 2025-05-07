import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/config/data/models/api_response_model.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';

class AuthDataSourceImpl extends AuthDataSource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/check-status',
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
          .post('/login', data: {'email': email, 'password': password});

      // Si llegamos aquí, obtuvimos una respuesta 2xx exitosa
      final genericResponse = ApiResponse.fromJson(response.data);

      //Ambos caminos si es que es status code 200
      //solo que entra al else si success es false que es error de negocio
      if (genericResponse.success) {
        return UserMapper.fromJson(genericResponse.data);
      } else {
        final errorDetail = genericResponse.error ?? '';
        throw CustomError(
            '${genericResponse.message}${errorDetail.isNotEmpty ? ': $errorDetail' : ''}');
      }
    } on DioError catch (e) {
      // Imprime información detallada para depuración
      print('DioError type: ${e.type}');
      print('DioError message: ${e.message}');
      print('Response status: ${e.response?.statusCode}');
      print('Response data: ${e.response?.data}');

      // Para errores de servidor (incluidos 500)
      if (e.response != null) {
        // Verifica el formato de la respuesta
        if (e.response!.data is Map<String, dynamic>) {
          Map<String, dynamic> errorData = e.response!.data;

          // Verifica si contiene los campos que esperamos
          if (errorData.containsKey('success') &&
              errorData.containsKey('message')) {
            final errorMsg =
                errorData['message'] as String? ?? 'Error del servidor';
            final errorDetail = errorData['error'] as String? ?? '';

            throw CustomError(
                '$errorMsg${errorDetail.isNotEmpty ? ': $errorDetail' : ''}');
          }
        }

        // Si no pudimos extraer el formato esperado
        throw CustomError('Error del servidor: ${e.response?.statusCode}');
      } else if (e.type == DioErrorType.connectionTimeout) {
        throw CustomError('Revisar conexión a internet');
      } else {
        throw CustomError(
            'Error de conexión: No se recibieron datos del servidor, ${e.message},Error personalizado en auth_datasource_impl');
      }
    } catch (e) {
      if (e is CustomError) throw e;
      throw CustomError('Error general del sistema: ${e.toString()}');
    }
  }
}
