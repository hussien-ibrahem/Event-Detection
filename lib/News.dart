import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'EditEmail.dart';
import 'EditName.dart';
import 'EditPassword.dart';
import 'Login.dart';
import 'Tweet.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'Tweet.dart';
import 'package:firebase_database/firebase_database.dart';

Future<List<Map<String, dynamic>>> getListFromFirebase() async {
  // print("Marwaan******************************************");
  List<Map<String, dynamic>> _allUsers = [];
  final databaseReference = FirebaseDatabase.instance.reference();
  DatabaseEvent event =
      await databaseReference.child('results4').limitToLast(300).once();

  DataSnapshot snapshot = event.snapshot;

  if (snapshot.value != null) {
    Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
    values.forEach((key, value) {
      _allUsers.add(Map<String, dynamic>.from(value));
      // print("list = " + value.toString());
      // print (key);
      // print("##########################################");
      // print(value);
    });
  }

  // print("length = ${_allUsers.length}");

  return _allUsers;
}

List<Map<String, dynamic>> _allUsers = [];
List<Map<String, dynamic>> _foundUsers = [];
final Map<String, String> background_image = {
  "Politics":
      "https://thumbs.dreamstime.com/b/blue-screensaver-international-politics-news-background-world-map-n-screensaver-news-policy-100113198.jpg",
  "Business":
      "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YnVzaW5lc3MlMjBiYWNrZ3JvdW5kfGVufDB8fDB8fA%3D%3D&w=1000&q=80",
  "Sports":
      "https://media.istockphoto.com/id/1158115722/photo/sports-and-games-background.jpg?s=170667a&w=0&k=20&c=JcnnIjPP_wVQaRKPLy5aIi536TTWxLk6xvbDHazpScQ=",
  "Finance":
      "https://www.leasefoundation.org/wp-content/uploads/2018/10/rsz_technology_abstract_photo.jpg",
};

bool sports_selected = false;
bool finance_selected = false;
bool politics_selected = false;
bool business_selected = false;
bool all_selected = true;

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  List<String> savedPostIds = [];
  List<SavedPost> _savedPosts = []; // Declare the _savedPosts list

  void initState() {
    super.initState();
    loadData();
    getAllPostsSavedId();
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) => user["tweet"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  void loadData() async {
    List<Map<String, dynamic>> data = await getListFromFirebase();
    List<Map<String, dynamic>> updatedData = data.map((item) {
      return {
        ...item,
        'liked': false,
      };
    }).toList();
    setState(() {
      _allUsers = updatedData;
      _foundUsers = updatedData;
    });
  }

  void _runFilter_category(String category_name) {
    List<Map<String, dynamic>> results = [];
    if (category_name == "all") {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) =>
              user["category"].toLowerCase() == (category_name.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  void unsavePost(int index) {
    // setState(() {
    //
    //   bool saved = _foundUsers[index]['saved'];
    //   _foundUsers[index]['saved'] = !saved;
    //   _allUsers[index]['saved'] = !saved;
    //
    //   // Remove the saved post from the _savedPosts list if it exists
    //   SavedPost? savedPost = _savedPosts.firstWhere((post) => post.id == _foundUsers[index]['id']);
    //   if (savedPost != null) {
    //     _savedPosts.remove(savedPost);
    //   }
    //
    //   // Remove the post ID from the list of saved post IDs in Firestore
    //   FirebaseFirestore.instance
    //       .collection('saved_posts')
    //       .doc(FirebaseAuth.instance.currentUser!.uid)
    //       .update({
    //     'post_ids': FieldValue.arrayRemove([_foundUsers[index]['id']])
    //   });
    //
    //   // Print the updated list of saved post IDs for testing purposes
    //   FirebaseFirestore.instance
    //       .collection('saved_posts')
    //       .doc(FirebaseAuth.instance.currentUser!.uid)
    //       .get()
    //       .then((snapshot) {
    //     List<dynamic> postIds = snapshot.data()!['post_ids'];
    //     print('Saved post IDs: $postIds');
    //   });
    // });
  }

  //
  List<dynamic> ids = [];

  getAllPostsSavedId() async {
    ids.clear();
    await FirebaseFirestore.instance
        .collection('saved_posts')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      print(value.data());
      if (value.exists) {
        List<dynamic> x = value.data()!["post_ids"];
        setState(() {
          ids.addAll(x);
        });
      }
    });
  }

  void savePost(int index, int id) async {
    await FirebaseFirestore.instance
        .collection('saved_posts')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        List<dynamic> x = value.data()!["post_ids"];
        if (x.contains(id)) {
          //grey
          x.remove(id);
          FirebaseFirestore.instance
              .collection('saved_posts')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({'post_ids': FieldValue.arrayUnion(x)}).whenComplete(() {
            getAllPostsSavedId();
          });
        } else {
          //red
          x.add(id);
          FirebaseFirestore.instance
              .collection('saved_posts')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({'post_ids': FieldValue.arrayUnion(x)}).whenComplete(() {
            getAllPostsSavedId();
          });
        }
      } else {
        //red
        FirebaseFirestore.instance
            .collection('saved_posts')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'post_ids': FieldValue.arrayUnion([id])
        }).whenComplete(() {
          getAllPostsSavedId();
        });
      }
    }).whenComplete(() {
      getAllPostsSavedId();
    });
    setState(() {});
    // setState(() {
    //   bool saved = _foundUsers[index]['saved'];
    //   _foundUsers[index]['saved'] = !saved;
    //   _allUsers[index]['saved'] = !saved; // Update the saved property in _allUsers
    //
    //   // Remove the saved post from the _savedPosts list if it was previously saved
    //   if (saved) {
    //     _savedPosts.removeWhere((post) => post.id == _foundUsers[index]['id']);
    //   }
    //   // Add the saved post to the _savedPosts list if it was not previously saved
    //   else {
    //     SavedPost savedPost = SavedPost(
    //       id: _foundUsers[index]['id'],
    //       content: _foundUsers[index]['content'],
    //       category: _foundUsers[index]['category'],
    //       date: _foundUsers[index]['date'],
    //     );
    //     _savedPosts.add(savedPost);
    //   }
    //
    //   // Save the list of post IDs to Firebase Firestore
    //   FirebaseFirestore.instance
    //       .collection('saved_posts')
    //       .doc(FirebaseAuth.instance.currentUser!.uid)
    //       .update({
    //     'post_ids': FieldValue.arrayUnion([_foundUsers[index]['id']])
    //   });
    // });
  }

  Color saveButtonColor(bool saved) {
    return saved
        ? Color.fromRGBO(180, 25, 25, 1)
        : Color.fromRGBO(244, 244, 244, 1);
  }

  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SavedPostsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (ModalRoute.of(context)?.settings.name != '/home') {
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                //Logo
                Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 25.14,
                          width: 139,
                          child: SvgPicture.asset("assets/images/Logo.svg"),
                        )
                      ]),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                //Search
                Container(
                  child: TextField(
                    onChanged: (value) => _runFilter(value),
                    maxLines: 1,
                    minLines: 1,
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color.fromRGBO(143, 147, 154, 1),
                        ),
                        hintText: 'Search events',
                        hintStyle: GoogleFonts.raleway(
                          color: const Color.fromRGBO(143, 147, 154, 1),
                          //fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: Color.fromRGBO(39, 39, 40, 1)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Color.fromRGBO(30, 63, 132, 1)),
                          borderRadius: BorderRadius.circular(12),
                        )),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.015),
                //Categories
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            icon: SvgPicture.asset(
                              "assets/icons/world.svg",
                              width: 24,
                              height: 24,
                              color: all_selected
                                  ? Colors.white
                                  : Color.fromRGBO(133, 137, 143, 1),
                            ),
                            label: Text('All',
                                style: GoogleFonts.raleway(
                                  color: all_selected
                                      ? Colors.white
                                      : Color.fromRGBO(133, 137, 143, 1),
                                  fontSize: 14,
                                  fontWeight: all_selected
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                )),
                            onPressed: () {
                              setState(() {
                                all_selected = true;
                                sports_selected = false;
                                finance_selected = false;
                                politics_selected = false;
                                business_selected = false;
                              });
                              _runFilter_category("all");
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              primary: all_selected
                                  ? Color.fromRGBO(30, 63, 132, 1)
                                  : Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          ElevatedButton.icon(
                            icon: SvgPicture.asset("assets/icons/stadium.svg",
                                width: 24, height: 24),
                            label: Text('Sports',
                                style: GoogleFonts.raleway(
                                  color: sports_selected
                                      ? Colors.white
                                      : Color.fromRGBO(133, 137, 143, 1),
                                  fontSize: 14,
                                  fontWeight: all_selected
                                      ? FontWeight.w400
                                      : FontWeight.w500,
                                )),
                            onPressed: () {
                              setState(() {
                                all_selected = false;
                                sports_selected = true;
                                finance_selected = false;
                                politics_selected = false;
                                business_selected = false;
                              });
                              _runFilter_category("sports");
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              primary: sports_selected
                                  ? Color.fromRGBO(30, 63, 132, 1)
                                  : Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          ElevatedButton.icon(
                            icon: SvgPicture.asset(
                                "assets/icons/profit-bar-chart.svg",
                                width: 24,
                                height: 24),
                            label: Text('Finance',
                                style: GoogleFonts.raleway(
                                  color: finance_selected
                                      ? Colors.white
                                      : Color.fromRGBO(133, 137, 143, 1),
                                  fontSize: 14,
                                  fontWeight: all_selected
                                      ? FontWeight.w400
                                      : FontWeight.w500,
                                )),
                            onPressed: () {
                              setState(() {
                                all_selected = false;
                                sports_selected = false;
                                finance_selected = true;
                                politics_selected = false;
                                business_selected = false;
                              });
                              _runFilter_category("finance");
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              primary: finance_selected
                                  ? Color.fromRGBO(30, 63, 132, 1)
                                  : Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          ElevatedButton.icon(
                            icon: SvgPicture.asset(
                                "assets/icons/politician.svg",
                                width: 24,
                                height: 24),
                            label: Text('Politics',
                                style: GoogleFonts.raleway(
                                  color: politics_selected
                                      ? Colors.white
                                      : Color.fromRGBO(133, 137, 143, 1),
                                  fontSize: 14,
                                  fontWeight: all_selected
                                      ? FontWeight.w400
                                      : FontWeight.w500,
                                )),
                            onPressed: () {
                              setState(() {
                                all_selected = false;
                                sports_selected = false;
                                finance_selected = false;
                                politics_selected = true;
                                business_selected = false;
                              });
                              _runFilter_category("Politics");
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              primary: politics_selected
                                  ? Color.fromRGBO(30, 63, 132, 1)
                                  : Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          ElevatedButton.icon(
                            icon: SvgPicture.asset("assets/icons/business.svg",
                                width: 24, height: 24),
                            label: Text('Business',
                                style: GoogleFonts.raleway(
                                  color: business_selected
                                      ? Colors.white
                                      : Color.fromRGBO(133, 137, 143, 1),
                                  fontSize: 14,
                                  fontWeight: all_selected
                                      ? FontWeight.w400
                                      : FontWeight.w500,
                                )),
                            onPressed: () {
                              setState(() {
                                all_selected = false;
                                sports_selected = false;
                                finance_selected = false;
                                politics_selected = false;
                                business_selected = true;
                              });
                              _runFilter_category("Business");
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              primary: business_selected
                                  ? Color.fromRGBO(30, 63, 132, 1)
                                  : Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Spacer(),
                //Popular Events
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Popular Events",
                        style: GoogleFonts.raleway(
                            color: const Color.fromRGBO(39, 39, 40, 1),
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal)
                        //style: TextStyle(color: Color.fromRGBO(133, 137, 143, 1))
                        ,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 17),
                //Tweets
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: _allUsers.isNotEmpty
                      ? ListView.builder(
                          itemCount: _foundUsers.length,
                          itemBuilder: (context, index) => Column(
                            children: [
                              GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          background_image[_foundUsers[index]
                                                  ['category']
                                              .toString()]!,
                                        ),
                                        colorFilter: const ColorFilter.mode(
                                          Colors.black54,
                                          BlendMode.darken,
                                        ),
                                        fit: BoxFit.cover),
                                    //color: Colors.cyan,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            //Like Button

                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  bool liked =
                                                      _foundUsers[index]
                                                          ['liked'];
                                                  int likes = _foundUsers[index]
                                                      ['likes'];

                                                  // Update the like status and count
                                                  _foundUsers[index]['liked'] =
                                                      !liked;
                                                  _foundUsers[index]['likes'] =
                                                      liked
                                                          ? likes -= 1
                                                          : likes += 1;

                                                  // Save the updated "likes" value to the real-time database
                                                  final databaseReference =
                                                      FirebaseDatabase.instance
                                                          .reference();
                                                  databaseReference
                                                      .child('results4')
                                                      .child(_foundUsers[index]
                                                              ['id']
                                                          .toString())
                                                      .child('likes')
                                                      .set(likes);
                                                });
                                              },
                                              icon: Icon(
                                                _foundUsers[index]['liked']
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: _foundUsers[index]
                                                        ['liked']
                                                    ? Color.fromRGBO(
                                                        180, 25, 25, 1)
                                                    : Color.fromRGBO(
                                                        244, 244, 244, 1),
                                                size: 30,
                                              ),
                                            ),
                                            //Save Button
                                            IconButton(
                                              onPressed: () {
                                                savePost(index,
                                                    _foundUsers[index]['id']);
                                                print("rezkk + " +
                                                    ids
                                                        .contains(
                                                            _foundUsers[index]
                                                                ['id'])
                                                        .toString());
                                              },
                                              icon: Icon(
                                                Icons.bookmark_border,
                                                color: ids.contains(
                                                        _foundUsers[index]
                                                            ['id'])
                                                    ? Color.fromRGBO(
                                                    180, 25, 25, 1)
                                                    : Color.fromRGBO(
                                                    244, 244, 244, 1),
                                                size: 25,
                                              ),
                                            ),
                                            //Share Button
                                            IconButton(
                                              onPressed: () async {
                                                await Share.share(
                                                    _foundUsers[index]
                                                        ['tweet']);
                                              },
                                              icon: const Icon(
                                                Icons.share,
                                                color: Color.fromRGBO(
                                                    244, 244, 244, 1),
                                                size: 25,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 50,
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    _foundUsers[index]['tweet'],
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.raleway(
                                                      color: Color.fromRGBO(
                                                          244, 244, 244, 1),
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.thumb_up,
                                                  color: Colors.white70,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                  width: 7,
                                                ),
                                                Text(
                                                  _foundUsers[index]['likes']
                                                          .toString() +
                                                      "  Likes",
                                                  style: GoogleFonts.raleway(
                                                    color: Colors.white70,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 35,
                                                ),
                                                Icon(
                                                  Icons.date_range,
                                                  color: Colors.white70,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                  width: 7,
                                                ),
                                                Text(
                                                  _foundUsers[index]['Date']
                                                      .toString(),
                                                  style: GoogleFonts.raleway(
                                                    color: Colors.white70,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .pushReplacement(new MaterialPageRoute(
                                          builder: (context) => new Tweet(
                                                Tweet_id: _foundUsers[index]
                                                    ['id'],
                                                liked: _foundUsers[index]
                                                    ['liked'],
                                                tweet: _foundUsers[index]
                                                    ['tweet'],
                                                category: _foundUsers[index]
                                                    ['category'],
                                                likes: _foundUsers[index]
                                                    ['likes'],
                                                Date: _foundUsers[index]
                                                    ['Date'],
                                              User:_foundUsers[index]['User'],
                                              Time:_foundUsers[index]['Time']                                              )));
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        )
                      : const Text(
                          'No results found! \nPlease try to search with different name',
                          style: TextStyle(fontSize: 24),
                        ),
                ),
              ],
            ),
          ),
          // bottomNavigationBar: BottomNavigationBar(
          //   currentIndex: _currentIndex,
          //   onTap: _onTabTapped,
          //   items: [
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.list),
          //       label: 'Posts',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: Icon(Icons.bookmark),
          //       label: 'Saved',
          //     ),
          //   ],
          // ),
        ));
  }
}

class SavedPostsScreen extends StatefulWidget {
  @override
  _SavedPostsScreenState createState() => _SavedPostsScreenState();
}

class _SavedPostsScreenState extends State<SavedPostsScreen> {
  // int _currentIndex = 0;
  //
  // void _onTabTapped(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //   });
  //   if (index == 0) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => News()),
  //     );
  //   }
  //   if (index == 2) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => Settings()),
  //     );
  //   }
  // }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where((user) => user["content"]
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  List<Map<String, dynamic>> _savedPosts = [];

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('saved_posts')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((doc) {
      List<int> savedPostIds = List<int>.from(doc['post_ids']);
      setState(() {
        _savedPosts = _allUsers
            .where((user) => savedPostIds.contains(user['id']))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.09),
            //Logo
            Center(
              child: Row(children: [
                //Back Button
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => News(),
                            ));
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 32,
                      ),
                      backgroundColor: Color.fromRGBO(244, 244, 244, 1),
                      foregroundColor: Color.fromRGBO(39, 39, 40, 1),
                      elevation: 1.5,
                    ),
                  ],
                ),

                SizedBox(width: 70),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 25.14,
                      width: 139,
                      child: SvgPicture.asset("assets/images/Logo.svg"),
                    ),
                  ],
                ),
              ]),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            //search
            Container(
              child: TextField(
                onChanged: (value) => _runFilter(value),
                maxLines: 1,
                minLines: 1,
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color.fromRGBO(143, 147, 154, 1),
                    ),
                    hintText: 'Search events',
                    hintStyle: GoogleFonts.raleway(
                      color: const Color.fromRGBO(143, 147, 154, 1),
                      //fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 1, color: Color.fromRGBO(39, 39, 40, 1)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 1, color: Color.fromRGBO(30, 63, 132, 1)),
                      borderRadius: BorderRadius.circular(12),
                    )),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            //Popular Events
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Save Events",
                    style: GoogleFonts.raleway(
                        color: const Color.fromRGBO(39, 39, 40, 1),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.normal)
                    //style: TextStyle(color: Color.fromRGBO(133, 137, 143, 1))
                    ,
                  ),
                ],
              ),
            ),
            Expanded(
              child: _savedPosts.isEmpty
                  ? Text('No saved posts.')
                  : ListView.builder(
                      itemCount: _savedPosts.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SizedBox(height: 10),
                            GestureDetector(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      background_image[_savedPosts[index]
                                              ['category']
                                          .toString()]!,
                                    ),
                                    colorFilter: const ColorFilter.mode(
                                      Colors.black54,
                                      BlendMode.darken,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 10,
                                  ),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          //Like Button
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                if (_foundUsers[index]
                                                        ['liked'] ==
                                                    false) {
                                                  _foundUsers[index]['likes'] +=
                                                      1;
                                                  _foundUsers[index]['liked'] =
                                                      true;
                                                } else if (_foundUsers[index]
                                                        ['liked'] ==
                                                    true) {
                                                  _foundUsers[index]['likes'] -=
                                                      1;
                                                  _foundUsers[index]['liked'] =
                                                      false;
                                                }
                                              });
                                            },
                                            icon: Icon(
                                              _foundUsers[index]['liked']
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: _foundUsers[index]['liked']
                                                  ? Color.fromRGBO(
                                                      180, 25, 25, 1)
                                                  : Color.fromRGBO(
                                                      244, 244, 244, 1),
                                              size: 30,
                                            ),
                                          ),
                                          // Save Button
                                          // IconButton(
                                          //   onPressed: () {
                                          //     savePost(index);
                                          //   },
                                          //   icon: Icon(
                                          //     Icons.bookmark,
                                          //     color: Colors.red,
                                          //     size: 25,
                                          //   ),
                                          // ),
//Share Button
                                          IconButton(
                                            onPressed: () async {
                                              await Share.share(
                                                  _foundUsers[index]
                                                      ['content']);
                                            },
                                            icon: const Icon(
                                              Icons.share,
                                              color: Color.fromRGBO(
                                                  244, 244, 244, 1),
                                              size: 25,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 70,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  _savedPosts[index]['tweet'],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.raleway(
                                                    color: Color.fromRGBO(
                                                        244, 244, 244, 1),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                _savedPosts[index]['category'],
                                                style: GoogleFonts.raleway(
                                                  color: Color.fromRGBO(
                                                      244, 244, 244, 1),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                _savedPosts[index]['Date'],
                                                style: GoogleFonts.raleway(
                                                  color: Color.fromRGBO(
                                                      244, 244, 244, 1),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => Tweet(
                                //       post: _savedPosts[index],
                                //       allPosts: _allUsers,
                                //     ),
                                //   ),
                                // );
                              },
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),

    );
  }
}

class SavedPost {
  final int id;
  final String content;
  final String category;
  final String date;

  SavedPost({
    required this.id,
    required this.content,
    required this.category,
    required this.date,
  });
}





class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SavedPostsScreen()),
      );
    }
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Settings()),
      );
    }
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => News()),
      );
    }
  }

  //Change Password Controllers
  bool _passwordVisible = false;
  bool _passwordVisible1 = false;

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    //bool _passwordVisible1 = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView(children: [
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

          //Manage Profile
          Row(
            children: [
              Icon(
                Icons.account_circle_outlined,
                size: 32,
                color: Color.fromRGBO(30, 63, 132, 1),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "Manage Profile",
                style: GoogleFonts.raleway(
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

          //Profile Picture
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/images/Charcter.jpg',
                        ),
                        colorFilter: const ColorFilter.mode(
                          Color.fromRGBO(39, 39, 40, 0.1),
                          BlendMode.darken,
                        ),
                        fit: BoxFit.cover,
                      ))),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.03),

          //Manage Account Options
          ChangeName(context, "Change Username"),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),

          ChangeEmail(context, "Change Email"),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),

          ChangePass(context, "Change Password"),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),

          SignOut(context, "Sign Out"),
        ]),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.white,
      //   unselectedItemColor: Color.fromRGBO(39, 39, 40, 1),
      //   unselectedLabelStyle:
      //       GoogleFonts.raleway(color: const Color.fromRGBO(39, 39, 40, 1)),
      //   selectedLabelStyle:
      //       GoogleFonts.raleway(color: const Color.fromRGBO(30, 63, 132, 1)),
      //   currentIndex: _currentIndex,
      //   onTap: _onTabTapped,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.newspaper),
      //       label: 'News',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.bookmark),
      //       label: 'Saved',
      //     ),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.account_circle_outlined), label: 'Profile'),
      //   ],
      // ),
    );
  }

  //Manage Profile
  //Change Name
  GestureDetector ChangeName(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return EditName();
        }));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.raleway(
                color: Color.fromRGBO(143, 147, 154, 1),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
          Icon(
            Icons.arrow_right,
            color: Color.fromRGBO(143, 147, 154, 1),
            size: 32,
          ),
        ],
      ),
    );
  }

  //Change Email
  GestureDetector ChangeEmail(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return EditEmail();
        }));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.raleway(
                color: Color.fromRGBO(143, 147, 154, 1),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
          Icon(
            Icons.arrow_right,
            color: Color.fromRGBO(143, 147, 154, 1),
            size: 32,
          ),
        ],
      ),
    );
  }

  //Change Password
  GestureDetector ChangePass(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return EditPassword();
        }));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.raleway(
                color: Color.fromRGBO(143, 147, 154, 1),
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal),
          ),
          Icon(
            Icons.arrow_right,
            color: Color.fromRGBO(143, 147, 154, 1),
            size: 32,
          ),
        ],
      ),
    );
  }

  //Sign Out
  GestureDetector SignOut(BuildContext context, String title) {
    return GestureDetector(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('email');
        prefs.remove('password');
        prefs.remove('rememberMe');
        FirebaseAuth.instance.signOut().then((value) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => new LogIn()));
          Fluttertoast.showToast(
              msg: "Signed Out Successfully",
              backgroundColor: Color.fromRGBO(244, 244, 244, 1),
              textColor: Color.fromRGBO(39, 39, 40, 1));
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.raleway(
                color: Color.fromRGBO(30, 63, 132, 1),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal),
          ),
          Icon(
            Icons.logout,
            color: Color.fromRGBO(30, 63, 132, 1),
            size: 26,
          ),
        ],
      ),
    );
  }
}
