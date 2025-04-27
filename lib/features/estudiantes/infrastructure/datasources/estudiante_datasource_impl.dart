import 'package:dio/dio.dart';
import 'package:teslo_shop/config/constants/environment.dart';
import 'package:teslo_shop/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:teslo_shop/features/estudiantes/domain/domain.dart';
import 'package:teslo_shop/features/estudiantes/domain/entities/subnota.dart';
import 'package:teslo_shop/features/estudiantes/infrastructure/mappers/estudiante_mapper.dart';
import 'package:teslo_shop/features/estudiantes/infrastructure/mappers/libreta_mapper.dart';

class EstudianteDatasourceImpl extends EstudianteDatasource {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  @override
  Future<List<Estudiante>> getStudentsByTutor(String token) async {
    try {
      final response = await dio.get('/students/by_tutor',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      if (response.data['data'] == null) {
        throw Exception('No data available');
      }

      final List<dynamic> listaEstudiantesJson = response.data['data'];
      if (listaEstudiantesJson.isEmpty) {
        return [];
      }

      final List<Estudiante> listaEstudiantes =
          listaEstudiantesJson.map((estudianteJson) {
        return EstudianteMapper.estudianteJsonToEntity(estudianteJson);
      }).toList();

      return listaEstudiantes;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token incorrecto');
      }
      throw Exception('Error en la solicitud: ${e.message}');
    } catch (e) {
      throw Exception('Error al procesar los datos: ${e.toString()}');
    }
  }

  @override
  Future<Estudiante> getStudentById(String id, String token) async {
    try {
      final response = await dio.get(
        '/estudiante/$id', // Asegúrate de que la URL base termina sin '/'
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.data == null) {
        throw Exception('No data available');
      }

      if (response.statusCode == 200 && response.data['success'] == true) {
        // Usar el mapper para convertir los datos
        return EstudianteMapper.estudianteJsonToEntity(
            response.data['data'][0]);
      } else {
        throw Exception('Failed to load student data');
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token incorrecto');
      }
      throw Exception('Error en la solicitud: ${e.message}');
    } catch (e) {
      throw Exception('Error al procesar los datos: ${e.toString()}');
    }
  }

  @override
  Future<List<Subnota>> getLibretaByEstudianteId(
      String estudianteId, String token) async {
    try {
      final response = await dio.get(
        '/students/subnotas/$estudianteId', // Ensure the base URL ends without '/'
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.data == null || response.data['data'] == null) {
        throw Exception('No data available');
      }

      List<Subnota> subnotas = List<Subnota>.from(
          (response.data['data'] as List)
              .map((item) => LibretaMapper.estudianteJsonToEntity(item)));
      return subnotas;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw CustomError('Token incorrecto');
      }
      throw Exception('Error en la solicitud: ${e.message}');
    } catch (e) {
      throw Exception('Error al procesar los datos: ${e.toString()}');
    }
  }
}
