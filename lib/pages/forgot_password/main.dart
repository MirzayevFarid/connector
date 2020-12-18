import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:connector/common/colors.dart';
import 'package:connector/common/texts.dart';
import 'package:connector/common/utils.dart';
import 'package:connector/common/validations.dart';
import 'package:connector/helpers/snackbar.dart';
import 'package:connector/helpers/statusbar_text_color.dart';
import 'package:connector/pages/login/main.dart';
import 'package:connector/widgets/Custom_app_bar.dart';
import 'package:connector/widgets/ensure_visible_when_focused.dart';
import 'package:connector/widgets/buttons/primary_button.dart';
import 'package:connector/widgets/focus_escape_wrapper.dart';
import 'package:connector/widgets/input.dart';
import 'package:connector/widgets/spacer.dart';

class ForgotPassword extends StatefulWidget {
  final String email;

  ForgotPassword({
    Key key,
    this.email,
  }) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  String email;
  TextEditingController emailController;
  bool isSent = false;

  void _requestFocus(node) {
    setState(() {
      FocusScope.of(context).requestFocus(node);
    });
  }

  void unFocus() {
    setState(() {
      FocusScope.of(context).unfocus();
    });
  }

  Future<void> _sendPass() async {
    if (_formKey.currentState.validate()) {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text)
          .then((value) => {
                setState(() {
                  isSent = true;
                }),
                SnackbarHelper.show(
                  type: SnackbarTypes.success,
                  context: context,
                  msg: "Code sent successfully",
                  duration: Duration(seconds: 3),
                )
              })
          .catchError((err) {
        // Displays an error message if there is no user with the provided email address
        SnackbarHelper.show(
          type: SnackbarTypes.error,
          context: context,
          msg: "Invalid email address",
          duration: Duration(seconds: 3),
        );
      });
    }
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

    emailController = TextEditingController(text: widget.email);

    emailController.addListener(() {
      email = emailController.text;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(title: "Forgot password", showLeading: false),
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
                      CustomSpacer(
                        space: 20,
                      ),
                      Image(
                        image: AssetImage("assets/images/Lock.png"),
                        width: double.infinity,
                      ),
                      CustomSpacer(
                        space: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          "Enter your email below to receive your password reset instructions",
                          textAlign: TextAlign.center,
                          style: ORTextStyles.info,
                        ),
                      ),
                      CustomSpacer(
                        space: 30,
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
                            _emailFocus.unfocus();
                          },
                          filled: true,
                        ),
                      ),
                      CustomSpacer(
                        space: 20,
                      ),
                      PrimaryButton(
                        child: Text(
                          isSent ? "Resend password" : "Send password",
                          style: ORTextStyles.darkButtonText,
                        ),
                        onPressed: () {
                          _sendPass();
                        },
                      ),
                      CustomSpacer(
                        space: 25,
                      ),
                      Container(
                        child: RichText(
                          text: TextSpan(
                            text: isSent
                                ? "Back to login"
                                : "I remember the password",
                            style: ORTextStyles.clickableText.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () =>
                                  Navigator.of(context).pushAndRemoveUntil(
                                    FadeRoute(
                                      page: LoginForm(
                                        email: emailController.text.trim() != ""
                                            ? emailController.text.trim()
                                            : null,
                                      ),
                                      settings: RouteSettings(name: '/login'),
                                    ),
                                    (Route<dynamic> route) => false,
                                  ),
                          ),
                        ),
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
