import 'package:flutter/material.dart';
import 'package:flash/screens/login_screen.dart';
import 'package:flash/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash/components/components.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "/welcome";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
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
    return Scaffold(
      backgroundColor: animation.value as Color,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
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
                            color: Colors.black)),
                  ],
                  onTap: () {
                    print("Tap Event");
                  },
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundButton(
              color: Colors.lightBlueAccent,
              title: "Log In",
              onPress: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundButton(
              color: Colors.blueAccent,
              title: "Register",
              onPress: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
