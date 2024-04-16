// import 'package:intime_news/states.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'components.dart';
// import 'cubit.dart';
// import 'local.dart';
//
// class EditProfile extends StatelessWidget {
//   var nameController = TextEditingController(text: '');
//   var emailController = TextEditingController(text: '');
//   var passwordController = TextEditingController();
//   var formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     nameController = TextEditingController(text: CacheHelper.getData(key: "Name") ?? "");
//     emailController = TextEditingController(text: CacheHelper.getData(key: "Email") ?? "");
//     return BlocProvider.value(
//       value: BlocProvider.of<HomeLayoutCubit>(context),
//       child: BlocConsumer<HomeLayoutCubit, HomeLayoutStates>(
//         listener: (context, state) {
//           if (state is SuccessUpdateState) {
//             Toast(
//                 text: "Updated successfully".tr,
//                 color: HexColor("#00c569"),
//                 context: context);
//           }
//           if (state is ErrorUpdateState) {
//             Toast(
//                 text: "Something went error".tr,
//                 color: Colors.red,
//                 context: context);
//           }
//         },
//         builder: (context, state) {
//           return Scaffold(
//             body: Center(
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 100.0, left: 30, right: 30),
//                 child: ListView(
//                   children: [
//                     Center(
//                       child: Stack(
//                         alignment: Alignment.bottomRight,
//                         children: [
//                           CircleAvatar(
//                             child: CircleAvatar(
//                               radius: 97,
//                             ),
//                             radius: 100,
//                             backgroundColor: HexColor("#00c569"),
//                           ),
//                           InkWell(
//                             child: Padding(
//                               padding: const EdgeInsets.all(15.0),
//                               child: CircleAvatar(
//                                 child: Icon(
//                                   Icons.camera_alt,
//                                   size: 25,
//                                 ),
//                                 backgroundColor: Colors.blueAccent,
//                                 radius: 22,
//                               ),
//                             ),
//                             onTap: () {
//                               HomeLayoutCubit.get(context).getProfileImage();
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Form(
//                       key: formKey,
//                       child: Column(
//                         children: [
//                           TextFormField(
//                               controller: nameController,
//                               validator: (val) {
//                                 if (val!.isEmpty) {
//                                   return "This Field can't be empty".tr;
//                                 }
//                               }),
//                           SizedBox(
//                             height: 30,
//                           ),
//                           TextFormField(
//                               controller: emailController,
//                               validator: (val) {
//                                 if (val!.isEmpty) {
//                                   return "This Field can't be empty".tr;
//                                 }
//                               }),
//                           SizedBox(
//                             height: 40,
//                           ),
//                         ],
//                       ),
//                     ),
//                     TextFormField(
//                       controller: passwordController,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                           hintText:
//                           "Write a New password if you want to change it".tr),
//                     ),
//                     SizedBox(
//                       height: 40,
//                     ),
//                     button(
//                         text: "Update".tr,
//                         function: () {
//                           if (formKey.currentState!.validate()) {
//                             HomeLayoutCubit.get(context).updateData(
//                                 emailController: emailController,
//                                 nameController: nameController);
//                             if (passwordController.text.isNotEmpty) {
//                               FirebaseAuth.instance.currentUser!
//                                   .updatePassword(passwordController.text).then((value) {
//                                 passwordController.text = "";
//                               });
//                             }
//                           }
//                         }),
//                     if (state is LoadingUpdateState)
//                       Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 8.0),
//                         child: LinearProgressIndicator(
//                           color: HexColor("#00c569"),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }