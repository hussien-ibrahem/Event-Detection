import 'package:intime_news/Login.dart';
import 'package:intime_news/statessignup.dart';
import 'package:intime_news/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Navigation.dart';
import 'News.dart';
import 'components.dart';
import 'local.dart';


class SignupCubit extends Cubit<SignupStates> {
  FirebaseAuth auth = FirebaseAuth.instance;

  SignupCubit() : super(initialSignupState());

  static SignupCubit get(context) => BlocProvider.of(context);
  UserModel? userModel;

  void createEmail(
      {required email, required password, context, required name}) {
    emit(SignupLoadingState());
    auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      userModel = UserModel(
          email: value.user!.email, name: name, uid: value.user!.uid);
      FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set(
          userModel!.toMap()).then((value){
        emit(saveUserDataSuccessState());
        emit(SignupSuccessState());
        CacheHelper.saveData(key: "isLogged", value: true);
        Toast(text: "Signed Up Successfully", color: Color.fromRGBO(244, 244, 244, 1), context: context);
        Get.offAll(LogIn());
      }).catchError((e) {
        print(e.toString());
      }
      );
    }
    ).catchError((e) {
      emit(SignupErrorState());
      Toast(text: e.toString(), color: Color.fromRGBO(180, 25, 25, 0.5), context: context);
    });;
  }
}