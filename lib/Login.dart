import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intime_news/stateslogin.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ForgotPassword.dart';
import 'SignUp.dart';
import 'components.dart';
import 'cubitlogin.dart';


class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;
  bool isChecked =false;

  @override
  void dispose()
  {
    //clean textfields when widget is disposed
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _loadSavedCredentials();

  }
  void _loadSavedCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      emailController.text = prefs.getString('email') ?? '';
      passwordController.text = prefs.getString('password') ?? '';
      isChecked = prefs.getBool('rememberMe') ?? false;
    });
  }
  void _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (isChecked) {
      prefs.setString('email', emailController.text);
      prefs.setString('password', passwordController.text);
      prefs.setBool('rememberMe', isChecked);
    } else {
      prefs.remove('email');
      prefs.remove('password');
      prefs.remove('rememberMe');
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (ModalRoute
              .of(context)
              ?.settings
              .name != '/home') {
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: BlocProvider(create:(context)=> LogInCubit(),
          child: BlocConsumer<LogInCubit,LoginStates>(
            listener: (context,state){},
            builder:  (context,state){

              return Scaffold(
                backgroundColor: Color.fromRGBO(244, 244, 244, 1),
                body:  (state is LogInLoadingState) ? Center(child: LoadingBouncingGrid.square(backgroundColor: Color.fromRGBO(244, 244, 244, 1),)):Padding(
                  padding: const EdgeInsets.only(right: 10,left: 10,top: 100),
                  child: ListView(
                    children: [
                      //Welcome Back
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome Back!',
                            style: GoogleFonts.raleway(
                                color: Color.fromRGBO(39, 39, 40, 1),
                                fontSize: 36,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.009),
                      //Sign In to continue
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign In to Continue Exploration around the World..',
                            style: GoogleFonts.raleway(
                              color: const Color.fromRGBO(133, 137, 143, 1),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,),
                          )
                        ],
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                      Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black12,spreadRadius: 2,blurRadius: 10),
                            ]
                            ,color: Color.fromRGBO(255, 255, 255, 0.8),borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
                          child: Column(
                              children: [


                                Form(
                                  key: formKey,
                                  child: Column(
                                    children: [

                                      //Enter Email
                                      TextFormField(
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
                                        if(val == "") {
                                          return "This Field can't be empty".tr;
                                        }}),


                                      SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                                      //Enter Password
                                      TextFormField(
                                        controller: passwordController ,
                                        maxLines: 1,
                                        minLines: 1,
                                        autofocus: false,
                                        obscureText: _passwordVisible?false:true,

                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 17,horizontal: 13),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                color: const Color.fromRGBO(143, 147, 154, 1),
                                                // Based on passwordVisible state choose the icon
                                                _passwordVisible
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                              ),
                                              onPressed: () {
                                                // Update the state i.e. toogle the state of passwordVisible variable
                                                setState(() {
                                                  _passwordVisible = !_passwordVisible;
                                                });
                                              },
                                            ),

                                            // ),
                                            hintText: 'Enter your password',
                                            hintStyle:  GoogleFonts.raleway(
                                              color: const Color.fromRGBO(143, 147, 154, 1),
                                              //fontSize: 16,
                                              fontWeight: FontWeight.w400,

                                            ) ,//TextStyle(color: Color.fromRGBO(143, 147, 154, 1)),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(width: 1, color: Color.fromRGBO(30, 63, 132, 0.5)),
                                              // borderRadius: BorderRadius.circular(12),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: const BorderSide(width: 1, color: Color.fromRGBO(30, 63, 132, 1)),
                                              // borderRadius: BorderRadius.circular(12),
                                            )
                                        ),
                                        validator: (val)
                                        {
                                          if(val==null||val.isEmpty)
                                          {
                                            return"This Field can't be empty";
                                          }
                                          else if(val.length < 8)
                                          {
                                            return"Too short , password length shouldn't be less than 8 characters";
                                          }
                                          return null;


                                        },
                                      ),

                                    ],
                                  ),
                                ),


                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),


                                //Check Box
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(value: isChecked,
                                        activeColor: const Color.fromRGBO(30, 63, 132, 0.5),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                        // tristate: true,
                                        onChanged: (value){
                                          setState(() {
                                            isChecked= value!;
                                            _saveCredentials();
                                          });
                                        }),

                                    //Reember Me
                                    Text("Remember Me",
                                      style: GoogleFonts.raleway(
                                          color: const Color.fromRGBO(133, 137, 143, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          fontStyle: FontStyle.normal
                                      )
                                      //style: TextStyle(color: Color.fromRGBO(133, 137, 143, 1))
                                      ,),


                                    //Forgot Password
                                    RichText(
                                      text: TextSpan(
                                          text: '                   ',
                                          children: [
                                            TextSpan(
                                                text: 'Forgot Password?',
                                                style: GoogleFonts.raleway(
                                                    color: const Color.fromRGBO(30, 63, 132, 1),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    decoration: TextDecoration.underline,
                                                    fontStyle: FontStyle.normal
                                                ),

                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => ForgotPassword()),
                                                  )
                                            ),
                                          ]
                                      ),

                                    ),



                                  ],
                                ),


                                SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                                //Sign in button
                                Container(
                                    height: 52,
                                    width: 384,
                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: ElevatedButton(
                                      child: Text('Sign In' ,textAlign: TextAlign.center,
                                        style: GoogleFonts.raleway(
                                          color: Color.fromRGBO(244, 244, 244, 1),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                        ),),

                                      onPressed: () async{
                                        if(formKey.currentState!.validate()){
                                          LogInCubit.get(context).loginWithEmailAndPassword(email: emailController.text, password: passwordController.text,context: context);
                                        }
                                        _saveCredentials();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        backgroundColor: const Color.fromRGBO(30, 63, 132, 1), // Background color
                                      ),
                                    )),

                                SizedBox(height: MediaQuery.of(context).size.height * 0.025),

                                //Don't Have Account?
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                        text: "Don't have an account?",
                                        style: GoogleFonts.raleway(
                                          color: Color.fromRGBO(133, 137, 143, 1),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,),

                                        children: [
                                          TextSpan(
                                              text: '  Sign Up',
                                              style: GoogleFonts.raleway(
                                                color: Color.fromRGBO(30, 63, 132, 1),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,),

                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => SignUp()),
                                                )
                                          ),
                                        ]
                                    ),

                                  ),
                                ),

                              ]),
                        ),

                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}

