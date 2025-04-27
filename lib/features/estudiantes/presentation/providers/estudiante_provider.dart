import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/estudiantes/domain/entities/estudiante.dart';
import 'package:teslo_shop/features/estudiantes/domain/entities/subnota.dart';
import 'package:teslo_shop/features/estudiantes/domain/repositories/estudiante_repository.dart';
import 'package:teslo_shop/features/estudiantes/infrastructure/repositories/estudiante_repository.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_service_impl.dart';

//! 3
final estudianteProvider =
    StateNotifierProvider.autoDispose<EstudianteNotifier, EstudianteState>(
        (ref) {
  final estudianteRepository = EstudianteRepositoryImpl();
  final keyValueStorageService = KeyValueStorageServiceImpl();
  final authState = ref.watch(authProvider);

  return EstudianteNotifier(
      estudianteRepository: estudianteRepository,
      keyValueStorageService: keyValueStorageService,
      authState:
          authState); // Pasar el estado de autenticación al EstudianteNotifier
});

//! 2
class EstudianteNotifier extends StateNotifier<EstudianteState> {
  final EstudianteRepository estudianteRepository;
  final KeyValueStorageService keyValueStorageService;
  final AuthState authState; // Agregar esto

  EstudianteNotifier({
    required this.estudianteRepository,
    required this.keyValueStorageService,
    required this.authState, // Requerir el estado de autenticación
  }) : super(EstudianteState());

  Future<List<Estudiante>> getStudentsByTutor() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (authState.authStatus != AuthStatus.authenticated ||
        authState.user == null) {
      // No autenticado o no hay información de usuario
      return [];
    }

    // Si está autenticado, usar el token del usuario autenticado
    return await estudianteRepository.getStudentsByTutor(authState.user!.token);
  }

  Future<void> getEstudiante(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (authState.authStatus != AuthStatus.authenticated ||
        authState.user == null) {
      return;
    }

    var estudiante =
        await estudianteRepository.getStudentById(id, authState.user!.token);
    if (mounted) {
      state = EstudianteState(
          estudiante:
              estudiante); // Reiniciar el estado con solo el estudiante actual esto es clave!!!!
    }
  }

  Future<void> getSubnotas(String id) async {
    if (authState.authStatus != AuthStatus.authenticated ||
        authState.user == null) {
      // No autenticado o no hay información de usuario
      return;
    }
    await Future.delayed(const Duration(milliseconds: 500));
    var subnotas = await estudianteRepository.getLibretaByEstudianteId(
        id, authState.user!.token);
    if (mounted) {
      //forma original
      state = state.copyWith(subnotas: subnotas);
    }
  }

  Future<void> refreshStudents() async {
    if (authState.authStatus != AuthStatus.authenticated ||
        authState.user == null) {
      // No autenticado o no hay información de usuario
      return;
    }
    await Future.delayed(const Duration(milliseconds: 500));
    final students = await getStudentsByTutor();
    if (mounted) {
      state = state.copyWith(estudiantes: students);
    }
  }
}

//! 1
class EstudianteState {
  final Estudiante? estudiante; // Estado para un estudiante individual
  final List<Estudiante>? estudiantes;
  final List<Subnota>? subnotas;

  EstudianteState({this.estudiante, this.estudiantes, this.subnotas});

  EstudianteState copyWith({
    Estudiante? estudiante,
    List<Estudiante>? estudiantes,
    List<Subnota>? subnotas,
  }) {
    return EstudianteState(
        estudiante: estudiante ?? this.estudiante,
        estudiantes: estudiantes ?? this.estudiantes,
        subnotas: subnotas ?? this.subnotas);
  }
}
