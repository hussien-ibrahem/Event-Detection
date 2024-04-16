import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intime_news/Settings.dart';
import 'News.dart';
import 'cubit.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intime_news/SignUp.dart';
import 'package:intime_news/SplashScreen.dart';
import 'package:intime_news/edit_profile.dart';
import 'package:intime_news/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'EditEmail.dart';
import 'EditName.dart';
import 'EditPassword.dart';
import 'ForgotPassword.dart';
import 'Login.dart';
import 'Navigation.dart';
import 'News.dart';
import 'Settings.dart';
import 'Tweet.dart';
import 'cubit.dart';
import 'local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intime_news/Manage_profile.dart';


class EditEmail extends StatefulWidget {
  const EditEmail({Key? key}) : super(key: key);
  //final controller = Get.put(sign)
  @override
  _EditEmailState createState() => _EditEmailState();
  static const String id = 'reset_password';
//const ForgotPassword({Key? key}) : super(key: key);


}

var nameController = TextEditingController(text: '');
var emailController = TextEditingController(text: '');
var passwordController = TextEditingController();
var formKey = GlobalKey<FormState>();

class _EditEmailState extends State<EditEmail> {
  final _auth= FirebaseAuth.instance;
  final TextEditingController _controller = TextEditingController();
  @override
  getUserEmail() async {
    print(FirebaseAuth.instance.currentUser!.uid);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      print(value.data());
      emailController.text = value.data()!["email"];
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserEmail();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,


      body: Padding(
        padding: const EdgeInsets.only(right: 10,left: 10),
        child: ListView(
          children: [

            SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            //Logo
            Center(
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  height: 25.14,
                  width: 139,
                  child: SvgPicture.asset("assets/images/Logo.svg"),
                )
              ]),
            ),


            SizedBox(height: MediaQuery.of(context).size.height * 0.03),

            //Line
            const Divider(
              height: 10,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Color.fromRGBO(143, 147, 154, 1),
            ),


            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

            //Change Email
            Row(
              children: [
                Icon(
                  Icons.email_outlined,
                  size: 28,
                  color: Color.fromRGBO(30, 63, 132, 1),
                ),
                SizedBox(
                  width: 8,
                ),
                Text("Change Email",
                  style:  GoogleFonts.raleway(
                    color: const Color.fromRGBO(39, 39, 40, 1),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,

                  ),
                ),
              ],
            ),


            SizedBox(height: MediaQuery.of(context).size.height * 0.01),

            //Line
            const Divider(
              height: 10,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Color.fromRGBO(143, 147, 154, 1),
            ),



            SizedBox(height: MediaQuery.of(context).size.height * 0.03),

            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/images/Charcter.jpg'),

                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: CircleAvatar(
                        child: Icon(
                          Icons.camera_alt,
                          size: 28,
                        ),
                        backgroundColor: Color.fromRGBO(39, 39, 40, 0.5),
                        radius: 22,
                      ),
                    ),
                    onTap: () {
                      HomeLayoutCubit.get(context).getProfileImage();
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.black12,spreadRadius: 2,blurRadius: 10),
                    ]
                    ,color: Color.fromRGBO(255, 255, 255, 0.8),borderRadius: BorderRadius.circular(12)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),

                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [

                        //Enter Name
                        Center(
                          child: TextFormField(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 17,horizontal: 13),
                                  suffixIcon: const Icon(
                                    Icons.email_outlined,
                                    color: Color.fromRGBO(143, 147, 154, 1),
                                  ),

                                  hintText: 'Enter your email', hintStyle: GoogleFonts.raleway(
                                color: const Color.fromRGBO(143, 147, 154, 1),
                                fontWeight: FontWeight.w400,

                              ),

                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(width: 1, color: Color.fromRGBO(30, 63, 132, 0.5)),
                                    // borderRadius: BorderRadius.circular(12),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: const BorderSide(width: 1, color: Color.fromRGBO(30, 63, 132, 1)),
                                    // borderRadius: BorderRadius.circular(12),
                                  )

                              ),

                              controller:emailController,validator:(val){
                            if(val == ""){return "This Field can't be empty".tr;}}
                          ),

                        ),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.06),

                        //Change Button
                        Container(
                          height: 52,
                          width: 382,
                          child: ElevatedButton(

                            child: Text('Change' ,textAlign: TextAlign.center,
                              style: GoogleFonts.raleway(
                                color: Color.fromRGBO(244, 244, 244, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              )
                              ,),

                            onPressed: () async{
                              if (formKey.currentState!.validate()) {
                                HomeLayoutCubit.get(context).updateDataemail(
                                    emailController: emailController,
                                    );
                                if (passwordController.text.isNotEmpty) {
                                  FirebaseAuth.instance.currentUser!
                                      .updatePassword(passwordController.text).then((value) {
                                    passwordController.text = "";
                                  });
                                }
                              }
                            },

                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              backgroundColor: const Color.fromRGBO(30, 63, 132, 1), // Background color
                            ),
                          ),
                        ),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                        //Cancel button
                        Container(
                          height: 52,
                          width: 382,
                          child: ElevatedButton(

                            child: Text('Cancel' ,textAlign: TextAlign.center,
                              style: GoogleFonts.raleway(
                                color: Color.fromRGBO(30, 63, 132, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              )
                              ,),

                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Settings()),
                              );
                            },

                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              backgroundColor: const Color.fromRGBO(255, 255, 255, 1), // Background color
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                )
            )






          ],
        ),
      ),



    );
  }

}

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();

}

class _SettingsState extends State<Settings> {
  int _currentIndex = 0;
  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SavedPostsScreen()),
      );
    }
    if(index==2){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Settings()),
      );
    }
    if(index==0){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => News()),
      );
    }

  }

  //Change Password Controllers
  bool _passwordVisible = false;
  bool _passwordVisible1 = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    //bool _passwordVisible1 = false;

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(

      resizeToAvoidBottomInset: false,


      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,


      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(
            children: [

              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              //Logo
              Center(
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                    height: 25.14,
                    width: 139,
                    child: SvgPicture.asset("assets/images/Logo.svg"),
                  )
                ]),
              ),


              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              //Line
              const Divider(
                height: 10,
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: Color.fromRGBO(143, 147, 154, 1),
              ),


              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

              //Manage Profile
              Row(
                children: [
                  Icon(
                    Icons.account_circle_outlined,
                    size: 32,
                    color: Color.fromRGBO(30, 63, 132, 1),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text("Manage Profile",
                    style:  GoogleFonts.raleway(
                      color: const Color.fromRGBO(39, 39, 40, 1),
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,

                    ),
                  ),
                ],
              ),


              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

              //Line
              const Divider(
                height: 10,
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: Color.fromRGBO(143, 147, 154, 1),
              ),



              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              //Profile Picture
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width:180,
                      height: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/images/Charcter.jpg',
                            ),
                            colorFilter: const ColorFilter.mode(
                              Color.fromRGBO(39, 39, 40, 0.1),
                              BlendMode.darken,
                            ),
                            fit: BoxFit.cover,
                          )

                      )
                  ),
                ],
              ),





              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              //Manage Account Options
              ChangeName(context, "Change Username"),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              ChangeEmail(context, "Change Email"),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              ChangePass(context, "Change Password"),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),

              SignOut(context, "Sign Out"),


            ]
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: _onTabTapped,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.newspaper),
      //       label: 'News',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.bookmark),
      //       label: 'Saved',
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.account_circle_outlined),
      //         label:'Profile'
      //     ),
      //   ],
      // ),




    );
  }





  //Manage Profile
  //Change Name
  GestureDetector ChangeName(BuildContext context, String title) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return EditName();
        }));
      },

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.raleway(
                color: Color.fromRGBO(143, 147, 154, 1),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal
            ),
          ),
          Icon(
            Icons.arrow_right,
            color: Color.fromRGBO(143, 147, 154, 1),
            size: 32,
          ),
        ],
      ),
    );
  }

  //Change Email
  GestureDetector ChangeEmail(BuildContext context, String title) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return EditEmail();
        }));
      },

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.raleway(
                color: Color.fromRGBO(143, 147, 154, 1),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal
            ),
          ),
          Icon(
            Icons.arrow_right,
            color: Color.fromRGBO(143, 147, 154, 1),
            size: 32,
          ),
        ],
      ),
    );
  }

  //Change Password
  GestureDetector ChangePass(BuildContext context, String title) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
          return EditPassword();
        }));
      },

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.raleway(
                color: Color.fromRGBO(143, 147, 154, 1),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal
            ),
          ),
          Icon(
            Icons.arrow_right,
            color: Color.fromRGBO(143, 147, 154, 1),
            size: 32,
          ),
        ],
      ),
    );
  }

  //Sign Out
  GestureDetector SignOut(BuildContext context, String title) {
    return GestureDetector(
      onTap: () async{
        SharedPreferences prefs =
        await SharedPreferences.getInstance();
        prefs.remove('email');
        prefs.remove('password');
        prefs.remove('rememberMe');
        FirebaseAuth.instance.signOut().then((value) {
          Navigator.push(
              context,
              MaterialPageRoute(builder:
                  (context) => new LogIn()));
          Fluttertoast.showToast(msg: "Signed Out Successfully",
              backgroundColor: Color.fromRGBO(244, 244, 244, 1),
              textColor: Color.fromRGBO(39, 39, 40, 1) );
        });
      },


      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.raleway(
                color: Color.fromRGBO(30, 63, 132, 1),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal
            ),
          ),
          Icon(
            Icons.logout,
            color: Color.fromRGBO(30, 63, 132, 1),
            size: 26,
          ),
        ],
      ),
    );
  }


}