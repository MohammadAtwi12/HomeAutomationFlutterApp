import 'package:flicky/features/devices/devices.dart';
import 'package:flicky/features/landing/home.page.dart';
import 'package:flicky/features/lighting/lighting.dart';
import 'package:flicky/features/security/security.dart';
import 'package:flicky/features/temperature/temperature.dart';
import 'package:flicky/helpers/utils.dart';
import 'package:go_router/go_router.dart';
import 'package:flicky/features/intro/loading.page.dart';
import 'package:flicky/features/intro/splash.page.dart';
import 'package:flicky/features/login_signup/signuppage.dart';
import 'package:flicky/features/login_signup/loginpage.dart';


class AppRoutes {
  static final router = GoRouter(
      routerNeglect: true,
      initialLocation: SplashPage.route,
      navigatorKey: Utils.mainNav,
      routes: [
        GoRoute(
          parentNavigatorKey: Utils.mainNav,
          path: SplashPage.route,
          builder: (context, state) {
            return const SplashPage();
          },
        ),
        GoRoute(
          parentNavigatorKey: Utils.mainNav,
          path: LoadingPage.route,
          builder: (context, state) {
            return const LoadingPage();
          },
        ),
        GoRoute(
          parentNavigatorKey: Utils.mainNav,
          path: LoginPage.route,
          builder: (context, state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          parentNavigatorKey: Utils.mainNav,
          path: SignupPage.route,
          builder: (context, state) {
            return const SignupPage();
          },
        ),
        GoRoute(
          parentNavigatorKey: Utils.mainNav,
          path: HomePage.route,
          builder: (context, state) {
            return const HomePage();
          },
        ),
        GoRoute(
          parentNavigatorKey: Utils.mainNav,
          path: LightingPage.route,
          builder: (context, state) {
            return const LightingPage();
          },
        ),
        GoRoute(
          parentNavigatorKey: Utils.mainNav,
          path: TemperaturePage.route,
          builder: (context, state) {
            return const TemperaturePage();
          },
        ),
        GoRoute(
          parentNavigatorKey: Utils.mainNav,
          path: DevicesPage.route,
          builder: (context, state) {
            return const DevicesPage();
          },
        ),
        GoRoute(
          parentNavigatorKey: Utils.mainNav,
          path: SecurityPage.route,
          builder: (context, state) {
            return const SecurityPage();
          },
        ),
      ]);
}
