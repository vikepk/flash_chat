import 'package:flutter/material.dart';
import 'package:flash/screens/registration_screen.dart';
import 'package:flash/screens/chat_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,

        // home: WelcomeScreen(),
        initialRoute: Firstpage.id,
        routes: {
          RegistrationScreen.id: (context) => RegistrationScreen(),
          ChatScreen.id: (context) => ChatScreen(),
          Firstpage.id: (context) => Firstpage(),
        });
  }
}
