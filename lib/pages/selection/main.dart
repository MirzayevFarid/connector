import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:connector/common/colors.dart';
import 'package:connector/common/utils.dart';
import 'package:connector/widgets/buttons/secondary_button.dart';
import 'package:connector/widgets/spacer.dart';

class SelectionScreen extends StatefulWidget {
  @override
  _SelectionScreenState createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ORColorStyles.main,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                26, ((screenUsableHeight(context) / 2) - 200), 25, 0),
            child: Column(
              children: [
                Image(
                  image: AssetImage(
                    'assets/images/Logo.png',
                  ),
                  width: 200,
                ),
                CustomSpacer(space: 50),
                SecondaryButton(
                  text: "Log In",
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, "/login");
                  },
                ),
                CustomSpacer(space: 18),
                SecondaryButton(
                  text: "Sign Up",
                  isTransparent: true,
                  onPressed: () {
                    Navigator.pushNamed(context, "/sign_up");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
