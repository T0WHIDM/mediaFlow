import 'package:go_router/go_router.dart';
import 'package:mediaflow/screen/about_screen.dart';
import 'package:mediaflow/screen/dash_board_screen.dart';
import 'package:mediaflow/screen/loading_screen.dart';

final appGlobalRouter = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: LoadingScreen.routeName,
      builder: (context, state) => const LoadingScreen(),
    ),
    GoRoute(
      path: '/dash_board_screen',
      name: DashBoardScreen.routeName,
      builder: (context, state) => const DashBoardScreen(),
    ),
    GoRoute(
      path: '/about_screen',
      name: AboutScreen.routeName,
      builder: (context, state) => const AboutScreen(),
    ),
  ],
);
