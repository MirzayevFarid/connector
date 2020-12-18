import 'package:connector/pages/add_job/main.dart';
import 'package:connector/pages/job_detail/main.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:connector/common/constants.dart';
import 'package:connector/common/utils.dart';
import 'package:connector/helpers/snackbar.dart';
import 'package:connector/main_container.dart';
import 'package:connector/pages/forgot_password/main.dart';
import 'package:connector/pages/login/main.dart';
import 'package:connector/pages/selection/main.dart';
import 'package:connector/pages/sign_up/main.dart';
import 'package:connector/pages/splash/main.dart';
import 'package:connector/pages/user_main/main.dart';

class Routes {
  static GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();

  final routes = <String, WidgetBuilder>{};

  static onGenerateRoute(
    RouteSettings routeSettings, {
    Widget defaultScreen,
  }) {
    // ignore: non_constant_identifier_names
    var RN = routeSettings.name;

    final List<String> pathElements = RN.split('/');

    if (pathElements[0] != '') {
      return null;
    }

    /// general routes
    if (RN == '/home') {
      return MaterialPageRoute(
        builder: (BuildContext context) => MainContainer(),
        settings: RouteSettings(
          name: '/',
          arguments: {
            ...statusBarRouteArguments(false),
          },
        ),
      );
    } else if (RN == '/splash') {
      return MaterialPageRoute(
        builder: (BuildContext context) => SplashScreen(),
        settings: RouteSettings(
          name: RN,
          arguments: {
            ...statusBarRouteArguments(true),
          },
        ),
      );
    } else if (RN == '/selection') {
      return MaterialPageRoute(
        builder: (BuildContext context) => SelectionScreen(),
        settings: RouteSettings(
          name: RN,
          arguments: {
            ...statusBarRouteArguments(true),
          },
        ),
      );
    } else if (RN == '/login') {
      return MaterialPageRoute(
        builder: (BuildContext context) => LoginForm(),
        settings: RouteSettings(
          name: RN,
          arguments: {
            ...statusBarRouteArguments(true),
          },
        ),
      );
    } else if (RN == '/sign_up') {
      return MaterialPageRoute(
        builder: (BuildContext context) => SignUpForm(),
        settings: RouteSettings(
          name: RN,
          arguments: {
            ...statusBarRouteArguments(true),
          },
        ),
      );
    } else if (RN == '/forgot_password') {
      return MaterialPageRoute(
        builder: (BuildContext context) => ForgotPassword(),
        settings: RouteSettings(
          name: RN,
          arguments: {
            ...statusBarRouteArguments(true),
          },
        ),
      );
    } else if (RN == '/add_job') {
      return MaterialPageRoute(
        builder: (BuildContext context) => AddJob(),
        settings: RouteSettings(
          name: RN,
          arguments: {
            ...statusBarRouteArguments(true),
          },
        ),
      );
    } else if (pathElements[1] == Constants.NOTIFICATION_GENERIC_ERROR) {
      return buildNotification(
        SnackbarHelper.genericErrorBar(
          msg: pathElements[2],
        ),
      );

      /// default
    } else {
      return defaultScreen != null
          ? MaterialPageRoute(
              builder: (BuildContext context) => defaultScreen,
            )
          : print('not found');
    }
  }

  static FlushbarRoute buildNotification(Flushbar type) {
    return FlushbarRoute(
      flushbar: type,
      settings: RouteSettings(name: FLUSHBAR_ROUTE_NAME),
    );
  }
}
