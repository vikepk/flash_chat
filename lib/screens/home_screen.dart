import "package:flutter/material.dart";
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash/screens/registration_screen.dart';
import 'package:flash/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:overlay_loader_with_app_icon/overlay_loader_with_app_icon.dart';

class Firstpage extends StatefulWidget {
  const Firstpage({super.key});
  static const String id = "/home_screen";

  @override
  State<Firstpage> createState() => _FirstpageState();
}

class _FirstpageState extends State<Firstpage>
    with SingleTickerProviderStateMixin {
  TextEditingController demail = TextEditingController();
  TextEditingController dpass = TextEditingController();
  bool load = false;
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(seconds: 1), vsync: this, upperBound: 80);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
      //print(animation.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayLoaderWithAppIcon(
      appIconSize: 70,
      isLoading: load,
      appIcon: Image.asset("images/logo.png"),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
              Colors.orange.shade900,
              Colors.orange.shade100,
              Colors.orange.shade600
            ]),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
              ),
              Row(
                children: [
                  Hero(
                    tag: 'photo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 70,
                    ),
                  ),
                  AnimatedTextKit(
                    //isRepeatingAnimation: true,
                    // pause: const Duration(seconds: 15),
                    animatedTexts: [
                      TypewriterAnimatedText('Flash Chat',
                          textStyle: TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.white)),
                    ],
                    onTap: () {
                      print("Tap Event");
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Welcome Back!",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(30.0),
                    child: SingleChildScrollView(
                      child: Column(children: [
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(225, 95, 27, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey),
                                  ),
                                ),
                                child: TextField(
                                  controller: demail,
                                  onChanged: (value) {
                                    email = value;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    border: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextField(
                                  controller: dpass,
                                  obscureText: true,
                                  onChanged: (value) {
                                    password = value;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(color: Colors.grey),
                                    focusedBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Text(
                          "Forgot Password?",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              load = true;
                            });
                            try {
                              final login =
                                  await _auth.signInWithEmailAndPassword(
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
                            dpass.clear();
                            demail.clear();
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.orange.shade600,
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RegistrationScreen.id);
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.orange.shade600,
                            ),
                            child: Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Continue with",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.blue,
                                ),
                                child: Center(
                                  child: Text(
                                    "Facebook",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                height: 50,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.black,
                                ),
                                child: Center(
                                  child: Text(
                                    "Github",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ]),
                    ),
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
