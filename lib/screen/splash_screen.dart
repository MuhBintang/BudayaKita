import 'package:app_budaya/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
with SingleTickerProviderStateMixin{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()
      ));
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, 
    overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff3EBFAA), Color(0xff705FAA)], 
            begin: Alignment.topRight,
            end: Alignment.bottomLeft, 
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "images/logo.png",
              width: 188,
              height: 234,
              ),
            Image.asset(
              "images/BudayaKita.png",
              width: 231,
              height: 57,
              ),
            // Text(
            //   "BudayaKita", 
            //   style: TextStyle(
            //     fontStyle: FontStyle.normal,
            //     fontWeight: FontWeight.bold, 
            //     color: Colors.white, 
            //     fontSize: 32
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}