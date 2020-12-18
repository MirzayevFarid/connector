import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:connector/common/colors.dart';
import 'package:connector/common/texts.dart';
import 'package:connector/common/utils.dart';
import 'package:connector/common/validations.dart';
import 'package:connector/helpers/snackbar.dart';
import 'package:connector/helpers/statusbar_text_color.dart';
import 'package:connector/models/user_model.dart';
import 'package:connector/pages/forgot_password/main.dart';
import 'package:connector/pages/sign_up/main.dart';
import 'package:connector/services/firebase_users.dart';
import 'package:connector/utils/globals.dart';
import 'package:connector/widgets/Custom_app_bar.dart';
import 'package:connector/widgets/ensure_visible_when_focused.dart';
import 'package:connector/widgets/buttons/primary_button.dart';
import 'package:connector/widgets/buttons/secondary_button.dart';
import 'package:connector/widgets/focus_escape_wrapper.dart';
import 'package:connector/widgets/input.dart';
import 'package:connector/widgets/spacer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main_container.dart';

class LoginForm extends StatefulWidget {
  final String email;

  LoginForm({
    Key key,
    this.email,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  String email;
  String password;
  bool isSigningIn = false;
  bool passwordVisible;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  TextEditingController emailController;
  TextEditingController passwordController;
  FirebaseUserService usersDb;

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

  Future setPrefs(String uid, UserModel userModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    globalUid = uid;
    globalUserInfo = userModel;
    await prefs.setString('uid', uid);
    await prefs.setString('userInfo', json.encode(userModel.toJson()));
  }

  Future<void> _signIn() async {
    try {
      if (_formKey.currentState.validate()) {
        setState(() {
          isSigningIn = true;
        });

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        User user = userCredential.user;

        if (user.emailVerified) {
          String uid = user?.uid ?? '';
          Map<String, dynamic> res = await usersDb.getUser(id: uid);

          UserModel userModel = UserModel.fromDocumentSnapshot(res);
          setPrefs(uid, userModel);

          Navigator.of(context).pushAndRemoveUntil(
            FadeRoute(
              page: MainContainer(),
              settings: RouteSettings(name: '/home'),
            ),
            (Route<dynamic> route) => false,
          );
        } else {
          SnackbarHelper.show(
            type: SnackbarTypes.warning,
            context: context,
            msg: "Verify your email",
            duration: Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      print(e);
      SnackbarHelper.show(
        type: SnackbarTypes.error,
        context: context,
        msg: "Account not found",
        duration: Duration(seconds: 3),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    usersDb = FirebaseUserService();

    Future.microtask(() async {
      Future.delayed(
        Duration(milliseconds: 200),
        () => StatusbarTextHelper.changeColor(isDark: true),
      );
    });

    passwordVisible = false;

    emailController = TextEditingController(text: widget.email);
    passwordController = TextEditingController(text: "");

    emailController.addListener(() {
      email = emailController.text;
    });

    passwordController.addListener(() {
      password = passwordController.text;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(title: "Log in", showLeading: false),
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
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Log in with email ",
                          style: ORTextStyles.info,
                        ),
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: _emailFocus,
                        child: Input(
                          hintText: "Your Email",
                          controller: emailController,
                          validator: validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          focusNode: _emailFocus,
                          onTap: () => _requestFocus(_emailFocus),
                          onFieldSubmitted: (val) {
                            _fieldFocusChange(
                                context, _emailFocus, _passwordFocus);
                          },
                          filled: true,
                        ),
                      ),
                      CustomSpacer(
                        space: 20,
                      ),
                      EnsureVisibleWhenFocused(
                        focusNode: _passwordFocus,
                        child: Input(
                          hintText: "Password",
                          controller: passwordController,
                          validator: validatePassword,
                          autofocus: widget.email != null ? true : false,
                          obscureText: passwordVisible ? false : true,
                          suffixIcon: IconButton(
                            padding: EdgeInsets.all(16),
                            iconSize: 20,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: Icon(
                              passwordVisible
                                  ? MdiIcons.eyeOutline
                                  : MdiIcons.eyeOffOutline,
                              size: 20,
                              color: ORColorStyles.input_icon_color,
                            ),
                            onPressed: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                          ),
                          textInputAction: TextInputAction.done,
                          focusNode: _passwordFocus,
                          onTap: () => _requestFocus(_passwordFocus),
                          onFieldSubmitted: (val) {
                            _passwordFocus.unfocus();
                            _signIn();
                          },
                          filled: true,
                        ),
                      ),
                      CustomSpacer(
                        space: 20,
                      ),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: RichText(
                          text: TextSpan(
                            text: "Forgot password?",
                            style: ORTextStyles.clickableText,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () =>
                                  Navigator.of(context).pushAndRemoveUntil(
                                    FadeRoute(
                                      page: ForgotPassword(
                                        email: emailController.text.trim() != ""
                                            ? emailController.text.trim()
                                            : null,
                                      ),
                                      settings: RouteSettings(
                                          name: '/forgot_password'),
                                    ),
                                    (Route<dynamic> route) => false,
                                  ),
                          ),
                        ),
                      ),
                      CustomSpacer(
                        space: 20,
                      ),
                      PrimaryButton(
                        child: Text(
                          "Log in",
                          style: ORTextStyles.darkButtonText,
                        ),
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          _signIn();
                        },
                      ),
                      CustomSpacer(
                        space: 80,
                      ),
                      Text(
                        "Don’t have an account?",
                        style: ORTextStyles.info,
                      ),
                      CustomSpacer(
                        space: 20,
                      ),
                      SecondaryButton(
                        child: Text(
                          "Sign up",
                          style: ORTextStyles.lightButtonText,
                        ),
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            FadeRoute(
                              page: SignUpForm(
                                email: emailController.text.trim() != ""
                                    ? emailController.text.trim()
                                    : null,
                              ),
                              settings: RouteSettings(name: '/sign_up'),
                            ),
                            (Route<dynamic> route) => false,
                          );
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
