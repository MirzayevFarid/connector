import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connector/main_container.dart';

import 'package:connector/models/job_model.dart';
import 'package:connector/models/profile_model.dart';
import 'package:connector/services/job_services.dart';
import 'package:flutter/material.dart';
import 'package:connector/common/colors.dart';
import 'package:connector/common/utils.dart';
import 'package:connector/common/texts.dart';
import 'package:connector/widgets/spacer.dart';
import 'package:connector/widgets/buttons/primary_button.dart';
import 'package:connector/widgets/buttons/secondary_button.dart';
import 'package:connector/utils/globals.dart';

class JobDetail extends StatefulWidget {
  final Job job;
  final String title;

  JobDetail({
    Key key,
    this.title = 'Job Detail',
    this.job,
  }) : super(key: key);

  @override
  _JobDetailState createState() => _JobDetailState();
}

class _JobDetailState extends State<JobDetail> {
  ScrollController scrollController;
  List<QueryDocumentSnapshot> profiles;
  int index;
  @override
  void initState() {
    super.initState();
    index = 0;
    loadData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ORColorStyles.main,
        body: SingleChildScrollView(
          child: Stack(children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 585,
              child: CustomPaint(
                painter: CurvePainter(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 130),
                    child: Container(
                        width: 120.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(widget
                                          .job.owner.profilePicture !=
                                      null
                                  ? widget.job.owner.profilePicture
                                  : "https://cdn.pixabay.com/photo/2013/07/12/16/27/network-150919_960_720.png"),
                            ))),
                  ),
                  CustomSpacer(space: 20),
                  Text(
                    widget.job.title,
                    style: ORTextStyles.title.copyWith(fontSize: 24),
                  ),
                  CustomSpacer(space: 10),
                  Text(
                    widget.job.owner.firstName +
                        " " +
                        widget.job.owner.lastName,
                    style: ORTextStyles.body,
                  ),
                  CustomSpacer(space: 10),
                  Text(
                    "\$${widget.job.payment.toInt().toString()} / Month",
                    style: ORTextStyles.info.copyWith(color: Colors.lightBlue),
                  ),
                  CustomSpacer(space: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Job Details",
                      style: ORTextStyles.title.copyWith(color: Colors.grey),
                    ),
                  ),
                  CustomSpacer(space: 5),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_city,
                          color: Colors.white38,
                        ),
                        CustomSpacer(
                          space: 5,
                          isVertical: false,
                        ),
                        Text(
                          widget.job.address,
                          style: ORTextStyles.userMainText,
                        ),
                      ],
                    ),
                  ),
                  CustomSpacer(space: 5),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(
                          Icons.date_range,
                          color: Colors.white38,
                        ),
                        CustomSpacer(
                          space: 5,
                          isVertical: false,
                        ),
                        Text(
                          widget.job.createdAt.day.toString() +
                              "/" +
                              widget.job.createdAt.month.toString() +
                              "/" +
                              widget.job.createdAt.year.toString(),
                          style: ORTextStyles.userMainText,
                        ),
                      ],
                    ),
                  ),
                  CustomSpacer(space: 5),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(
                          Icons.phone,
                          color: Colors.white38,
                        ),
                        CustomSpacer(
                          space: 5,
                          isVertical: false,
                        ),
                        Text(
                          widget.job.owner.phone,
                          style: ORTextStyles.userMainText,
                        ),
                      ],
                    ),
                  ),
                  CustomSpacer(space: 5),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(
                          Icons.email_outlined,
                          color: Colors.white38,
                        ),
                        CustomSpacer(
                          space: 5,
                          isVertical: false,
                        ),
                        Text(
                          widget.job.owner.email,
                          style: ORTextStyles.userMainText,
                        ),
                      ],
                    ),
                  ),
                  CustomSpacer(space: 20),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Job Description",
                      style: ORTextStyles.title.copyWith(color: Colors.grey),
                    ),
                  ),
                  CustomSpacer(space: 5),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.job.description,
                      style: ORTextStyles.body,
                    ),
                  ),
                  CustomSpacer(space: 20),
                  Divider(
                    color: Colors.grey,
                  ),
                  CustomSpacer(space: 20),
                  globalUserInfo.isCompany
                      ? Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Applicants",
                            style:
                                ORTextStyles.title.copyWith(color: Colors.grey),
                          ),
                        )
                      : Container(),
                  CustomSpacer(space: 20),
                  globalUserInfo.isCompany
                      ? widget.job.applicants.length == 0
                          ? Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "No Applicants...",
                                style: ORTextStyles.body,
                              ),
                            )
                          : Column(
                              children: widget.job.applicants.map((item) {
                                index++;
                                return Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Profile " + (index).toString(),
                                        style: ORTextStyles.title
                                            .copyWith(color: Colors.grey),
                                      ),
                                      CustomSpacer(
                                        space: 5,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.phone,
                                              color: Colors.white38,
                                            ),
                                            CustomSpacer(
                                              space: 5,
                                              isVertical: false,
                                            ),
                                            Text(
                                              item["phone"],
                                              style: ORTextStyles.body,
                                            ),
                                          ],
                                        ),
                                      ),
                                      CustomSpacer(
                                        space: 5,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.email,
                                              color: Colors.white38,
                                            ),
                                            CustomSpacer(
                                              space: 5,
                                              isVertical: false,
                                            ),
                                            Text(
                                              item["email"],
                                              style: ORTextStyles.body,
                                            ),
                                          ],
                                        ),
                                      ),
                                      CustomSpacer(
                                        space: 5,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              color: Colors.white38,
                                            ),
                                            CustomSpacer(
                                              space: 5,
                                              isVertical: false,
                                            ),
                                            Text(
                                              item["fullName"],
                                              style: ORTextStyles.body,
                                            ),
                                          ],
                                        ),
                                      ),
                                      CustomSpacer(
                                        space: 5,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.attach_money,
                                              color: Colors.white38,
                                            ),
                                            CustomSpacer(
                                              space: 5,
                                              isVertical: false,
                                            ),
                                            Text(
                                              "\$" +
                                                  item["payment"].toString() +
                                                  " / month",
                                              style: ORTextStyles.body,
                                            ),
                                          ],
                                        ),
                                      ),
                                      CustomSpacer(
                                        space: 5,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.location_city,
                                              color: Colors.white38,
                                            ),
                                            CustomSpacer(
                                              space: 5,
                                              isVertical: false,
                                            ),
                                            Text(
                                              item["address"],
                                              style: ORTextStyles.body,
                                            ),
                                          ],
                                        ),
                                      ),
                                      CustomSpacer(
                                        space: 5,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.info,
                                              color: Colors.white38,
                                            ),
                                            CustomSpacer(
                                              space: 5,
                                              isVertical: false,
                                            ),
                                            Expanded(
                                              child: Text(item["about"],
                                                  style: ORTextStyles.body,
                                                  textAlign: TextAlign.justify),
                                            ),
                                          ],
                                        ),
                                      ),
                                      CustomSpacer(
                                        space: 20,
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            )
                      : Container(),
                  CustomSpacer(space: 180),
                  Row(
                    children: [
                      SecondaryButton(
                        width: globalUserInfo.isCompany
                            ? screenUsableWidth(context) - 45
                            : screenUsableWidth(context) / 2 - 25,
                        text: "Go Back",
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      globalUserInfo.isCompany
                          ? Container()
                          : CustomSpacer(
                              space: 10,
                              isVertical: false,
                            ),
                      globalUserInfo.isCompany
                          ? Container()
                          : PrimaryButton(
                              width: screenUsableWidth(context) / 2 - 25,
                              child: Text(
                                "Apply",
                                style: ORTextStyles.darkButtonText,
                              ),
                              onPressed: () async {
                                await loadData();
                                print(profiles.length);
                                showDialog(
                                    context: context,
                                    builder: (_) {
                                      return MyDialog(
                                          profiles: profiles, job: widget.job);
                                    });
                              },
                            ),
                    ],
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    profiles?.clear();
    QuerySnapshot profilesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(globalUid)
        .collection("profiles")
        .orderBy('created_at', descending: true)
        .get();

    profiles = profilesSnapshot.docs;
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

class ProfileRectangle extends StatelessWidget {
  final String title;
  final String address;
  final String about;
  final double payment;
  final Function onTap;

  ProfileRectangle(
      {this.title, this.address, this.about, this.payment, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        height: 125,
        width: screenUsableWidth(context) - 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xFF363D4D),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: ORTextStyles.userMainText),
                Text(
                  "\$$payment / month",
                  style: ORTextStyles.userMainText
                      .copyWith(color: ORColorStyles.blue),
                ),
              ],
            ),
            CustomSpacer(space: 10),
            Text(address, style: ORTextStyles.clickableText),
            CustomSpacer(space: 20),
            Text(
              about,
              style: ORTextStyles.clickableText,
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            CustomSpacer(space: 20),
          ],
        ),
      ),
    );
  }
}

class MyDialog extends StatefulWidget {
  final List<QueryDocumentSnapshot> profiles;
  final Job job;

  const MyDialog({Key key, this.profiles, this.job}) : super(key: key);

  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  int _radioValue = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ORColorStyles.main,
      actions: [
        widget.profiles.length == 0
            ? PrimaryButton(
                onPressed: () {
                  Navigator.maybePop(context);
                  Navigator.of(context).pushAndRemoveUntil(
                    FadeRoute(
                      page: MainContainer(),
                      settings: RouteSettings(name: '/home'),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                text: "Go Home",
              )
            : Container(
                height: 100,
                width: screenUsableWidth(context),
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(children: [
                  Expanded(
                    child: SecondaryButton(
                      // width: screenUsableWidth(context) / 3,
                      onPressed: () {
                        Navigator.maybePop(context);
                      },
                      text: "Cancel",
                    ),
                  ),
                  CustomSpacer(
                    space: 20,
                    isVertical: false,
                  ),
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () {
                        submitProf(
                            widget.job,
                            ProfileModel.fromDocumentSnapshot(
                                widget.profiles[_radioValue].data()));
                        Navigator.maybePop(context);
                        Navigator.of(context).pushAndRemoveUntil(
                          FadeRoute(
                            page: MainContainer(),
                            settings: RouteSettings(name: '/home'),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      text: "Submit",
                    ),
                  ),
                ]),
              ),
      ],
      content: Container(
        color: ORColorStyles.main,
        padding: EdgeInsets.symmetric(vertical: 18),
        height: 600,
        width: screenUsableWidth(context),
        child: widget.profiles.length == 0
            ? Center(
                child: Text(
                "You don't have any profile. Please add profile.",
                style: ORTextStyles.body,
              ))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: widget.profiles.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: Container(
                      width: screenUsableWidth(context),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Radio(
                              activeColor: Colors.white,
                              value: index,
                              groupValue: _radioValue,
                              onChanged: (value) {
                                setState(() {
                                  _radioValue = value;
                                });
                              }),
                          ProfileRectangle(
                            title: widget.profiles[index]["title"],
                            address: widget.profiles[index]["address"],
                            about: widget.profiles[index]["title"] != null
                                ? widget.profiles[index]["title"]
                                : "",
                            payment: widget.profiles[index]["payment"],
                            onTap: () {
                              setState(() {
                                _radioValue = index;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void submitProf(Job job, ProfileModel profile) {
    try {
      addApplicant(job, profile);
    } catch (e) {
      print(e);
    }
  }
}
