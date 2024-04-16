import 'package:flutter/gestures.dart';
import 'package:intime_news/statessignup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animations/loading_animations.dart';
import 'Login.dart';
import 'SignupCubit.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmController = TextEditingController();
  bool? isChecked=false;
  bool _passwordVisible = false;
  bool _passwordVisible1 = false;

  @override
  void dispose()
  {
    //clean textfields when widget is disposed
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _passwordVisible1 = false;

  }


  var formKey = GlobalKey<FormState>();
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
        child: BlocProvider(create:(context)=> SignupCubit(),
          child: BlocConsumer<SignupCubit,SignupStates>(
            listener: (context,state){},
            builder: (context,state){

              return Scaffold(
                backgroundColor: Color.fromRGBO(244, 244, 244, 1),
                body: (state is SignupLoadingState)?Center(child: LoadingBouncingGrid.square(backgroundColor: Color.fromRGBO(244, 244, 244, 1),)): Padding(
                  padding: const EdgeInsets.only(right: 10,left: 10,top: 70),
                  child: ListView(
                    children: [

                      //Sign Up
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Sign Up',
                            style: GoogleFonts.raleway(
                                color: Color.fromRGBO(39, 39, 40, 1),
                                fontSize: 36,
                                fontWeight: FontWeight.w700),
                            //style: Theme.of(context).textTheme.headlineLarge,
                          )
                        ],
                      ),


                      SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                      //Sign Up to Enjoy
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign Up to enjoy new experience exploring\n                  '
                                  'news around the World.',
                              style: GoogleFonts.raleway(
                                  color: Color.fromRGBO(133, 137, 143, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              //style: Theme.of(context).textTheme.headlineLarge,
                            )
                          ],
                        ),
                      ),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                      Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(color: Colors.black12,spreadRadius: 2,blurRadius: 10),
                            ]
                            ,color: Colors.white,borderRadius: BorderRadius.circular(5)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
                          child: Column(
                            children: [

                              Form(
                                key: formKey,
                                child: Column(
                                  children: [

                                    //Enter Name
                                    TextFormField(
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(vertical: 17,horizontal: 13),

                                            suffixIcon: const Icon(
                                              Icons.account_circle_outlined,
                                              color: Color.fromRGBO(143, 147, 154, 1),
                                            ),

                                            hintText: 'Enter full name', hintStyle: GoogleFonts.raleway(
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


                                        controller:nameController,validator:(val){
                                      if(val == ""){return "This Field can't be empty".tr;}}),


                                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),

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
                                      if(val == ""){return "This Field can't be empty".tr;}}
                                    ),


                                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),

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
                                          hintText: 'Password',
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



                                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),


                                    //Confirm Password
                                    TextFormField(
                                      controller: confirmController,
                                      maxLines: 1,
                                      minLines: 1,
                                      autofocus: false,
                                      obscureText: _passwordVisible1?false:true,

                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(vertical: 17,horizontal: 13),

                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              color: const Color.fromRGBO(143, 147, 154, 1),
                                              // Based on passwordVisible state choose the icon
                                              _passwordVisible1
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              // Update the state i.e. toogle the state of passwordVisible variable
                                              setState(() {
                                                _passwordVisible1 = !_passwordVisible1;
                                              });
                                            },
                                          ),

                                          // ),
                                          hintText: 'Confirm Password',
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
                                          return"Please entre your password";
                                        }

                                        else if(val != passwordController.text)
                                        {
                                          return"Password Mismatch";
                                        }
                                        return null;

                                      },
                                    ),

                                  ],
                                ),

                              ),




                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                              FormField<bool>(builder:(state) {
                                return Column(
                                  children: <Widget>
                                  [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children:<Widget>
                                      [
                                        Checkbox(value: isChecked,
                                          activeColor: const Color.fromRGBO(30, 63, 132, 0.5),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),

                                          // tristate: true,
                                          onChanged: (newBool) {
                                            setState(() {
                                              isChecked = newBool;
                                            });

                                          },


                                        ),



                                        //Agree to terms
                                        RichText(
                                          text: TextSpan(
                                              text: 'I agree to the ',
                                              style: GoogleFonts.raleway(
                                                  color: const Color.fromRGBO(133, 137, 143, 1),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.normal
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'Terms & Conditions',
                                                  style: GoogleFonts.raleway(
                                                      color: const Color.fromRGBO(30, 63, 132, 1),
                                                      fontSize: 14,
                                                      fontWeight: FontWeight.w400,
                                                      decoration: TextDecoration.underline,
                                                      fontStyle: FontStyle.normal
                                                  ),
                                                )

                                              ]
                                          ),

                                        )
                                      ],
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        state.errorText??'',
                                        style: TextStyle(color: Theme.of(context).errorColor,fontSize: 12,),
                                      ),
                                    )
                                  ],

                                );
                              },

                                  validator:(val)
                                  {
                                    if(isChecked==false)
                                    {
                                      return "\t \t \t You need to agree to our terms and conditions";
                                    }
                                  }


                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.05),

                              //Sign Up button
                              Container(
                                  height: 52,
                                  width: 384,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: ElevatedButton(
                                    child: Text('Sign Up' ,textAlign: TextAlign.center,
                                      style: GoogleFonts.raleway(
                                        color: Color.fromRGBO(244, 244, 244, 1),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),),

                                    onPressed: () async{
                                      if(formKey.currentState!.validate()){
                                        SignupCubit.get(context).createEmail(email: emailController.text, password: passwordController.text,context: context,name: nameController.text);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      backgroundColor: const Color.fromRGBO(30, 63, 132, 1), // Background color
                                    ),
                                  )),

                              SizedBox(height: MediaQuery.of(context).size.height * 0.025),

                              //Already have account
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                      text: "Already have an account?",
                                      style: GoogleFonts.raleway(
                                        color: Color.fromRGBO(133, 137, 143, 1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,),

                                      children: [
                                        TextSpan(
                                            text: '  Sign In',
                                            style: GoogleFonts.raleway(
                                              color: Color.fromRGBO(30, 63, 132, 1),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,),

                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () => Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => LogIn()),
                                              )
                                        ),
                                      ]
                                  ),

                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}