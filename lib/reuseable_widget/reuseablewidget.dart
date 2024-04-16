import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
TextField reuseableTextField (String text ,Icon icons, bool ispasswordtype , TextEditingController controller)
{
  return TextField(
    controller: controller,
    obscureText: ispasswordtype,
    enableSuggestions: ispasswordtype,
    autocorrect: ispasswordtype,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(prefix: Icon(icons as IconData? ,color: Colors.white,),
      labelText:text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),

      suffixIcon: const Icon(
        Icons.account_circle_outlined,
        color: Color.fromRGBO(143, 147, 154, 1),
      ),

      hintText: 'Full Name', hintStyle: GoogleFonts.raleway(
        color: const Color.fromRGBO(143, 147, 154, 1),
        //fontSize: 16,
        fontWeight: FontWeight.w400,

      ),


      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 1, color: Color.fromRGBO(180, 25, 25, 1)),
        borderRadius: BorderRadius.circular(12),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),borderSide: BorderSide(width: 1, color: Color.fromRGBO(39, 39, 40, 1)),
      ),
    ),

    keyboardType: ispasswordtype ? TextInputType.visiblePassword:TextInputType.emailAddress,

  );// TextField
}