import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
// import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class SideMenu extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu({super.key, required this.scaffoldKey});

  @override
  SideMenuState createState() => SideMenuState();
}

class SideMenuState extends ConsumerState<SideMenu> {
  int navDrawerIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 35;
    final textStyles = Theme.of(context).textTheme;
    final authState = ref.watch(authProvider);

    return NavigationDrawer(
        elevation: 1,
        selectedIndex: navDrawerIndex,
        onDestinationSelected: (value) {
          setState(() {
            navDrawerIndex = value;
          });

          // final menuItem = appMenuItems[value];
          // context.push( menuItem.link );
          widget.scaffoldKey.currentState?.closeDrawer();
        },
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, hasNotch ? 0 : 20, 16, 0),
            child: Text('Saludos',
              style: textStyles.titleSmall?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 16, 0),
            child: Text(
              'Usuario: ${authState.user!.name}',
              style: textStyles.titleSmall?.copyWith(fontSize: 16),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 16, 10),
            child: Text(
              authState.user!.email,
              style: textStyles.titleSmall?.copyWith(fontSize: 16),
            ),
          ),
          // const NavigationDrawerDestination(
          //     icon: Icon( Icons.home_outlined ),
          //     label: Text( 'Productos' ),
          // ),

          const Padding(
            padding: EdgeInsets.fromLTRB(28, 16, 28, 10),
            child: Divider(),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(28, 10, 16, 10),
            child: Text('Otras opciones'),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomFilledButton(
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                },
                text: 'Cerrar sesión'),
          ),
        ]);
  }
}
