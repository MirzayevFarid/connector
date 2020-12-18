import 'package:flutter/material.dart';
import 'package:connector/common/texts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key key,
    this.title,
    this.actions = const [],
    this.showLeading = true,
    this.bottom,
  }) : super(key: key);

  final String title;
  final List<Widget> actions;
  final bool showLeading;
  final PreferredSizeWidget bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      title: title != null
          ? Text(
              title,
              style: ORTextStyles.appBarTitle,
            )
          : Text(""),
      actions: actions,
      elevation: 0,
      centerTitle: true,
      leading: showLeading && Navigator.canPop(context)
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () => Navigator.maybePop(context),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              iconSize: 24,
              tooltip: 'Back',
            )
          : Container(),
      bottom: bottom != null ? bottom : null,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(45 + (bottom?.preferredSize?.height ?? 0.0));
}
