import 'package:chatapp_firebase/pages/chatpage.dart';
import 'package:chatapp_firebase/service/database.dart';
import 'package:chatapp_firebase/service/shared_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

// search feature

class _HomeState extends State<Home> {
  // to indicate the status of search bar
  bool search = false;
  String? myName, myProfilePic, myUserName, myEmail;

  @override
  void initState() {
    super.initState();
    onTheLoad();
  }

  getTheSharedPref() async {
    myName = await SharedPreferenceHelper().getUserDisplayName();
    myProfilePic = await SharedPreferenceHelper().getUserPic();
    myUserName = await SharedPreferenceHelper().getUserName();
    myEmail = await SharedPreferenceHelper().getUserEmail();
    setState(() {});
  }

  onTheLoad() async {
    await getTheSharedPref();
    setState(() {});
  }

  // create a unique chatrooms for each specific user we want to have a chat
  // Compare the first letter of string A and string b
  // EXAMPLE: Alice and BOB
  // Alice --> A --> 65; Bob --> B --> 66
  // 65 < 66 --> Alice\_Bob
  getChatRoomIdByUsername(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  var queryResultSet = [];
  var tempSearchStore = [];

  initiateSearch(String value) {
    if (value.length == 0) {
      setState(() {
        var queryResultSet = [];
        var tempSearchStore = [];
      });
    }

    // this works like capitalize the first letter
    // if you insert cai it will become Cai
    var capitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    print("print capitalizedValue ${capitalizedValue}");

    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().Search(value).then((QuerySnapshot docs) {
        print("searching in the firebase");
        print(docs.docs.length);
        for (int i = 0; i < docs.docs.length; ++i) {
          print("print docs data: ${docs.docs[i].data()}");
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['username'].startsWith(capitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF553370),
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Container(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20, top: 40.0, bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    search
                        ? Expanded(
                            child: TextField(
                            onChanged: (value) {
                              initiateSearch(value.toUpperCase());
                            },
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Search User",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 20,
                                )),
                          ))
                        : Text(
                            "ChatUp",
                            style: TextStyle(
                                color: Color(0Xffc199cd),
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                          ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          search = true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            color: Color(0XFF3a2144),
                            borderRadius: BorderRadius.circular(20)),
                        child: search
                            ? GestureDetector(
                                onTap: () {
                                  setState(() {
                                    search = false;
                                  });
                                },
                                child: Icon(Icons.close))
                            : Icon(
                                Icons.search,
                                color: Color(0xffc199cd),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                height: MediaQuery.of(context).size.height / 1.14,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: Column(
                  children: [
                    search
                        ? ListView(
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            primary: false,
                            shrinkWrap: true,
                            children: tempSearchStore.map((element) {
                              return buildResultCard(element);
                            }).toList(),
                          )
                        : Column(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      // wrap the image in clipReact to make image a circular form
                                      // if it's wrapped with a container it will not be in a circular form
                                      borderRadius: BorderRadius.circular(60),
                                      child: Image.asset(
                                        "images/boy.jpg",
                                        height: 70,
                                        width: 70,
                                        // use the ocmplete height and width it have been given here
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Weidong Cai",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Hello, Whats up?",
                                          style: TextStyle(
                                              color: Colors.black45,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    // spacer to provider the maximum space between two widget
                                    Spacer(),
                                    Container(
                                      child: Text(
                                        "04:30 pm",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                  ],
                ),
              )
            ]),
          ),
        ));
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () async {
        // back to the home screen without begin in the search page
        setState(() {
          search = false;
        });
        var chatRoomId = getChatRoomIdByUsername(myUserName!, data["username"]);
        Map<String, dynamic> chatRoomInfoMap = {
          "user": [myUserName, data["username"]],
        };
        await DatabaseMethods().CreateChatRoom(chatRoomId, chatRoomInfoMap);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChatPage(
                      name: data["Name"],
                      profileUrl: data["Photo"],
                      userName: data["username"],
                    )));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
              padding: EdgeInsets.all(18),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: Image.network(
                      data["Photo"],
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data["Name"],
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        data["username"],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10))),
        ),
      ),
    );
  }
}
