import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/auth_screen.dart';
import '../../features/dashboard/presentation/home_dashboard_screen.dart';
import '../../features/dashboard/presentation/home_shell.dart';
import '../../features/dashboard/presentation/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/plans/presentation/plans_screen.dart';
import '../../features/products/presentation/product_detail_screen.dart';
import '../../features/products/presentation/product_webview_screen.dart';
import '../../features/products/presentation/products_screen.dart';
import '../../features/profile/presentation/legal_document_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/trackers/presentation/progress_screen.dart';
import '../providers.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final Provider<GoRouter> appRouterProvider = Provider<GoRouter>((Ref ref) {
  final _RouterRefreshListenable refreshListenable = _RouterRefreshListenable();
  ref.onDispose(refreshListenable.dispose);
  ref.listen<AsyncValue<AppState>>(appControllerProvider, (previous, next) {
    refreshListenable.refresh();
  });

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    refreshListenable: refreshListenable,
    initialLocation: '/splash',
    redirect: (BuildContext context, GoRouterState state) {
      final AsyncValue<AppState> appState = ref.read(appControllerProvider);
      final AppState? data = appState.asData?.value;
      final bool isLoading = appState.isLoading && data == null;
      final String path = state.matchedLocation;
      final bool isLegalRoute = path.startsWith('/legal/');

      if (isLoading) {
        return path == '/splash' ? null : '/splash';
      }

      if (data == null) {
        return path == '/splash' ? null : '/splash';
      }

      if (isLegalRoute) {
        return null;
      }

      if (!data.session.onboardingComplete) {
        return path == '/onboarding' ? null : '/onboarding';
      }

      if (!data.session.isAuthenticated) {
        return path == '/auth' ? null : '/auth';
      }

      if (path == '/splash' || path == '/onboarding' || path == '/auth') {
        return '/home';
      }

      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: '/splash',
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (BuildContext context, GoRouterState state) =>
            const AuthScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder:
            (
              BuildContext context,
              GoRouterState state,
              StatefulNavigationShell navigationShell,
            ) {
              return HomeShell(navigationShell: navigationShell);
            },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/home',
                builder: (BuildContext context, GoRouterState state) =>
                    const HomeDashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/progress',
                builder: (BuildContext context, GoRouterState state) =>
                    const ProgressScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/plans',
                builder: (BuildContext context, GoRouterState state) =>
                    const PlansScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/products',
                builder: (BuildContext context, GoRouterState state) =>
                    const ProductsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/profile',
                builder: (BuildContext context, GoRouterState state) =>
                    const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/product/:productId',
        builder: (BuildContext context, GoRouterState state) {
          return ProductDetailScreen(
            productId: state.pathParameters['productId']!,
          );
        },
      ),
      GoRoute(
        path: '/browser',
        builder: (BuildContext context, GoRouterState state) {
          return ProductWebviewScreen(
            title: state.uri.queryParameters['title'] ?? 'Продукт',
            url: state.uri.queryParameters['url'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/legal/:document',
        builder: (BuildContext context, GoRouterState state) {
          return LegalDocumentScreen(
            documentKey: state.pathParameters['document']!,
          );
        },
      ),
    ],
  );
});

class _RouterRefreshListenable extends ChangeNotifier {
  void refresh() => notifyListeners();
}
