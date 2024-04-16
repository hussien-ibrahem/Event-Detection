// ignore_for_file: avoid_print
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

import 'dart:io';
import 'dart:ui';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intime_news/Login.dart';
import 'package:intime_news/settings_screen.dart';
import 'package:intime_news/states.dart';

import 'local.dart';
import 'News.dart';
import 'package:intime_news/Manage_profile.dart';
class HomeLayoutCubit extends Cubit<HomeLayoutStates> {
  HomeLayoutCubit() : super(initialHomeLayoutState());

  static HomeLayoutCubit get(context) => BlocProvider.of(context);

  List<Widget> Screens = [
    Settings(),
  ];

  int currentIndex = 0;

  void changeIndex(index) {
    currentIndex = index;
    emit(changeIndexSuccessfully());
  }


  List<int> numper = [];
  int? sum;


  void increaseUi(index) {
    numper[index]++;
    emit(increaseUiState());
  }

  void decreaseUi(index) {
    if (numper[index] != 1) numper[index]--;
    emit(decreaseUiState());
  }




  getUserdata() {
    emit(saveUserDataLoadingState());

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      CacheHelper.saveData(key: "Name", value: value.data()!['name']);

      CacheHelper.saveData(key: "Picture", value: value.data()!['pic']);
      CacheHelper.saveData(key: "Email", value: value.data()!['email'] ?? "");
      CacheHelper.saveData(key: "Uid", value: value.data()!['uid']);
      emit(saveUserDataSuccessState());
    }).catchError((e) {
      print(e.toString());
      emit(saveUserDataErrorState());
    });
  }

  String? value;

  changeradio(val) {
    value = val;
    print(value);
    emit(changedState());
  }

  File? profileImage;
  final picker = ImagePicker();

  Future getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(getProfileImagePickerSuccessState());
    } else {
      print('No image selected.');
      emit(getProfileImagePickerErrorState());
    }
  }
  File? image;

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      emit(getProfileImagePickerSuccessState());
    } else {
      print('No image selected.');
      emit(getProfileImagePickerErrorState());
    }
  }

  updateDataemail(
      {required TextEditingController emailController,}) {
    emit(LoadingUpdateState());
    if(profileImage == null) {
      emit(LoadingUpdateState());
      return FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'email': emailController.text,
      }).then((value) {
        FirebaseAuth.instance.currentUser!
            .updateEmail(emailController.text);

        emit(SuccessUpdateState());
        CacheHelper.saveData(key: "Email", value: emailController.text);
        Get.offAll(Settings());
        profileImage = null;
      }).catchError((e) {
        print(e.toString());
        emit(ErrorUpdateState());
      });
    }
    else {
      emit(LoadingUpdateState());
      return firebase_storage.FirebaseStorage.instance
          .ref()
          .child(
          'usersImages/${Uri
              .file(profileImage!.path)
              .pathSegments
              .last}')
          .putFile((profileImage as File))
          .then((val) {
        emit(LoadingUpdateState());
        val.ref.getDownloadURL().then((valuee) {
          emit(LoadingUpdateState());
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'email': emailController.text,
            'pic': valuee,
          }).then((value) {
            FirebaseAuth.instance.currentUser!
                .updateEmail(emailController.text);

            emit(SuccessUpdateState());
            CacheHelper.saveData(key: "Email", value: emailController.text);
            CacheHelper.saveData(key: "Picture", value: valuee);
            Get.offAll(Settings());
            profileImage = null;
          }).catchError((e) {
            print(e.toString());
            emit(ErrorUpdateState());
          });
        });
      });
    }
  }

  updateDataname(
      {
        required TextEditingController nameController}) {
    emit(LoadingUpdateState());
    if(profileImage == null) {
      emit(LoadingUpdateState());
      return FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'name': nameController.text,
      }).then((value) {

        FirebaseAuth.instance.currentUser!
            .updateDisplayName(nameController.text);
        emit(SuccessUpdateState());
        CacheHelper.saveData(key: "Name", value: nameController.text);
        Get.offAll(Settings());
        profileImage = null;
      }).catchError((e) {
        print(e.toString());
        emit(ErrorUpdateState());
      });
    }
    else {
      emit(LoadingUpdateState());
      return firebase_storage.FirebaseStorage.instance
          .ref()
          .child(
          'usersImages/${Uri
              .file(profileImage!.path)
              .pathSegments
              .last}')
          .putFile((profileImage as File))
          .then((val) {
        emit(LoadingUpdateState());
        val.ref.getDownloadURL().then((valuee) {
          emit(LoadingUpdateState());
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'name': nameController.text,
            'pic': valuee,
          }).then((value) {

            FirebaseAuth.instance.currentUser!
                .updateDisplayName(nameController.text);
            emit(SuccessUpdateState());
            CacheHelper.saveData(key: "Name", value: nameController.text);
            CacheHelper.saveData(key: "Picture", value: valuee);
            Get.offAll(Settings());
            profileImage = null;
          }).catchError((e) {
            print(e.toString());
            emit(ErrorUpdateState());
          });
        });
      });
    }
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label:'Profile'
          ),
        ],
      ),




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