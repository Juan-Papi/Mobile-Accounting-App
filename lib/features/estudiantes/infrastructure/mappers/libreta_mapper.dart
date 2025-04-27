import 'package:teslo_shop/features/estudiantes/domain/entities/subnota.dart';

class LibretaMapper {
  static Subnota estudianteJsonToEntity(Map<String, dynamic> json) {
    return Subnota(
        id: json['id'] as int,
        subnota: json['nota'] as double, // Changed from 'subnota' to 'nota'
        numero: (json['numero'] as num).toDouble(),
        curso: json['curso_nombre'] as String,
        modalidad: json['modalidad'] as String,
        materia: json['materia_nombre'] as String,
        paralelo: json['curso_paralelo'] as String,
        year: json['year'].toString(),
        estudiante: json['estudiante_nombre'] as String,
        promedio: (json['nota_promedio'] as num).toDouble().toString());
  }
}
