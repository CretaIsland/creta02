// ignore_for_file: depend_on_referenced_packages

import 'package:routemaster/routemaster.dart';
import '../login_page.dart';
import '../register_page.dart';
import '../main_page.dart';
//import '../../common/util/logger.dart';

abstract class AppRoutes {
  static const String main = '/main';
  static const String studio = '/studio';
  static const String login = '/login';
  static const String register = '/register';
}

final routesLoggedOut = RouteMap(
  onUnknownRoute: (_) => const Redirect(AppRoutes.login),
  routes: {
    AppRoutes.login: (_) => const TransitionPage(
          child: LoginPage(),
          pushTransition: PageTransition.fadeUpwards,
        ),
    AppRoutes.register: (_) => const TransitionPage(
          child: RegisterPage(),
          pushTransition: PageTransition.fadeUpwards,
        ),
    AppRoutes.main: (_) => const TransitionPage(child: MainPage()),
  },
);

final routesLoggedIn = RouteMap(
  onUnknownRoute: (_) => const Redirect(AppRoutes.main),
  routes: {
    AppRoutes.main: (_) => const TransitionPage(child: MainPage()),
  },
);
