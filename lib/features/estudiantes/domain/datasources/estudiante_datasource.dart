import 'package:teslo_shop/features/estudiantes/domain/entities/estudiante.dart';
import 'package:teslo_shop/features/estudiantes/domain/entities/subnota.dart';

abstract class EstudianteDatasource {
  Future<List<Estudiante>> getStudentsByTutor(String token);
  Future<Estudiante> getStudentById(String id, String token);
  Future<List<Subnota>> getLibretaByEstudianteId(String estudianteId, String token);
}
