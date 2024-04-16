import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';


Widget textForm(
    {required text,
      required hint,
      required TextEditingController controller,
      required validator,
      obsecure = false
    }) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text("${text}".tr,
        //     style: GoogleFonts.raleway(color: Colors.black54)),
        // TextFormField(
        //   obscureText: obsecure,
        //   controller: controller,
        //   validator: validator,
        //   decoration: InputDecoration(
        //       focusedBorder: UnderlineInputBorder(
        //         borderSide: BorderSide(color: HexColor("#00c569")),
        //       ),
        //       enabledBorder: UnderlineInputBorder(
        //         borderSide: BorderSide(color: HexColor("#00c569")),
        //       ),
        //       focusColor: HexColor("#00c569"),
        //       hintText: "${hint}".tr,
        //       hintStyle: GoogleFonts.raleway(color: Colors.black26)),
        // ),
      ],
    );

Widget button({required text,required function}) => MaterialButton(
    onPressed: function,
    child: Text(
      "${text}".tr,
      style: GoogleFonts.raleway(
        color: Color.fromRGBO(244, 244, 244, 1),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),

    color: Color.fromRGBO(30, 63, 132, 1),
    minWidth: double.infinity,
    height: 52);

Toast({required text,required Color color,context})=>showToast(text,backgroundColor: color,position: StyledToastPosition.bottom,context: context);