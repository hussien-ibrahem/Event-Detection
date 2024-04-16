import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intime_news/News.dart';
import 'package:share/share.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Navigation.dart';

class Tweet extends StatefulWidget {
  String User;
  String Time;
  int Tweet_id;
  bool liked;
  String tweet;
  String category;
  int likes;
  String Date;

  Tweet({Key? key,
    required this.Tweet_id,
    required this.liked,
    required this.tweet,
    required this.category,
    required this.likes,
    required this.Date,
    required this.User,
    required this.Time})
      : super(key: key);
  List<String> images = [
    'https://media.istockphoto.com/id/1158115722/photo/sports-and-games-background.jpg?s=170667a&w=0&k=20&c=JcnnIjPP_wVQaRKPLy5aIi536TTWxLk6xvbDHazpScQ=',
    'https://www.leasefoundation.org/wp-content/uploads/2018/10/rsz_technology_abstract_photo.jpg',
    'https://thumbs.dreamstime.com/b/blue-screensaver-international-politics-news-background-world-map-n-screensaver-news-policy-100113198.jpg',
    'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YnVzaW5lc3MlMjBiYWNrZ3JvdW5kfGVufDB8fDB8fA%3D%3D&w=1000&q=80',
  ];
  bool isSaved = false;

  @override
  _TweetState createState() => _TweetState();
}

class _TweetState extends State<Tweet> {
  checkIfSaved() async {
    print("ooooo");
    await FirebaseFirestore.instance
        .collection('saved_posts')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      print(value.data());
      if (value.exists) {
        List<dynamic> x = value.data()!["post_ids"];
        if (x.contains(widget.Tweet_id)) {
          setState(() {
            widget.isSaved = true;
          });
        } else {
          setState(() {
            widget.isSaved = false;
          });
        }
      }
    });
  }

  void savePost() async {
    print("Pressed");
    await FirebaseFirestore.instance
        .collection('saved_posts')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        List<dynamic> x = value.data()!["post_ids"];
        if (x.contains(widget.Tweet_id)) {
          //grey
          x.remove(widget.Tweet_id);
          setState(() {
            widget.isSaved = false;
          });

          FirebaseFirestore.instance
              .collection('saved_posts')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({'post_ids': FieldValue.arrayUnion(x)});
        } else {
          //red
          x.add(widget.Tweet_id);
          setState(() {
            widget.isSaved = true;
          });
          FirebaseFirestore.instance
              .collection('saved_posts')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({'post_ids': FieldValue.arrayUnion(x)});
        }
      } else {
        setState(() {
          widget.isSaved = true;
        });
        //red
        FirebaseFirestore.instance
            .collection('saved_posts')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'post_ids': FieldValue.arrayUnion([widget.Tweet_id])
        });
      }
    });
    setState(() {});
  }

  List<Map<String, dynamic>> relatedTweets = [];

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

  Future<List<Map<String, dynamic>>> getListFromFirebase() async {
    // print("Marwaan******************************************");
    relatedTweets = [];
    final databaseReference = FirebaseDatabase.instance.reference();
    DatabaseEvent event =
    await databaseReference.child('results4').limitToFirst(100).once();

    DataSnapshot snapshot = event.snapshot;

    if (snapshot.value != null) {
      for (int i = 0; i < 100; i++) {
        if (widget.category ==
            snapshot
                .child(i.toString())
                .child("category")
                .value) {
          print(snapshot
              .child(i.toString())
              .value);
          Map<Object?, Object?> obj =
          snapshot
              .child(i.toString())
              .value as Map<Object?, Object?>;
          Map<String, dynamic> convertedMap =
          obj.map((key, value) => MapEntry(key.toString(), value));
          relatedTweets.add(convertedMap);
        }
        if (relatedTweets.length == 3) {
          break;
        }
      }
      print(relatedTweets);
    } else {
      print("NO data");
    }

    return relatedTweets;
  }

  void loadData() async {
    await getListFromFirebase();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
    checkIfSaved();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
          child: ListView(
            children: [
              //Logo
              Row(
                children: [
                  FloatingActionButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Nav(),
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
                  SizedBox(width: 70),
                  Container(
                    height: 25.14,
                    width: 139,
                    child: SvgPicture.asset("assets/images/Logo.svg"),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              //Line
              const Divider(
                height: 5,
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: Colors.blueGrey,
              ),

              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(30, 63, 132, 1),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "User: ${widget.User} ",
                  style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(30, 63, 132, 1),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  "Time:${widget.Time} ",
                  style: GoogleFonts.raleway(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal),
                ),
              ),

              //Tweet Name
              Text(
                widget.tweet,
                style: GoogleFonts.raleway(
                    color: const Color.fromRGBO(39, 39, 40, 1),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal),
              ),

              const SizedBox(height: 10),
              //Line
              const Divider(
                height: 10,
                thickness: 2,
                indent: 0,
                endIndent: 0,
                color: Color.fromRGBO(143, 147, 154, 1),
              ),

              //Icons
              SizedBox(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (widget.liked == false) {
                                  widget.likes += 1;
                                  widget.liked = true;
                                  final databaseReference =
                                  FirebaseDatabase.instance.reference();
                                  databaseReference
                                      .child('results4')
                                      .child(widget.Tweet_id.toString())
                                      .child('likes')
                                      .set(widget.likes);
                                } else if (widget.liked == true) {
                                  widget.likes -= 1;
                                  widget.liked = false;
                                  final databaseReference =
                                  FirebaseDatabase.instance.reference();
                                  databaseReference
                                      .child('results4')
                                      .child(widget.Tweet_id.toString())
                                      .child('likes')
                                      .set(widget.likes);
                                }
                              });
                            },
                            icon: Icon(
                              widget.liked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: widget.liked
                                  ? Color.fromRGBO(180, 25, 25, 1)
                                  : Color.fromRGBO(39, 39, 40, 1),
                              size: 30,
                            ),
                          ),
                          Text(
                            widget.likes.toString() + "  Likes",
                            style: GoogleFonts.raleway(
                                color: const Color.fromRGBO(39, 39, 40, 1),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          savePost();
                        },
                        icon: Icon(
                          Icons.bookmark_border,
                          color: widget.isSaved
                              ? Color.fromRGBO(
                              180, 25, 25, 1)
                              : Color.fromRGBO(39, 39, 40, 1),
                          size: 28,
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () async {
                          // print("******************************************************************************************");
                          // print(widget.User);
                          // print(widget.Time);

                          await Share.share(widget.tweet);
                          // await  Share.share(widget.User);
                          //
                          // await  Share.share(widget.Time);

                          // await Share.share(widget.tweet);
                        },
                        icon: const Icon(
                          Icons.share,
                          color: Color.fromRGBO(0, 0, 0, 1.0),
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              //Line
              const Divider(
                height: 15,
                thickness: 2,
                indent: 0,
                endIndent: 0,
                color: Color.fromRGBO(143, 147, 154, 1),
              ),

              //Related Tweets
              Text(
                "Related to this tweet",
                style: GoogleFonts.raleway(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal),
              ),

              SizedBox(height: 5),

              //Related Tweets
              Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.22,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) =>
                        GestureDetector(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                  image: NetworkImage(background_image[
                                  relatedTweets[index]["category"]]!),
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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(width: 200),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.favorite,
                                          color: Color.fromRGBO(180, 25, 25, 1),
                                          size: 30,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          savePost();
                                        },
                                        icon: Icon(
                                          Icons.bookmark_border,
                                          color:
                                          Color.fromRGBO(244, 244, 244, 1),
                                          size: 25,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.share,
                                          color:
                                          Color.fromRGBO(244, 244, 244, 1),
                                          size: 25,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Container(
                                    height: 90,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.5),
                                        borderRadius:
                                        BorderRadius.circular(25)),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: 350,
                                          child: Text(
                                            relatedTweets[index]["tweet"],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.raleway(
                                              color: Color.fromRGBO(
                                                  244, 244, 244, 1),
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Likes: ${relatedTweets[index]["likes"]
                                                  .toString()}",
                                              style: GoogleFonts.raleway(
                                                color: Colors.white70,
                                                fontSize: 28,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 240,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          // onTap: () {
                          //   Navigator.of(context).pushReplacement(
                          //       new MaterialPageRoute(
                          //           builder: (context) => new Tweet(Tweet_id: 1,)));
                          // },
                        ),
                    separatorBuilder: (context, index) => SizedBox(width: 5),
                    itemCount: relatedTweets.length),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
