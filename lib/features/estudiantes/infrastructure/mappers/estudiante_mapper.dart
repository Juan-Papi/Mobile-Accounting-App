import 'package:teslo_shop/features/estudiantes/domain/domain.dart';

class EstudianteMapper {
  static Estudiante estudianteJsonToEntity(Map<String, dynamic> json) {
    return Estudiante(
        id: json['id'],
        nombre: json['nombre'],
        apellido: json['apellido'],
        edad: json['edad']);
  }
}
