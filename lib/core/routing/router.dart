import 'package:go_router/go_router.dart';
import 'package:mediaflow/screen/navigator_sell.dart';
import 'package:mediaflow/screen/home_screen.dart';
import 'package:mediaflow/screen/loading_screen.dart';
import 'package:mediaflow/screen/video_list_screen.dart';
import 'package:mediaflow/screen/about_screen.dart';

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
      path: '/about',
      name: AboutScreen.routeName,
      builder: (context, state) => const AboutScreen(),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return NavigatorSell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: HomeScreen.routeName,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/downloads',
              name: VideoListScreen.routeName,
              builder: (context, state) => const VideoListScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
