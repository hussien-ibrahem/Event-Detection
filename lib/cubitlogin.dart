import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intime_news/News.dart';
import 'package:intime_news/stateslogin.dart';
import 'package:intime_news/user_model.dart';

import 'Navigation.dart';
import 'components.dart';
import 'edit_profile.dart';
import 'local.dart';

class LogInCubit extends Cubit<LoginStates> {

  LogInCubit() : super(initialLoginState());

  static LogInCubit get(context) => BlocProvider.of(context);

  FirebaseAuth auth = FirebaseAuth.instance;

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  FacebookLogin facebookLogin = FacebookLogin();

  Future loginWithGoogle(context) async {
    emit(LogInLoadingState());
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    var cradintials = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    auth.signInWithCredential(cradintials).then((value) {
      userModel = UserModel(email: value.user!.email,
        name: value.user!.displayName,
        //pic: value.user!.photoURL,
        uid: value.user!.uid,
        //isAdmin: value.user!.uid.contains("iYeCIPwzXIenCJWecg1ZehrkYd23")?true:false,
      );

      FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set(
          userModel!.toMap()).then((value) {
        emit(LogInSuccessState());
        CacheHelper.saveData(key: "isLogged", value: true);
        Toast(text: "Signed In Successfully",
            color: Colors.green,
            context: context);
        Get.offAll(Nav());
      }).catchError((e) {
        print(e.toString());
        emit(LogInErrorState());
        Toast(text: e.toString(), color: Color.fromRGBO(180, 25, 25, 0.5), context: context);
      });
    }).catchError((e) {
      emit(LogInErrorState());
      print(e.toString());
      Toast(text: e.toString(), color: Color.fromRGBO(180, 25, 25, 0.5), context: context);
    });
  }

  UserModel? userModel;

  void logInWithFacebook(context) async {
    emit(LogInLoadingState());
    var result = await facebookLogin.logIn(permissions: [
      FacebookPermission.email,
      FacebookPermission.publicProfile
    ]);
    final accessToken = result.accessToken!.token;

    if (result.status == FacebookLoginStatus.success) {
      var facebookCradintial = FacebookAuthProvider.credential(accessToken);
      auth.signInWithCredential(facebookCradintial).then((value) {
        userModel = UserModel(email: value.user!.email,
          name: value.user!.displayName,
          //pic: value.user!.photoURL,
          uid: value.user!.uid,
        );

        FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set(
            userModel!.toMap()).then((value) {
          emit(LogInSuccessState());
          CacheHelper.saveData(key: "isLogged", value: true);
          Toast(text: "Signed In Successfully",
              color: Colors.green,
              context: context);
          Get.offAll(Nav());
        }).catchError((e) {
          print(e.toString());
        });
      }).catchError((e){
        emit(LogInErrorState());
        print(e.toString());
        Toast(text: e.toString(),color: Color.fromRGBO(180, 25, 25, 0.5));
      });
    }
  }

  void loginWithEmailAndPassword(
      {required email,required password,context})
  {
    if(email==Null || password==Null){
      emit(LogInErrorState());
      Toast(text:"Email or password is null", color: Color.fromRGBO(180, 25, 25, 0.5),
      context: context,
      );
      return;
    }
    emit(LogInLoadingState());
    auth.signInWithEmailAndPassword(email: email, password: password).then((
        value) {
      emit(LogInSuccessState());
      CacheHelper.saveData(key: "isLogged", value: true);
      Toast(text: "Signed In Successfully",
          color: Colors.green,
          context: context);
      Get.offAll(Nav());
    }).catchError((e) {
      emit(LogInErrorState());
      print(e.toString());
      Toast(text: e.toString(), color: Color.fromRGBO(180, 25, 25, 0.5), context: context);
    });
  }
}