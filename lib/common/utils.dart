import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_statusbar_text_color/flutter_statusbar_text_color.dart';
import 'dart:async';

double screenWidthPercent(double percent, BuildContext context) {
  return MediaQuery.of(context).size.width * percent / 100;
}

double screenHeightPercent(double percent, BuildContext context) {
  return MediaQuery.of(context).size.height * percent / 100;
}

double screenUsableHeight(BuildContext context) {
  var padding = MediaQuery.of(context).padding;
  return MediaQuery.of(context).size.height - padding.bottom - padding.top;
}

double screenUsableWidth(BuildContext context) {
  var padding = MediaQuery.of(context).padding;
  return MediaQuery.of(context).size.width - padding.right - padding.left;
}

String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}

String clearLineBreaksAndLimitString(String str) {
  return truncateWithEllipsis(
    180,
    str.replaceAll('\n', ' '),
  );
}

// Date time
String timeConverter(DateTime createdAt) {
  Duration timeDifference = DateTime.now().difference(createdAt);
  String timeToText;
  if (timeDifference.inDays > 365)
    timeToText = (timeDifference.inDays / 365).floor().toString() + " y";
  else if (timeDifference.inDays > 7)
    timeToText = (timeDifference.inDays / 7).floor().toString() + " W";
  else if (timeDifference.inDays > 0)
    timeToText = timeDifference.inDays.toString() + " d";
  else if (timeDifference.inHours > 0)
    timeToText = timeDifference.inHours.toString() + " h";
  else if (timeDifference.inMinutes > 0)
    timeToText = timeDifference.inMinutes.toString() + " m";
  else
    timeToText = timeDifference.inSeconds > 0
        ? timeDifference.inSeconds.toString() + " s"
        : "0 S";

  return timeToText;
}

Map<String, dynamic> statusBarRouteArguments(bool isLight) {
  return {
    'isRouteLight': isLight,
  };
}

class StatusBarTextRouteObserver extends NavigatorObserver {
  Timer _timer;
  final bool isRouteLight;

  StatusBarTextRouteObserver({
    this.isRouteLight = false,
  });

  _setStatusBarTextColor(Route route) {
    _timer?.cancel();

    _timer = Timer(Duration(milliseconds: 200), () async {
      try {
        var rl = route.settings.arguments != null
            ? (route.settings.arguments as Map)['isRouteLight']
            : false;

        await FlutterStatusbarTextColor.setTextColor(
          isRouteLight || rl
              ? FlutterStatusbarTextColor.dark
              : FlutterStatusbarTextColor.light,
        );
      } catch (_) {
        print('set status bar text color failed');
      }
    });
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    if (Platform.isIOS) {
      _setStatusBarTextColor(route);
    }
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    if (Platform.isIOS) {
      _setStatusBarTextColor(route);
    }
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  final RouteSettings settings;

  FadeRoute({this.page, this.settings})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
          settings: settings,
        );
}
