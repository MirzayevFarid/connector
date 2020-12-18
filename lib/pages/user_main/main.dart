import "package:flutter/material.dart";
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:connector/common/colors.dart';
import 'package:connector/common/texts.dart';
import 'package:connector/widgets/focus_escape_wrapper.dart';
import 'package:connector/widgets/spacer.dart';

class UserMainScreen extends StatefulWidget {
  @override
  _UserMainScreenState createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // TODO: Fill UserMainScreen with User's values once possible
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: ORColorStyles.main,
        body: FocusEscape(
          ctx: context,
          child: Stack(
            children: [
              Container(
                width: 400,
                height: 585,
                child: CustomPaint(
                  painter: CurvePainter(),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CustomSpacer(space: 130),
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(
                          "https://pbs.twimg.com/media/EERruCgXYAENFPK.jpg"),
                    ),
                  ),
                  CustomSpacer(space: 8.75),
                  Text("Welcome", style: ORTextStyles.body),
                  CustomSpacer(space: 5),
                  Text(
                    "Todd Bonzalez",
                    style:
                        ORTextStyles.body.copyWith(fontWeight: FontWeight.bold),
                  ),
                  CustomSpacer(space: 35),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InfoRectangle(
                        header: "Total distance",
                        icon: MdiIcons.mapMarkerDistance,
                        value: "178.6 KM",
                      ),
                      CustomSpacer(
                        space: 32,
                        isVertical: false,
                      ),
                      InfoRectangle(
                        header: "Average speed",
                        icon: MdiIcons.speedometer,
                        value: "45 Km/h",
                      ),
                    ],
                  ),
                  CustomSpacer(
                    space: 25,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InfoRectangle(
                        header: "Total time",
                        icon: MdiIcons.clockTimeFourOutline,
                        value: "15 hrs",
                      ),
                      CustomSpacer(
                        space: 32,
                        isVertical: false,
                      ),
                      InfoRectangle(
                        header: "Waiting time",
                        icon: MdiIcons.clockTimeFourOutline,
                        value: "3 hrs",
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoRectangle extends StatelessWidget {
  final String header;
  final IconData icon;
  final String value;

  InfoRectangle({this.header, this.icon, this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 152.31,
      height: 127.08,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(23.36)),
        color: Color(0xFF363D4D),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(header, style: ORTextStyles.userMainText),
            CustomSpacer(space: 13.7),
            Icon(icon, size: 27.0, color: ORColorStyles.mdiIcon_gray),
            CustomSpacer(space: 13.7),
            Text(
              value,
              style:
                  ORTextStyles.userMainText.copyWith(color: ORColorStyles.blue),
            ),
          ],
        ),
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = ORColorStyles.sliver_gray;
    paint.style = PaintingStyle.fill; // Change this to fill

    var path = Path();

    path.moveTo(0, size.height * 0.25);
    path.quadraticBezierTo(
        size.width / 2, size.height / 2, size.width, size.height * 0.25);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
