import 'dart:async';
import 'dart:convert';

import 'package:connector/models/job_model.dart';
import 'package:connector/services/job_services.dart';
import 'package:flutter/material.dart';
import 'package:connector/common/colors.dart';
import 'package:connector/common/texts.dart';
import 'package:connector/common/validations.dart';
import 'package:connector/helpers/snackbar.dart';
import 'package:connector/helpers/statusbar_text_color.dart';
import 'package:connector/models/user_model.dart';
import 'package:connector/widgets/Custom_app_bar.dart';
import 'package:connector/widgets/ensure_visible_when_focused.dart';
import 'package:connector/widgets/buttons/primary_button.dart';
import 'package:connector/widgets/buttons/secondary_button.dart';
import 'package:connector/widgets/focus_escape_wrapper.dart';
import 'package:connector/widgets/input.dart';
import 'package:connector/widgets/spacer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main_container.dart';

class AddJob extends StatefulWidget {
  @override
  _AddJobState createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _paymentFocus = FocusNode();
  String title;
  String description;
  String address;
  String payment;

  TextEditingController _titleController;
  TextEditingController _descriptionController;
  TextEditingController _addressController;
  TextEditingController _paymentController;
  Job job = Job();

  void _requestFocus(node) {
    setState(() {
      FocusScope.of(context).requestFocus(node);
    });
  }

  void _fieldFocusChange(context, currentNode, nextFocus) {
    currentNode.unfocus();
    setState(() {
      FocusScope.of(context).requestFocus(nextFocus);
    });
  }

  void unFocus() {
    setState(() {
      FocusScope.of(context).unfocus();
    });
  }

  Future<void> _addJob() async {
    try {
      if (_formKey.currentState.validate()) {
        await addJob(await _formJob());
        SnackbarHelper.show(
          type: SnackbarTypes.success,
          context: context,
          msg: "Job created successfully",
          duration: Duration(seconds: 3),
        );
        Navigator.pop(context);
      }
      Timer(Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    } catch (e) {
      print(e);
      SnackbarHelper.show(
        type: SnackbarTypes.error,
        context: context,
        msg: "Problem Occurred",
        duration: Duration(seconds: 3),
      );
    }
  }

  Future<Job> _formJob() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserModel owner = UserModel.fromJson(json.decode(prefs.get('userInfo')));
    job.owner = owner;
    job.createdAt = DateTime.now();
    job.isActive = false;
    job.reviewCount = 0;
    job.favoriteCount = 0;
    job.applicants = <Map<dynamic, dynamic>>[];
    job.title = title;
    job.description = description;
    job.payment = double.parse(payment);
    job.address = address;
    job.isActive = true;

    return job;
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      Future.delayed(
        Duration(milliseconds: 200),
        () => StatusbarTextHelper.changeColor(isDark: true),
      );
    });

    _titleController = TextEditingController(text: "");
    _descriptionController = TextEditingController(text: "");
    _addressController = TextEditingController(text: "");
    _paymentController = TextEditingController(text: "");

    _titleController.addListener(() {
      title = _titleController.text;
    });

    _descriptionController.addListener(() {
      description = _descriptionController.text;
    });

    _addressController.addListener(() {
      address = _addressController.text;
    });

    _paymentController.addListener(() {
      payment = _paymentController.text;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _addressFocus.dispose();
    _paymentFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(title: "Add Job", showLeading: false),
        backgroundColor: ORColorStyles.main,
        body: FocusEscape(
          ctx: context,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      EnsureVisibleWhenFocused(
                        focusNode: _titleFocus,
                        child: Input(
                          hintText: "Job Title",
                          controller: _titleController,
                          validator: validateRequired,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          focusNode: _titleFocus,
                          onTap: () => _requestFocus(_titleFocus),
                          onFieldSubmitted: (val) {
                            _fieldFocusChange(
                                context, _titleFocus, _descriptionFocus);
                          },
                          filled: true,
                        ),
                      ),
                      CustomSpacer(
                        space: 20,
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: _descriptionFocus,
                        child: Input(
                          hintText: "Job Description",
                          maxLines: 6,
                          controller: _descriptionController,
                          validator: validateRequired,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          focusNode: _descriptionFocus,
                          onTap: () => _requestFocus(_descriptionFocus),
                          onFieldSubmitted: (val) {
                            _fieldFocusChange(
                                context, _descriptionFocus, _addressFocus);
                          },
                          filled: true,
                        ),
                      ),
                      CustomSpacer(
                        space: 20,
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: _addressFocus,
                        child: Input(
                          hintText: "Job Address",
                          maxLines: 2,
                          controller: _addressController,
                          validator: validateRequired,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          focusNode: _addressFocus,
                          onTap: () => _requestFocus(_addressFocus),
                          onFieldSubmitted: (val) {
                            _fieldFocusChange(
                                context, _addressFocus, _paymentFocus);
                          },
                          filled: true,
                        ),
                      ),
                      CustomSpacer(
                        space: 20,
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: _paymentFocus,
                        child: Input(
                          hintText: "Job Payment",
                          controller: _paymentController,
                          validator: validateRequired,
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                          focusNode: _paymentFocus,
                          onTap: () => _requestFocus(_paymentFocus),
                          onFieldSubmitted: (val) {
                            _paymentFocus.dispose();
                          },
                          filled: true,
                        ),
                      ),
                      CustomSpacer(
                        space: 20,
                      ),
                      PrimaryButton(
                        child: Text(
                          "Add Job",
                          style: ORTextStyles.darkButtonText,
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _addJob();
                        },
                      ),
                      CustomSpacer(
                        space: 20,
                      ),
                      SecondaryButton(
                        child: Text(
                          "Cancel",
                          style: ORTextStyles.lightButtonText,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
