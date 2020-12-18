import 'dart:async';
import 'package:connector/main_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:connector/common/colors.dart';
import 'package:connector/common/utils.dart';
import 'package:connector/pages/selection/main.dart';
import 'package:connector/utils/globals.dart';
import 'package:connector/pages/home/main.dart';
import 'package:connector/pages/home/main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();

    if (globalUserInfo != null && mounted) {
      setState(() {
        isSignedIn = true;
      });
    }

    Timer(
      Duration(milliseconds: 2000),
      () async {
        try {
          isSignedIn
              ? Navigator.of(context).pushAndRemoveUntil(
                  FadeRoute(
                    page: MainContainer(),
                    settings: RouteSettings(name: '/home'),
                  ),
                  (Route<dynamic> route) => false,
                )
              : await Navigator.of(context).pushAndRemoveUntil(
                  FadeRoute(
                    page: SelectionScreen(),
                    settings: RouteSettings(
                      name: '/selection',
                      arguments: {
                        ...statusBarRouteArguments(true),
                      },
                    ),
                  ),
                  (Route<dynamic> route) => false,
                );
        } catch (e) {
          print(e);

          isSignedIn
              ? Navigator.of(context).pushAndRemoveUntil(
                  FadeRoute(
                    page: MainContainer(),
                    settings: RouteSettings(name: '/home'),
                  ),
                  (Route<dynamic> route) => false,
                )
              : await Navigator.of(context).pushAndRemoveUntil(
                  FadeRoute(
                    page: SelectionScreen(),
                    settings: RouteSettings(
                      name: '/selection',
                      arguments: {
                        ...statusBarRouteArguments(true),
                      },
                    ),
                  ),
                  (Route<dynamic> route) => false,
                );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ORColorStyles.main,
      body: Center(
        child: Image(
          image: AssetImage(
            'assets/images/Logo.png',
          ),
          width: 200,
        ),
      ),
    );
  }
}
