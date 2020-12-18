import 'package:connector/common/texts.dart';
import 'package:flutter/material.dart';
import 'package:connector/common/colors.dart';
import 'package:connector/common/utils.dart';
import 'package:connector/widgets/Custom_app_bar.dart';

class Explore extends StatefulWidget {
  final ScrollController scrollController;

  Explore({
    Key key,
    this.title = 'Explore',
    this.scrollController,
  }) : super(key: key);

  final String title;

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
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
      appBar: CustomAppBar(title: "Explore", showLeading: false),
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
