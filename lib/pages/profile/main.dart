import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:connector/common/colors.dart';
import 'package:connector/common/utils.dart';
import 'package:connector/widgets/Custom_app_bar.dart';
import 'package:connector/widgets/buttons/primary_button.dart';
import 'package:connector/utils/globals.dart';
import 'package:connector/pages/selection/main.dart';

class Profile extends StatefulWidget {
  final ScrollController scrollController;

  Profile({
    Key key,
    this.title = 'Profile',
    this.scrollController,
  }) : super(key: key);

  final String title;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
      appBar: CustomAppBar(title: "Profile", showLeading: false),
      body: Container(
        color: ORColorStyles.main,
        height: screenUsableHeight(context),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: PrimaryButton(
              text: "Sign Out",
              onPressed: () {
                globalUserInfo = null;
                globalFirebaseUser = null;
                globalUid = null;
                FirebaseAuth.instance.signOut();

                Navigator.of(context, rootNavigator: true).push(
                  FadeRoute(
                    page: SelectionScreen(),
                    settings: RouteSettings(name: '/selection'),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
