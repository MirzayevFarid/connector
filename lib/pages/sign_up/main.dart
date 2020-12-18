import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:connector/common/colors.dart';
import 'package:connector/common/texts.dart';
import 'package:connector/common/utils.dart';
import 'package:connector/common/validations.dart';
import 'package:connector/helpers/snackbar.dart';
import 'package:connector/models/user_model.dart';
import 'package:connector/pages/login/main.dart';
import 'package:connector/services/firebase_users.dart';
import 'package:connector/widgets/Custom_app_bar.dart';
import 'package:connector/widgets/ensure_visible_when_focused.dart';
import 'package:connector/widgets/buttons/primary_button.dart';
import 'package:connector/widgets/focus_escape_wrapper.dart';
import 'package:connector/widgets/input.dart';
import 'package:connector/widgets/spacer.dart';
import 'package:connector/common/colors.dart';

class SignUpForm extends StatefulWidget {
  final String email;

  SignUpForm({
    Key key,
    this.email,
  }) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  String name;
  String surname;
  String password;
  String confirmPassword;
  String email;
  String phone;
  bool isCompany = false;
  bool isSigningUp = false;
  bool passwordVisible;
  bool confirmPasswordVisible;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _surnameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  TextEditingController nameController;
  TextEditingController surnameController;
  TextEditingController passwordController;
  TextEditingController confirmPasswordController;
  TextEditingController emailController;
  TextEditingController phoneController;

  UserModel userModel;
  User user;
  FirebaseAuth _firebaseAuth;
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

  Future<void> _signUp() async {
    if (_formKey.currentState.validate()) {
      try {
        userModel.firstName = nameController.text.trim();
        userModel.lastName = surnameController.text.trim();
        userModel.email = emailController.text.trim();
        userModel.password = passwordController.text;
        userModel.phone = phoneController.text.trim();
        userModel.username =
            '${userModel.firstName.toString()} ${userModel.lastName[0].toString()}.';
        userModel.joinedAt = DateTime.now();
        userModel.modifiedAt = DateTime.now();
        print(isCompany);
        userModel.isCompany = isCompany;
        print(userModel.isCompany);
        UserCredential userCredential =
            await _firebaseAuth.createUserWithEmailAndPassword(
          email: userModel.email,
          password: userModel.password,
        );

        user = userCredential.user;
        userModel.uid = user.uid;
        user.sendEmailVerification();

        SnackbarHelper.show(
          type: SnackbarTypes.success,
          context: context,
          msg: "Signed up successfully",
          duration: Duration(seconds: 3),
        );
        print("Signed up successfully");
        setState(() {
          isSigningUp = true;
        });

        UserModel usm =
            await usersDb.createUser(userModel.uid, userModel.toPostJson());

        Navigator.of(context).pushNamed("/login",
            arguments: email = emailController.text.trim());
      } catch (e) {
        print(e);
        SnackbarHelper.show(
          type: SnackbarTypes.error,
          context: context,
          msg: "There is an account with this email address.",
          duration: Duration(seconds: 3),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    userModel = UserModel();
    _firebaseAuth = FirebaseAuth.instance;
    usersDb = FirebaseUserService();

    passwordVisible = false;
    confirmPasswordVisible = false;
    nameController = TextEditingController(text: "");
    surnameController = TextEditingController(text: "");
    passwordController = TextEditingController(text: "");
    confirmPasswordController = TextEditingController(text: "");
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: "");

    nameController.addListener(() {
      name = nameController.text;
    });
    surnameController.addListener(() {
      surname = surnameController.text;
    });
    passwordController.addListener(() {
      password = passwordController.text;
    });
    confirmPasswordController.addListener(() {
      confirmPassword = confirmPasswordController.text;
    });
    emailController.addListener(() {
      email = emailController.text;
    });
    phoneController.addListener(() {
      phone = phoneController.text;
    });
  }

  int _radioValue = 0;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          isCompany = false;
          break;
        case 1:
          isCompany = true;
          break;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameFocus.dispose();
    _surnameFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(title: "Create Account", showLeading: false),
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
                            "Sign up with email ",
                            style: ORTextStyles.info,
                          )),
                      EnsureVisibleWhenFocused(
                          focusNode: _nameFocus,
                          child: Input(
                            hintText: "Name",
                            controller: nameController,
                            validator: validateRequired,
                            textInputAction: TextInputAction.next,
                            focusNode: _nameFocus,
                            onTap: () => _requestFocus(_nameFocus),
                            onFieldSubmitted: (val) {
                              _fieldFocusChange(
                                  context, _nameFocus, _surnameFocus);
                            },
                          )),
                      CustomSpacer(space: 20),
                      EnsureVisibleWhenFocused(
                          focusNode: _surnameFocus,
                          child: Input(
                            hintText: "Surname",
                            controller: surnameController,
                            validator: validateRequired,
                            textInputAction: TextInputAction.next,
                            focusNode: _surnameFocus,
                            onTap: () => _requestFocus(_surnameFocus),
                            onFieldSubmitted: (val) {
                              _fieldFocusChange(
                                  context, _surnameFocus, _emailFocus);
                            },
                          )),
                      CustomSpacer(space: 20),
                      EnsureVisibleWhenFocused(
                          focusNode: _emailFocus,
                          child: Input(
                            hintText: "Email Address",
                            controller: emailController,
                            validator: validateEmail,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            focusNode: _emailFocus,
                            onTap: () => _requestFocus(_emailFocus),
                            onFieldSubmitted: (val) {
                              _fieldFocusChange(
                                  context, _emailFocus, _phoneFocus);
                            },
                          )),
                      CustomSpacer(space: 20),
                      EnsureVisibleWhenFocused(
                          focusNode: _phoneFocus,
                          child: Input(
                              hintText: "Phone Number",
                              controller: phoneController,
                              // TODO: PHONE VALIDATION REQUIRED
                              validator: validateRequired,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              focusNode: _phoneFocus,
                              onTap: () => _requestFocus(_phoneFocus),
                              onFieldSubmitted: (val) {
                                _fieldFocusChange(
                                    context, _phoneFocus, _passwordFocus);
                              })),
                      CustomSpacer(space: 20),
                      EnsureVisibleWhenFocused(
                          focusNode: _passwordFocus,
                          child: Input(
                            hintText: "Password",
                            controller: passwordController,
                            validator: validatePassword,
                            autofocus: false,
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
                            textInputAction: TextInputAction.next,
                            focusNode: _passwordFocus,
                            onTap: () => _requestFocus(_passwordFocus),
                            onFieldSubmitted: (val) {
                              _fieldFocusChange(context, _passwordFocus,
                                  _confirmPasswordFocus);
                            },
                            filled: true,
                          )),
                      CustomSpacer(space: 20),
                      EnsureVisibleWhenFocused(
                          focusNode: _confirmPasswordFocus,
                          child: Input(
                            hintText: "Confirm Password",
                            controller: confirmPasswordController,
                            validator: (value) => validatePasswordConfirmation(
                                passwordController.text.trim(), value.trim()),
                            autofocus: false,
                            obscureText: confirmPasswordVisible ? false : true,
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
                                  confirmPasswordVisible =
                                      !confirmPasswordVisible;
                                });
                              },
                            ),
                            textInputAction: TextInputAction.done,
                            focusNode: _confirmPasswordFocus,
                            onTap: () => _requestFocus(_confirmPasswordFocus),
                            onFieldSubmitted: (val) {
                              _confirmPasswordFocus.unfocus();
                            },
                            filled: true,
                          )),
                      CustomSpacer(space: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Radio(
                            value: 0,
                            activeColor: ORColorStyles.blue,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                          new Text("Job Seeker", style: ORTextStyles.body),
                          new Radio(
                            value: 1,
                            activeColor: ORColorStyles.blue,
                            groupValue: _radioValue,
                            onChanged: _handleRadioValueChange,
                          ),
                          new Text("Company", style: ORTextStyles.body),
                        ],
                      ),
                      CustomSpacer(space: 20),
                      PrimaryButton(
                        child: Text(
                          "Sign Up",
                          style: ORTextStyles.darkButtonText,
                        ),
                        onPressed: () {
                          _confirmPasswordFocus.unfocus();
                          _signUp();
                        },
                      ),
                      CustomSpacer(space: 20),
                      RichText(
                          text: TextSpan(
                              style: ORTextStyles.clickableText,
                              children: <TextSpan>[
                            TextSpan(text: "Already have an account? "),
                            TextSpan(
                              text: "Log in",
                              style: ORTextStyles.clickableText
                                  .copyWith(color: ORColorStyles.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () =>
                                    Navigator.of(context).pushAndRemoveUntil(
                                      FadeRoute(
                                        page: LoginForm(
                                          email:
                                              emailController.text.trim() != ""
                                                  ? emailController.text.trim()
                                                  : null,
                                        ),
                                        settings: RouteSettings(name: '/login'),
                                      ),
                                      (Route<dynamic> route) => false,
                                    ),
                            ),
                          ]))
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
