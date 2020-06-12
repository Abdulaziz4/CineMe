import 'package:CineMe/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CineMe/constant.dart';

import "package:CineMe/providers/auth.dart";

enum AuthMode {
  Login,
  Signup,
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  Map<String, String> userInfo = {"email": "", "password": ""};
  AuthMode mode = AuthMode.Login;
  final passwordController = TextEditingController();
  bool _isLoading = false;
  AnimationController _controller;
  Animation<double> _fadeAnimation;
  Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 600,
      ),
    );
    // begin 0 which is transparent and end 1 which is fully visiable
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> sumbitForm(BuildContext context) async {
    // check validation..
    // true-> no errors , false-> error exist
    bool valid = _formKey.currentState.validate();
    if (!valid) {
      return;
    }
    // trigger on save..
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (mode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .signin(userInfo["email"], userInfo["password"]);
      } else if (mode == AuthMode.Signup) {
        await Provider.of<Auth>(context, listen: false)
            .signup(userInfo["email"], userInfo["password"]);
      }
    } on HttpException catch (error) {
      print("Http exception");
      var message = "Authentication Field!!";
      if (error.toString().contains("EMAIL_EXISTS")) {
        message = "The email is already in use.";
      } else if (error.toString().contains("TOO_MANY_ATTEMPTS_TRY_LATER")) {
        message = "Too many attempts try again later.";
      } else if (error.toString().contains("OPERATION_NOT_ALLOWED")) {
        message = "You are not allowed to preform this operation.";
      } else if (error.toString().contains("USER_DISABLED")) {
        message = "This account is disabled.";
      } else if (message.toString().contains("INVALID_PASSWORD")) {
        message = "Invalid password, Please try again.";
      } else if (error.toString().contains("EMAIL_NOT_FOUND")) {
        message = "Could not find a user with the email.";
      }
      _showErrorDialog(message);
    } catch (error) {
      _showErrorDialog("Authentication Field, Please try again later.");
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    setState(() {
      if (mode == AuthMode.Login) {
        mode = AuthMode.Signup;
        _controller.forward();
      } else {
        mode = AuthMode.Login;
        _controller.reverse();
      }
    });
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Something went wrong!!"),
        content: Text(errorMessage),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Okay"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 180,
        right: 20,
        left: 20,
      ),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            AnimatedContainer(
              duration: Duration(milliseconds: 600),
              curve: Curves.linear,
              height: mode == AuthMode.Login ? 180 : 280,
              child: SingleChildScrollView(
                child: Column(children: [
                  TextFormField(
                    style: TextStyle(color: kWhite),
                    cursorColor: Theme.of(context).accentColor,
                    decoration: InputDecoration(
                      hintText: "Email",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          kEmailIconPath,
                          width: 20,
                          height: 20,
                          fit: BoxFit.fill,
                        ),
                      ),

                      // when the field is focused
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kWhite,
                        ),
                      ),
                      // when the field is inactive
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kDeepPurple,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    // null -> no errors , text -> error text
                    validator: (value) {
                      // check errors condition
                      if (value.isEmpty) {
                        return "Please enter an email.";
                      } else if (!value.contains("@") ||
                          !value.contains(".com")) {
                        return "Please enter a valid email.";
                      }
                      // no errors
                      return null;
                    },
                    onSaved: (value) {
                      userInfo["email"] = value;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: TextStyle(color: kWhite),
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          kPasswordIconPath,
                          width: 20,
                          height: 20,
                          fit: BoxFit.fill,
                        ),
                      ),
                      // when the field is focused
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kWhite,
                        ),
                      ),
                      // when the field is inactive
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: kDeepPurple,
                        ),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter a password.";
                      } else if (value.length < 8) {
                        return "Password should be at least 8 characters";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      userInfo["password"] = value;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  if (mode == AuthMode.Signup)
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: "Confirm password",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Image.asset(
                                kPasswordIconPath,
                                width: 20,
                                height: 20,
                                fit: BoxFit.fill,
                              ),
                            ),
                            // when the field is focused
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: kWhite,
                              ),
                            ),
                            // when the field is inactive
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: kDeepPurple,
                              ),
                            ),
                          ),
                          obscureText: true,
                          validator: (value) {
                            print(value);
                            print(userInfo["password"]);
                            if (value.isEmpty) {
                              return "Please enter a password.";
                            } else if (value.length < 8) {
                              return "Password should be at least 8 characters";
                            } else if (passwordController.text != value) {
                              return "Password don't matched";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                ]),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40),
              child: RaisedButton(
                color: kDeepPurple,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 10,
                ),
                child: _isLoading
                    ? CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Image.asset(
                            kLockIconPath,
                            width: 30,
                            height: 30,
                          ),
                          Text(
                            mode == AuthMode.Login
                                ? "Secure Login"
                                : "Secure Signup",
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(fontSize: 20),
                          ),
                        ],
                      ),
                onPressed: () => sumbitForm(context),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    mode == AuthMode.Login
                        ? "Don't have an account?"
                        : "Have an account?",
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                          fontSize: 15,
                        ),
                  ),
                  FlatButton(
                    padding: const EdgeInsets.all(3),
                    onPressed: _switchAuthMode,
                    child: Text(
                      mode == AuthMode.Login ? "Signup Now!" : "Login insted!",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 15, color: Colors.blueAccent),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
