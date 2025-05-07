import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/app_api_constants.dart';
import 'package:teslo_shop/config/network/api_client.dart';
import 'package:teslo_shop/config/network/errors/api_exception.dart';

class ApiClientImpl implements ApiClient {
  final Dio _dio;

  ApiClientImpl({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  @override
  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, dynamic>? queryParams, Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParams,
        data: data,
      );
      return response.data as Map<String, dynamic>;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, dynamic>? data, bool isMultipart = false}) async {
    try {
      final options = Options(
        contentType: isMultipart ? 'multipart/form-data' : 'application/json',
      );
      final response = await _dio.post(
        endpoint,
        data: data,
        options: options,
      );
      return response.data as Map<String, dynamic>;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> put(String endpoint,
      {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
      );
      return response.data as Map<String, dynamic>;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> delete(String endpoint,
      {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
      );
      return response.data as Map<String, dynamic>;
    } on DioError catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _handleError(DioError error) {
    if (error.response != null) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        throw ApiException(
          message: data['message'] ?? 'Error desconocido',
          statusCode: error.response?.statusCode ?? 500,
          errors: data['errors'] as Map<String, dynamic>?,
        );
      }
      throw ApiException(
        message: data?.toString() ?? 'Error desconocido',
        statusCode: error.response?.statusCode ?? 500,
      );
    } else {
      throw ApiException(
        message: error.message ?? 'Error de conexión',
        statusCode: 0,
      );
    }
  }
}
