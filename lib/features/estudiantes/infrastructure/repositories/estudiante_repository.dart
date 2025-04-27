import 'package:teslo_shop/features/estudiantes/domain/domain.dart';
import 'package:teslo_shop/features/estudiantes/domain/entities/subnota.dart';
import 'package:teslo_shop/features/estudiantes/infrastructure/datasources/estudiante_datasource_impl.dart';

class EstudianteRepositoryImpl extends EstudianteRepository {
  final EstudianteDatasource datasource;

  EstudianteRepositoryImpl({EstudianteDatasource? datasource})
      : datasource = datasource ?? EstudianteDatasourceImpl();

  @override
  Future<List<Estudiante>> getStudentsByTutor(String token) {
    return datasource.getStudentsByTutor(token);
  }

  @override
  Future<Estudiante> getStudentById(String id, String token) {
    return datasource.getStudentById(id, token);
  }

  @override
  Future<List<Subnota>> getLibretaByEstudianteId(
      String estudianteId, String token) {
    return datasource.getLibretaByEstudianteId(estudianteId, token);
  }
}
