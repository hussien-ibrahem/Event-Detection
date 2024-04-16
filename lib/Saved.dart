// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:share/share.dart';
// import 'Tweet.dart';
// List<Map<String, dynamic>> _allUsers = [
//   {
//     "id": 1,
//     "content":"Have a World Series winning pitcher coming on the pod down in FLA this week.Who else is down here for Spring training that wants to help us educate, entertain &amp; inspire the next generation with @theathletespod? #MLB #SpringTraining #sports" ,
//     "date": "1/31/2023",
//     "category" : "sports",
//     "likes" : 7,
//     "liked" : false,
//     "saved" :false,
//   },
//
//   {
//     "id": 3,
//     "content":"#DFI is a key enabler of #innovation and economic growth. From #startups to large #enterprises, it is essential for businesses to have access to necessary #funding. @FlexaHQ is proud to be a leading provider of #DFI to help businesses of all sizes succeed. #Finance #Investment" ,
//     "date": "1/31/2023",
//     "category" : "finance",
//     "likes" : 16,
//     "liked" : false,
//     "saved" :false,
//
//   },
// ];
//
// List<Map<String, dynamic>> _foundUsers = [];
// final Map<String, String> background_image = {"politics": "https://thumbs.dreamstime.com/b/blue-screensaver-international-politics-news-background-world-map-n-screensaver-news-policy-100113198.jpg",
//   "Business": "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YnVzaW5lc3MlMjBiYWNrZ3JvdW5kfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
//   "sports": "https://media.istockphoto.com/id/1158115722/photo/sports-and-games-background.jpg?s=170667a&w=0&k=20&c=JcnnIjPP_wVQaRKPLy5aIi536TTWxLk6xvbDHazpScQ=",
//   "finance": "https://www.leasefoundation.org/wp-content/uploads/2018/10/rsz_technology_abstract_photo.jpg",
// };
// bool sports_selected = false;
// bool finance_selected = false;
// bool politics_selected = false;
// bool business_selected = false;
// bool all_selected = true;
// class Saved extends StatefulWidget {
//   const Saved({Key? key}) : super(key: key);
//   @override
//   State<Saved> createState() => _SavedState();
// }
// class _SavedState extends State<Saved> {
//   List<String> savedPostIds = [];
//   List<SavedPost> _savedPosts = []; // Declare the _savedPosts list
//
//   void initState() {
//     super.initState();
//     _foundUsers = _allUsers;
//
//   }
//   void _runFilter(String enteredKeyword) {
//     List<Map<String, dynamic>> results = [];
//     if (enteredKeyword.isEmpty) {
//       // if the search field is empty or only contains white-space, we'll display all users
//       results = _allUsers;
//     } else {
//       results = _allUsers
//           .where((user) =>
//           user["content"].toLowerCase().contains(enteredKeyword.toLowerCase()))
//           .toList();
//       // we use the toLowerCase() method to make it case-insensitive
//     }
//
//     // Refresh the UI
//     setState(() {
//       _foundUsers = results;
//     });
//   }
//   void _runFilter_category(String category_name) {
//     List<Map<String, dynamic>> results = [];
//     if (category_name == "all") {
//       // if the search field is empty or only contains white-space, we'll display all users
//       results = _allUsers;
//     } else {
//       results = _allUsers
//           .where((user) =>
//       user["category"].toLowerCase() == (category_name.toLowerCase()))
//           .toList();
//       // we use the toLowerCase() method to make it case-insensitive
//     }
//
//     // Refresh the UI
//     setState(() {
//       _foundUsers = results;
//     });
//   }
//   void savePost(int index) {
//     setState(() {
//       bool saved = _foundUsers[index]['saved'];
//       _foundUsers[index]['saved'] = !saved;
//       _allUsers[index]['saved'] = !saved; // Update the saved property in _allUsers
//
//       // Remove the saved post from the _savedPosts list if it was previously saved
//       if (saved) {
//         _savedPosts.removeWhere((post) => post.id == _foundUsers[index]['id']);
//       }
//       // Add the saved post to the _savedPosts list if it was not previously saved
//       else {
//         SavedPost savedPost = SavedPost(
//           id: _foundUsers[index]['id'],
//           content: _foundUsers[index]['content'],
//           category: _foundUsers[index]['category'],
//           date: _foundUsers[index]['date'],
//         );
//         _savedPosts.add(savedPost);
//       }
//
//       // Save the list of post IDs to Firebase Firestore
//       FirebaseFirestore.instance
//           .collection('saved_posts')
//           .doc(FirebaseAuth.instance.currentUser!.uid)
//           .set({
//         'post_ids': _savedPosts.map((post) => post.id).toList(),
//       });
//     });
//   }
//   Color saveButtonColor(bool saved) {
//     return saved ? Color.fromRGBO(180, 25, 25, 1) : Color.fromRGBO(244, 244, 244, 1);
//   }
//   int _currentIndex = 0;
//   void _onTabTapped(int index) {
//     setState(() {
//       _currentIndex = index;
//     });
//     if (index == 1) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => SavedPostsScreen()),
//       );
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//           if (ModalRoute
//               .of(context)
//               ?.settings
//               .name != '/home') {
//             return Future.value(false);
//           } else {
//             return Future.value(true);
//           }
//         },
//         child: Scaffold(
//           resizeToAvoidBottomInset: false,
//           body:Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.0),
//             child: ListView(
//               physics: NeverScrollableScrollPhysics(),
//               children: [
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//                 //Logo
//                 Center(
//                   child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//                     Container(
//                       height: 25.14,
//                       width: 139,
//                       child: SvgPicture.asset("assets/images/Logo.svg"),
//                     )
//                   ]),
//                 ),
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//
//
//                 //Search
//                 Container(
//                   child: TextField(
//                     onChanged: (value) => _runFilter(value),
//
//                     maxLines: 1,
//                     minLines: 1,
//                     decoration: InputDecoration(
//                         contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 13),
//
//                         prefixIcon: const Icon(
//                           Icons.search,
//                           color: Color.fromRGBO(143, 147, 154, 1),
//                         ),
//
//                         hintText: 'Search events', hintStyle: GoogleFonts.raleway(
//                       color: const Color.fromRGBO(143, 147, 154, 1),
//                       //fontSize: 16,
//                       fontWeight: FontWeight.w400,
//
//                     ),
//
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(width: 1, color: Color.fromRGBO(39, 39, 40, 1)),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: const BorderSide(width: 1, color: Color.fromRGBO(30, 63, 132, 1)),
//                           borderRadius: BorderRadius.circular(12),
//                         )
//                     ),
//                   ),
//                 ),
//
//
//                 SizedBox(height: MediaQuery.of(context).size.height * 0.03),
//                 Spacer(),
//
//
//                 //Saved Events
//                 Container(
//                   child:
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text("Saved Events",
//                         style: GoogleFonts.raleway(
//                             color: const Color.fromRGBO(39, 39, 40, 1),
//                             fontSize: 22,
//                             fontWeight: FontWeight.w600,
//                             fontStyle: FontStyle.normal
//                         )
//                         //style: TextStyle(color: Color.fromRGBO(133, 137, 143, 1))
//                         ,),
//                     ],
//                   ),
//
//                 ),
//                 SizedBox(height: 17),
//                 //Tweets
//                 Container(
//                   height: MediaQuery.of(context).size.height * 0.6,
//                   child:Expanded(
//                     child: _foundUsers.isNotEmpty
//                         ? ListView.builder(
//                       itemCount: _foundUsers.length,
//                       itemBuilder: (context, index) =>Column(
//                         children: [
//                           GestureDetector(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(12),
//                                 image: DecorationImage(
//                                     image: NetworkImage(
//                                       background_image[_foundUsers[index]['category'].toString()]! ,
//                                     ),
//                                     colorFilter: const ColorFilter.mode(
//                                       Colors.black54,
//                                       BlendMode.darken,
//                                     ),
//                                     fit: BoxFit.cover),
//                                 //color: Colors.cyan,
//                               ),
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 10, vertical: 10),
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         //Like Button
//                                         IconButton(
//                                           onPressed: (){
//                                             setState(() {
//
//                                               if(_foundUsers[index]['liked']==false){
//                                                 _foundUsers[index]['likes']+=1;
//                                                 _foundUsers[index]['liked'] =true;}
//                                               else if(_foundUsers[index]['liked']==true){
//                                                 _foundUsers[index]['likes']-=1;
//                                                 _foundUsers[index]['liked']=false;
//                                               }
//                                             });
//                                           },
//
//                                           icon:  Icon(
//                                             _foundUsers[index]['liked']?Icons.favorite:Icons.favorite_border,
//                                             color: _foundUsers[index]['liked']?Color.fromRGBO(180, 25, 25, 1):Color.fromRGBO(244, 244, 244, 1),
//                                             size: 30,
//                                           ),
//
//
//                                         ),
//
//                                         //Save Button
//                                         IconButton(
//                                           onPressed: () {
//                                             savePost(index);
//                                           },
//                                           icon: Icon(
//                                             Icons.bookmark_border,
//                                             color: saveButtonColor(_foundUsers[index]['saved']),
//                                             size: 25,
//                                           ),
//                                         ),
//                                         //Share Button
//                                         IconButton(
//                                           onPressed: ()async{
//                                             await Share.share(_foundUsers[index]['content']);
//                                           },
//                                           icon: const Icon(
//                                             Icons.share,
//                                             color: Color.fromRGBO(244, 244, 244, 1),
//                                             size: 25,
//
//                                           ),
//                                         ),
//
//                                       ],
//                                     ),
//                                     SizedBox(
//                                       height: 50,
//                                     ),
//                                     Column(
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Expanded(
//                                               child: Text(
//                                                 _foundUsers[index]['content'],
//                                                 maxLines: 1,
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style:
//                                                 GoogleFonts.raleway(
//                                                   color: Color.fromRGBO(244, 244, 244, 1),
//                                                   fontSize: 20,
//                                                   fontWeight: FontWeight.w700,
//                                                 ),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           height: 20,
//                                         ),
//                                         Row(
//                                           crossAxisAlignment: CrossAxisAlignment.center,
//
//                                           children: [
//                                             Icon(
//                                               Icons.thumb_up,
//                                               color: Colors.white70,
//                                               size:20,
//                                             ),
//                                             SizedBox(
//                                               width: 7,
//                                             ),
//
//                                             Text(
//                                               _foundUsers[index]['likes'].toString() + "  Likes",
//                                               style:
//                                               GoogleFonts.raleway(
//                                                 color: Colors.white70,
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//                                             SizedBox(
//                                               width: 35,
//                                             ),
//                                             Icon(
//                                               Icons.date_range,
//                                               color: Colors.white70,
//                                               size:20,
//                                             ),
//                                             SizedBox(
//                                               width: 7,
//                                             ),
//
//
//                                             Text(
//                                               _foundUsers[index]['date'].toString(),
//                                               style:
//                                               GoogleFonts.raleway(
//                                                 color: Colors.white70,
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w500,
//                                               ),
//                                             ),
//
//
//                                           ],
//                                         ),
//                                         SizedBox(
//                                           height: 10,
//                                         ),
//                                       ],
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//
//                             onTap: () {
//                               Navigator.of(context).pushReplacement(
//                                   new MaterialPageRoute(
//                                       builder: (context) => new Tweet(
//                                         Tweet_id:_foundUsers[index]['id'] ,
//                                       )));
//                             },
//                           ),
//                           SizedBox(
//                             height: 10,
//                           ),
//                         ],
//                       ),
//
//
//                     )
//                         : const Text(
//                       'No results found! \nPlease try to search with different name',
//                       style: TextStyle(fontSize: 24),
//                     ),
//                   ),
//
//                 ),
//               ],
//             ),
//           ),
//
//           // bottomNavigationBar: BottomNavigationBar(
//           //   currentIndex: _currentIndex,
//           //   onTap: _onTabTapped,
//           //   items: [
//           //     BottomNavigationBarItem(
//           //       icon: Icon(Icons.list),
//           //       label: 'Posts',
//           //     ),
//           //     BottomNavigationBarItem(
//           //       icon: Icon(Icons.bookmark),
//           //       label: 'Saved',
//           //     ),
//           //   ],
//           // ),
//         ));
//   }}
// class SavedPostsScreen extends StatefulWidget {
//   @override
//   _SavedPostsScreenState createState() => _SavedPostsScreenState();
// }
// class _SavedPostsScreenState extends State<SavedPostsScreen> {
//   List<Map<String, dynamic>> _savedPosts = [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     FirebaseFirestore.instance
//         .collection('saved_posts')
//         .doc(FirebaseAuth.instance.currentUser!.uid)
//         .get()
//         .then((doc) {
//       List<int> savedPostIds = List<int>.from(doc['post_ids']);
//       setState(() {
//         _savedPosts = _allUsers
//             .where((user) => savedPostIds.contains(user['id']))
//             .toList();
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Saved Posts'),
//       ),
//       body: _savedPosts.isEmpty
//           ? Text('No saved posts.')
//           : ListView.builder(
//         itemCount: _savedPosts.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(_savedPosts[index]['content']),
//             subtitle: Text(_savedPosts[index]['date']),
//             // Add more widgets to display other post data
//           );
//         },
//       ),
//     );
//   }
// }
// class SavedPost {
//   final int id;
//   final String content;
//   final String category;
//   final String date;
//
//   SavedPost({
//     required this.id,
//     required this.content,
//     required this.category,
//     required this.date,
//   });
// }