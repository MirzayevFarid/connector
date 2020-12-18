import 'package:connector/common/texts.dart';
import 'package:flutter/material.dart';
import 'package:connector/common/colors.dart';
import 'package:connector/common/utils.dart';
import 'package:connector/widgets/Custom_app_bar.dart';

class Notifications extends StatefulWidget {
  final ScrollController scrollController;

  Notifications({
    Key key,
    this.title = 'Notifications',
    this.scrollController,
  }) : super(key: key);

  final String title;

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    scrollController = widget.scrollController;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ORColorStyles.main,
      appBar: CustomAppBar(title: "Notifications", showLeading: false),
      body: Container(
        alignment: Alignment.center,
        child: Text(
          "Under Construction",
          style: ORTextStyles.body,
        ),
      ),
    );
  }
}
