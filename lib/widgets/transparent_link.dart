import 'package:flutter/material.dart';

class TransparentLink extends StatelessWidget {
  final Function onTap;
  final Widget child;

  const TransparentLink({
    Key key,
    @required this.onTap,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: child,
    );
  }
}
