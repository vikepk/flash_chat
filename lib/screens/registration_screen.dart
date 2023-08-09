import 'package:flash/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash/components/components.dart';
import 'package:flash/constants/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "/reg";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool load = false;
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: OverlayLoaderWithAppIcon(
        isLoading: load,
        appIcon: Image.asset("images/logo.png"),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
              Colors.orange.shade900,
              Colors.orange.shade100,
              Colors.orange.shade600
            ]),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Container(
                    height: 200.0,
                    child: Hero(
                        tag: "photo", child: Image.asset('images/logo.png')),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                    textAlign: TextAlign.center,
                    obscureText: true,
                    style: TextStyle(color: Colors.black),
                    onChanged: (value) {
                      //Do something with the user input.
                      password = value;
                    },
                    decoration: kTextFieldDecoration.copyWith(
                        hintText: 'Enter your password')),
                SizedBox(
                  height: 24.0,
                ),
                RoundButton(
                    color: Colors.blueAccent,
                    title: 'Register',
                    onPress: () async {
                      setState(() {
                        load = true;
                      });
                      try {
                        final newuser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newuser != null) {
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
      ),
    );
  }
}
