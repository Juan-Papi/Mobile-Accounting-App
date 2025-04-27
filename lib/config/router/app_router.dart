import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/auth.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/estudiantes/estudiantes.dart';
import 'package:teslo_shop/features/estudiantes/presentation/screens/libreta_screen.dart';
import 'package:teslo_shop/features/estudiantes/presentation/screens/tipo_nota_screen.dart';

import 'app_router_notifier.dart';

final goRouterProvider = Provider((ref) {
  final goRouterNotifier = ref.read(goRouterNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: goRouterNotifier,
    routes: [
      ///* Primera pantalla
      GoRoute(
        path: '/splash',
        builder: (context, state) => const CheckAuthStatusScreen(),
      ),

      ///* Auth Routes
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      ///* Product Routes
      GoRoute(
        path: '/',
        builder: (context, state) => const EstudiantesScreen(),
      ),
      GoRoute(
        path: '/tipo-nota/:estudianteId',
        name: TipoNotaScreen.name,
        builder: (context, state) {
          final estudianteId = state.params['estudianteId'] ?? 'no-id';

          return TipoNotaScreen(estudianteId: estudianteId);
        },
      ),
      GoRoute(
        path: '/tipo-nota/libreta/:estudianteId',
        name: LibretaScreen.name,
        builder: (context, state) {
          final estudianteId = state.params['estudianteId'] ?? 'no-id';

          return LibretaScreen(estudianteId: estudianteId);
        },
      ),
    ],
    redirect: (context, state) {
      final isGoingTo = state.subloc;
      final authStatus = goRouterNotifier.authStatus;

      if (isGoingTo == '/splash' && authStatus == AuthStatus.checking)
        return null;

      if (authStatus == AuthStatus.notAuthenticated) {
        if (isGoingTo == '/login' || isGoingTo == '/register') return null;

        return '/login';
      }

      if (authStatus == AuthStatus.authenticated) {
        if (isGoingTo == '/login' ||
            isGoingTo == '/register' ||
            isGoingTo == '/splash') {
          return '/';
        }
      }

      return null;
    },
  );
});
