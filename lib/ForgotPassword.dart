import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intime_news/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);
  //final controller = Get.put(sign)
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
  static const String id = 'reset_password';
//const ForgotPassword({Key? key}) : super(key: key);


}


class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth= FirebaseAuth.instance;
  final TextEditingController _controller = TextEditingController();
  var emailController = TextEditingController();

  @override



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

            //Reset Password
            Row(
              children: [
                Icon(
                  Icons.password,
                  size: 30,
                  color: Color.fromRGBO(30, 63, 132, 1),
                ),
                SizedBox(
                  width: 8,
                ),
                Text("Reset Password",
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

            //Alert Image
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/Alert-icon.svg", height: 130.0,width: 130.0),
              ],
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.05),

            //Please enter email
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Please Enter Your Email Address To \n "
                    "     Send You A Verification Code.",
                  style: GoogleFonts.raleway(
                      color: const Color.fromRGBO(39, 39, 40, 1),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal
                  ),),
              ],
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

                  child: Column(
                    children: [

                      //Enter Email
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

                      //Send Button
                      Container(
                        height: 52,
                        width: 382,
                        child: ElevatedButton(

                          child: Text('Send' ,textAlign: TextAlign.center,
                            style: GoogleFonts.raleway(
                              color: Color.fromRGBO(244, 244, 244, 1),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            )
                            ,),

                          onPressed: () async{
                            String userInput = _controller.text;
                            sendresetpassword(userInput);

                            Fluttertoast.showToast(
                                msg: 'Email Sent. Check your Gmail..',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Color.fromRGBO(39, 39, 40, 0.8),
                                textColor: Color.fromRGBO(244, 244, 244, 1)
                            );

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
                            String userInput = _controller.text;
                            sendresetpassword(userInput);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LogIn()),
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
                )
            )






          ],
        ),
      ),



    );
  }
  void verifyemail(){

    User? user = FirebaseAuth.instance.currentUser;
    if (!(user!.emailVerified)){
      user.sendEmailVerification();
    }
  }
  void sendresetpassword(String userInput){

    // User? user = FirebaseAuth.instance.currentUser;
    FirebaseAuth.instance.sendPasswordResetEmail(

        email: userInput,
        );
  }









}