import 'package:flutter/material.dart';

class FocusEscape extends StatelessWidget {
  final Widget child;
  final BuildContext ctx;

  const FocusEscape({
    Key key,
    @required this.child,
    @required this.ctx,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(ctx);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: child,
    );
  }
}
