import 'package:flash/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash/components/components.dart';
import 'package:flash/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

class LoginScreen extends StatefulWidget {
  static String id = "/login";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool load = false;
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: OverlayLoaderWithAppIcon(
        appIconSize: 70,
        isLoading: load,
        appIcon: Image.asset("images/logo.png"),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Container(
                  height: 200.0,
                  child:
                      Hero(tag: 'photo', child: Image.asset('images/logo.png')),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    email = value;
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email')),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: "Enter your password ")),
              SizedBox(
                height: 24.0,
              ),
              RoundButton(
                  color: Colors.lightBlueAccent,
                  title: 'Log In',
                  onPress: () async {
                    setState(() {
                      load = true;
                    });
                    try {
                      final login = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      if (login != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                      setState(() {
                        load = false;
                      });
                    } catch (e) {
                      print(e);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
