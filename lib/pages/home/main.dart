import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connector/models/job_model.dart';
import 'package:connector/pages/job_detail/main.dart';
import 'package:connector/widgets/buttons/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:connector/common/colors.dart';
import 'package:connector/common/texts.dart';
import 'package:connector/widgets/focus_escape_wrapper.dart';
import 'package:connector/widgets/spacer.dart';
import 'package:connector/utils/globals.dart';
import 'package:connector/common/utils.dart';
import 'package:connector/common/colors.dart';
import 'package:connector/widgets/Custom_app_bar.dart';

class Home extends StatefulWidget {
  final ScrollController scrollController;

  Home({
    Key key,
    this.title = 'Home',
    this.scrollController,
  }) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<QueryDocumentSnapshot> jobs = [];
  bool isLoading = false;
  ScrollController scrollController;
  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
    });
    Timer(
      Duration(
        milliseconds: 100,
      ),
      () => loadProducts(),
    );
    isLoading = false;
    scrollController = widget.scrollController;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> loadProducts() async {
    print("run");
    setState(() {
      isLoading = true;
      jobs.clear();
    });
    QuerySnapshot jobsSnapshot = await FirebaseFirestore.instance
        .collection('jobs')
        .orderBy('created_at', descending: true)
        .get();
    setState(() {
      jobs = jobsSnapshot.docs;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: ORColorStyles.main,
        appBar: CustomAppBar(
          title: "Jobs",
        ),
        key: _scaffoldKey,
        body: isLoading
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            : RefreshIndicator(
                onRefresh: () => loadProducts(),
                child: jobs.length == 0
                    ? Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              globalUserInfo.isCompany
                                  ? "You don't have any active job post"
                                  : "There is not any job to show",
                              style: ORTextStyles.body,
                            ),
                            GestureDetector(
                              child: Text(
                                "Refresh",
                                style: ORTextStyles.body,
                              ),
                              onTap: () => loadProducts(),
                            )
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: jobs.length,
                        itemBuilder: (context, index) {
                          print(jobs);
                          return InfoRectangle(
                            title: jobs[index]["title"],
                            address: jobs[index]["address"],
                            description: jobs[index]["description"],
                            payment: jobs[index]["payment"],
                            onTap: () {
                              Navigator.of(context, rootNavigator: true).push(
                                FadeRoute(
                                  page: JobDetail(
                                    job: Job.fromDocumentSnapshot(
                                        jobs[index].data()),
                                  ),
                                  settings: RouteSettings(name: '/home'),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
      ),
    );
  }
}

class InfoRectangle extends StatelessWidget {
  final String title;
  final String address;
  final String description;
  final double payment;
  final Function onTap;

  InfoRectangle(
      {this.title, this.address, this.description, this.payment, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(20),
          height: 185,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(23.36)),
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
                description,
                style: ORTextStyles.clickableText,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              CustomSpacer(space: 20),
            ],
          ),
        ),
      ),
    );
  }
}
