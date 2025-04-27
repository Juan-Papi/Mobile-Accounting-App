import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/estudiantes/domain/domain.dart';
import 'package:teslo_shop/features/estudiantes/estudiantes.dart';
import 'package:teslo_shop/features/estudiantes/presentation/providers/estudiante_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class EstudiantesScreen extends ConsumerStatefulWidget {
  const EstudiantesScreen({super.key});

  @override
  EstudiantesScreenState createState() => EstudiantesScreenState();
}

class EstudiantesScreenState extends ConsumerState<EstudiantesScreen> {
  late Future<List<Estudiante>> futureEstudiantes;

  @override
  void initState() {
    super.initState();
    futureEstudiantes = loadStudents();
  }

  Future<List<Estudiante>> loadStudents() {
    // Esta función carga los estudiantes y se llama en initState y durante el refresh
    return ref.read(estudianteProvider.notifier).getStudentsByTutor();
  }

  Future<void> _refresh() async {
    setState(() {
      futureEstudiantes = loadStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final authState = ref.watch(authProvider);
    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: Text('${authState.user!.name}'),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: FutureBuilder<List<Estudiante>>(
          future: futureEstudiantes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return _EstudiantesView(estudiantes: snapshot.data!);
            } else {
              return const Text('No hay estudiantes disponibles.');
            }
          },
        ),
      ),
    );
  }
}

class _EstudiantesView extends StatelessWidget {
  final List<Estudiante> estudiantes;

  const _EstudiantesView({required this.estudiantes});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(35.0, 0.0, 0.0, 15.0),
              child: Text('Seleccione un estudiante:',
                  style: textStyles.titleSmall),
            ),
          ),
          ...estudiantes.map(
            (estudiante) => CardType3(
              nombre: '${estudiante.nombre} ${estudiante.apellido}',
              edad: estudiante.edad,
              estudianteId: estudiante.id.toString(),
            ),
          ),
        ],
      ),
    );
  }
}
