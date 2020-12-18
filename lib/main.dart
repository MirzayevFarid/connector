import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// common
import 'package:connector/common/theme.dart';
import 'package:connector/common/utils.dart';
import 'package:connector/utils/globals.dart';

// providers
import 'package:provider/provider.dart';
import 'package:connector/providers/navigator.dart';

// routes
import 'package:connector/routes/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    globalUid = prefs.getString('uid');
    String userInfoString = prefs.getString('userInfo');
    globalUserInfo = userInfoString != null
        ? UserModel.fromJson(json.decode(userInfoString))
        : null;

    String initialRoute = '/splash';
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
        .then((_) {
      runApp(ConnectorApp(initialRoute: initialRoute));
    });
  });
}

class ConnectorApp extends StatefulWidget {
  final String initialRoute;

  ConnectorApp({Key key, this.initialRoute}) : super(key: key);

  @override
  _ConnectorAppState createState() => _ConnectorAppState();
}

class _ConnectorAppState extends State<ConnectorApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NavigatorProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Connector',
        theme: appTheme,
        initialRoute: widget.initialRoute,
        navigatorKey: Routes.navigatorKey,
        navigatorObservers: [StatusBarTextRouteObserver()],
        routes: Routes().routes,
        onGenerateRoute: (RouteSettings routeSettings) =>
            Routes.onGenerateRoute(routeSettings),
      ),
    );
  }
}
