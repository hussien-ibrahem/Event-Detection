import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intime_news/Navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login.dart';
import 'News.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();

}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    _checkLogin();


  }
  void _checkLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    bool rememberMe = prefs.getBool('rememberMe') ?? false;
    if (email != null && password != null && rememberMe) {
      Timer(
          Duration(seconds: 5),
              () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) =>  News())));
    } else {
      Timer(
          Duration(seconds: 5),
              () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) => LogIn())));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Stack(
        children: <Widget>[
          Blackcircle1(),
          Blackcircle2(),
          Redcircle1(),
          Redcircle2(),
          SmallBlackcircle1(),
          SmallBlackcircle2(),
          SmallRedcircle1(),
          SmallRedcircle2(),
          Logo(),
        ],
      ),

    );
  }



  Widget Logo() {
    return Positioned(

        child: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 58,
                  width: 321,
                  child: SvgPicture.asset("assets/images/Logo.svg"),
                )
              ]
          ),
        )
    );
  }

  Widget Redcircle1() {
    return Positioned(
        top: -18,
        left: -16,
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: const Color.fromRGBO(30, 63, 132, 1)),
        ));
  }

  Widget Redcircle2() {
    return Positioned(
        top: 810,
        left: 340,
        child: Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: const Color.fromRGBO(30, 63, 132, 1)),
        ));
  }

  Widget Blackcircle1() {
    return Positioned(
        top: -18,
        left: 365,
        child: Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: const Color.fromRGBO(39, 39, 40, 1)),
        ));
  }

  Widget Blackcircle2() {
    return Positioned(
        top: 835,
        left: -19,
        child: Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: const Color.fromRGBO(39, 39, 40, 1)),
        ));
  }

  Widget SmallRedcircle1() {
    return Positioned(
        top: 140,
        left: 323,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: const Color.fromRGBO(30, 63, 132, 0.59)),
        ));
  }

  Widget SmallRedcircle2() {
    return Positioned(
        top: 533,
        left: 21,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: const Color.fromRGBO(30, 63, 132, 0.59)),
        ));
  }

  Widget SmallBlackcircle1() {
    return Positioned(
        top: 268,
        left: 87,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: const Color.fromRGBO(39, 39, 40, 0.45)),
        ));
  }

  Widget SmallBlackcircle2() {
    return Positioned(
        top: 633,
        left: 267,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(150),
              color: const Color.fromRGBO(39, 39, 40, 0.45)),
        ));
  }

}
