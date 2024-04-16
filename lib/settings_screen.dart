// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intime_news/states.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hexcolor/hexcolor.dart';
//
// import 'Login.dart';
// import 'cubit.dart';
// import 'edit_profile.dart';
// import 'local.dart';
//
// class menu {
//   String? image, title;
//
//   menu({ this.image, required this.title});
// }
//
// List<menu> items = [
//   menu(image: "prof", title: "Edit Profile"),
//   menu(image: "noti", title: "Notifications"),
// ];
// List functions = [
//   SettingsScreen(),
//
// ];
// class SettingsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: BlocProvider.of<HomeLayoutCubit>(context),
//       child: BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(
//         listener: (context, state) {},
//         builder: (context, state) {
//           return Padding(
//             padding: const EdgeInsets.only(top: 100.0, right: 20, left: 20),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(
//                       child: CircleAvatar(
//                         radius: 50,
//                       ),
//                       radius: 52,
//                       backgroundColor: HexColor("#00c569"),
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Container(
//                           width: 220,
//                           child: Text(CacheHelper.getData(key: "Name")??" ",
//                             style: GoogleFonts.merriweatherSans(fontSize: 26),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 2,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 5,
//                         ),
//                         Text((CacheHelper.getData(key: "Email")),
//                             style: GoogleFonts.merriweatherSans(fontSize: 17)),
//                         SizedBox(
//                           height: 30,
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 ListView.separated(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       if (index == items.length-1){
//                         return Column(
//                           children: [
//                             InkWell(
//                               child: Row(
//                                 children: [
//                                   SizedBox(
//                                     width: 6,
//                                   ),
//
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 25,
//                             ),
//                             SizedBox(
//                               height: 35,
//                             ),
//
//                             InkWell(
//                               child: Row(
//                                 children: [
//                                   Image.asset(
//                                     'assets/images/logout.png',
//                                     fit: BoxFit.cover,
//                                   ),
//                                   SizedBox(
//                                     width: 15,
//                                   ),
//                                   Text(
//                                     "Log Out".tr,
//                                     style: GoogleFonts.merriweatherSans(
//                                         fontSize: 22),
//                                   ),
//                                 ],
//                               ),
//                               onTap: (){
//                                 FirebaseAuth.instance.signOut();
//                                 CacheHelper.saveData(key: "uid", value: null);
//                                 CacheHelper.saveData(key: "isLogged", value: false);
//                                 Get.to(LogIn());
//                               },
//                             ),
//                           ],
//                         );
//                       }
//                       return InkWell(child: menuItem(items[index]),onTap: (){Get.to(functions[index]);},);
//                     },
//                     separatorBuilder: (context, index) => SizedBox(
//                       height: 25,
//                     ),
//                     itemCount: items.length),
//
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// Widget menuItem(menu model) => Row(
//   children: [
//     Image.asset(
//       'assets/images/${model.image}.png',
//       fit: BoxFit.cover,
//     ),
//     SizedBox(
//       width: 15,
//     ),
//     Text(
//       "${model.title}".tr,
//       style: GoogleFonts.merriweatherSans(fontSize: 22),
//     ),
//     Spacer(),
//     Icon(Icons.arrow_forward_ios),
//   ],
// );