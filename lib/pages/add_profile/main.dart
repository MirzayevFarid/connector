import 'dart:async';
import 'dart:convert';

import 'package:connector/models/profile_model.dart';
import 'package:connector/services/job_services.dart';
import 'package:flutter/material.dart';
import 'package:connector/common/colors.dart';
import 'package:connector/common/texts.dart';

import 'package:connector/common/validations.dart';
import 'package:connector/helpers/snackbar.dart';
import 'package:connector/helpers/statusbar_text_color.dart';
import 'package:connector/utils/globals.dart';
import 'package:connector/widgets/Custom_app_bar.dart';
import 'package:connector/widgets/ensure_visible_when_focused.dart';
import 'package:connector/widgets/buttons/primary_button.dart';
import 'package:connector/widgets/buttons/secondary_button.dart';
import 'package:connector/widgets/focus_escape_wrapper.dart';
import 'package:connector/widgets/input.dart';
import 'package:connector/widgets/spacer.dart';

class AddProfile extends StatefulWidget {
  @override
  _AddProfileState createState() => _AddProfileState();
}

class _AddProfileState extends State<AddProfile> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _aboutFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _paymentFocus = FocusNode();
  String title;
  String about;
  String address;
  String payment;

  TextEditingController _titleController;
  TextEditingController _aboutController;
  TextEditingController _addressController;
  TextEditingController _paymentController;
  ProfileModel profile = ProfileModel();

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

  Future<void> _addProfile() async {
    try {
      if (_formKey.currentState.validate()) {
        await addProfile(await _formProfile());
        SnackbarHelper.show(
          type: SnackbarTypes.success,
          context: context,
          msg: "Profile created successfully",
          duration: Duration(seconds: 3),
        );
        Timer(Duration(seconds: 3), () {
          Navigator.pop(context);
        });
      }
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

  Future<ProfileModel> _formProfile() async {
    profile.createdAt = DateTime.now();
    profile.phone = globalUserInfo.phone;
    profile.email = globalUserInfo.email;
    profile.fullName = globalUserInfo.firstName + " " + globalUserInfo.lastName;
    profile.title = title;
    profile.about = about;
    profile.payment = double.parse(payment);
    profile.address = address;
    return profile;
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
    _aboutController = TextEditingController(text: "");
    _addressController = TextEditingController(text: "");
    _paymentController = TextEditingController(text: "");

    _titleController.addListener(() {
      title = _titleController.text.trim();
    });

    _aboutController.addListener(() {
      about = _aboutController.text.trim();
    });

    _addressController.addListener(() {
      address = _addressController.text.trim();
    });

    _paymentController.addListener(() {
      payment = _paymentController.text.trim();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _titleFocus.dispose();
    _aboutFocus.dispose();
    _addressFocus.dispose();
    _paymentFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: CustomAppBar(title: "Add Profile", showLeading: false),
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
                            hintText: "Profile Title",
                            controller: _titleController,
                            validator: validateRequired,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            focusNode: _titleFocus,
                            onTap: () => _requestFocus(_titleFocus),
                            onFieldSubmitted: (val) {
                              _fieldFocusChange(
                                  context, _titleFocus, _aboutFocus);
                            },
                            filled: true,
                          ),
                        ),
                        CustomSpacer(
                          space: 20,
                        ),
                        EnsureVisibleWhenFocused(
                          focusNode: _aboutFocus,
                          child: Input(
                            hintText: "About You",
                            maxLines: 6,
                            controller: _aboutController,
                            validator: validateRequired,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            focusNode: _aboutFocus,
                            onTap: () => _requestFocus(_aboutFocus),
                            onFieldSubmitted: (val) {
                              _fieldFocusChange(
                                  context, _aboutFocus, _addressFocus);
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
                            hintText: "Your Address",
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
                            hintText: "Expected Payment",
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
                            "Add Profile",
                            style: ORTextStyles.darkButtonText,
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            _addProfile();
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
      ),
    );
  }
}
