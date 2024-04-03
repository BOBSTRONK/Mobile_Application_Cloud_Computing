// all the function for FireStore

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future<QuerySnapshot> getUserByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("E-mail", isEqualTo: email)
        .get();
  }

  // return the query from "user" Collection in the firebase
  // where all document that has the "SearchKey" corresponding to the
  // first letter that user have inserted into the textfield
  Future<QuerySnapshot> Search(String username) async {
    print("query $username");
    return await FirebaseFirestore.instance
        .collection("users")
        .where("SearchKey", isEqualTo: username.substring(0, 1).toUpperCase())
        .get();
  }

  CreateChatRoom(
      String chatRoomId, Map<String, dynamic> chatRoomInfoMap) async {
    // search if the chatRoom already exists
    final snapshot = await FirebaseFirestore.instance
        .collection("chatRooms")
        .doc(chatRoomId)
        .get();
    if (snapshot.exists) {
      return true;
    } else {
      return FirebaseFirestore.instance
          .collection("chatRooms")
          .doc(chatRoomId)
          .set(chatRoomInfoMap);
    }
  }
}
