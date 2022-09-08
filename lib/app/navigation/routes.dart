// ignore_for_file: depend_on_referenced_packages, equal_keys_in_map

import '../database_example_page.dart';
import '../function_example_page.dart';
import 'package:routemaster/routemaster.dart';
import '../intro_page.dart';
import '../login_page.dart';
import '../register_page.dart';
import '../main_page.dart';
//import '../../common/util/logger.dart';

abstract class AppRoutes {
  static const String main = '/main';
  static const String databaseExample = '/databaseExample';
  static const String functionExample = '/functionExample';
  static const String studio = '/studio';
  static const String login = '/login';
  static const String intro = '/intro';
  static const String register = '/register';
}

final routesLoggedOut = RouteMap(
  onUnknownRoute: (_) => const Redirect(AppRoutes.intro),
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
    AppRoutes.databaseExample: (_) => TransitionPage(
            child: DatabaseExamplePage(
          openDrawer: () {},
        )),
    AppRoutes.functionExample: (_) => TransitionPage(
            child: FunctionExamplePage(
          openDrawer: () {},
        )),
    AppRoutes.intro: (_) => const TransitionPage(child: IntroPage()),
  },
);

final routesLoggedIn = RouteMap(
  onUnknownRoute: (_) => const Redirect(AppRoutes.main),
  routes: {
    AppRoutes.main: (_) => const TransitionPage(child: MainPage()),
  },
);
