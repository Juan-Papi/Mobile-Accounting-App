import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/estudiantes/presentation/providers/estudiante_provider.dart';
import 'package:teslo_shop/features/estudiantes/presentation/views/estudiante/libreta_view.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class LibretaScreen extends ConsumerStatefulWidget {
  static const name = 'libreta-screen';
  final String estudianteId;

  const LibretaScreen({Key? key, required this.estudianteId}) : super(key: key);

  @override
  LibretaScreenState createState() => LibretaScreenState();
}

class LibretaScreenState extends ConsumerState<LibretaScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(estudianteProvider.notifier).getEstudiante(widget.estudianteId);
    ref.read(estudianteProvider.notifier).getSubnotas(widget.estudianteId);
  }

  @override
  Widget build(BuildContext context) {
    // Asegurar que el estudiante se carga al iniciar el widget

    // Escuchar los cambios en el estudiante
    final estudianteState = ref.watch(estudianteProvider);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        drawer: SideMenu(scaffoldKey: scaffoldKey),
        appBar: AppBar(
          title: Row(
            children: [
              const Text('Libreta'),
              const SizedBox(width: 20),
              IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_outlined))
            ],
          ),
        ),
        body: estudianteState.estudiante != null
            ? LibretaView(
                estudianteId: estudianteState.estudiante!.id.toString(),
                estudianteState: estudianteState,
              )
            : const Center(child: Text('No hay datos disponibles.')));
  }
}
