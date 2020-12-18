import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';

// commons
import 'package:connector/common/constants.dart';

class ConnectivityNotifier extends StatelessWidget {
  final Widget child;

  ConnectivityNotifier({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return OfflineBuilder(
          connectivityBuilder: (BuildContext context,
              ConnectivityResult connectivity, Widget child) {
            final bool connected = connectivity != ConnectivityResult.none;
            return Stack(
              fit: StackFit.expand,
              children: [
                child,
                Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 0.0,
                  child: SafeArea(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color: Color(0xFFEE4400),
                      height: !connected ? Constants.NAV_BAR_HEIGHT : 0,
                      child: !connected
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "No internet connection",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              height: 0,
                            ),
                    ),
                  ),
                ),
              ],
            );
          },
          child: child,
        );
      },
    );
  }
}
