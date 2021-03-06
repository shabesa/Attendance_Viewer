import 'package:attendance_viewer/components/rounded_button.dart';
import 'package:attendance_viewer/screens/data_screen.dart';
import 'package:flutter/material.dart';
import 'package:attendance_viewer/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unnecessary_import
import 'package:flutter/services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:attendance_viewer/screens/about_screen.dart';

String _errorMesg;

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  String email;
  String password;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your Email',
                ),
                onChanged: (value) {
                  email = value;
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter Your Password',
                ),
                onChanged: (value) {
                  password = value;
                },
              ),
              SizedBox(
                height: 24,
              ),
              RoundedButton(
                title: 'Log In',
                color: Colors.lightBlueAccent,
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (user != null) {
                      Navigator.pushNamed(context, DataScreen.id);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'wrong-password') {
                      setState(() {
                        _errorMesg = 'Wrong Password';
                      });
                    } else if (e.code == 'invalid-email') {
                      setState(() {
                        _errorMesg = 'Invalid Email';
                      });
                    } else if (e.code == "user-not-found") {
                      setState(() {
                        _errorMesg = 'User Not Found';
                      });
                    } else if (e.code == "too-many-requests") {
                      setState(() {
                        _errorMesg =
                            'Requests blocked for this account due to incorrect attempts. Try again later';
                      });
                    }
                    print(e);
                    setState(() {
                      showSpinner = false;
                    });
                    Fluttertoast.showToast(
                      msg: _errorMesg,
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                    );
                  }
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.info_outline),
          onPressed: () {
            Navigator.pushNamed(context, AboutScreen.id);
          },
        ),
      ),
    );
  }
}
