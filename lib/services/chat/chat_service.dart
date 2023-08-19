import 'package:chaty/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier{

  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //send messages
  Future<void> sendMessage(String receiverId,String message) async{
    //get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        timestamp: timestamp,
        message: message
    );

    //construct a chat room unique to sender and receiver(sorted to ensure uniqueness)
    List<String> ids = [currentUserId,receiverId];
    ids.sort(); //sort the ids(this ensures that the chet room id is unique for a given pair of users)
    String chatroomId = ids.join("_"); // combine the ids into into a single string to use as chatroom id

    //add new message to database
    await _firestore.collection('chat_rooms').doc(chatroomId).collection('messages').add(newMessage.toMap());
  }
  // get messages
  Stream<QuerySnapshot> getMessages(String userId,String otherUserId){
    //construct chatroom id from user ids;
    List<String> ids = [userId,otherUserId];
    ids.sort();
    String chatroomId = ids.join("_");

    return _firestore.collection('chat_rooms').doc(chatroomId).collection('messages').orderBy('timestamp',descending: false).snapshots();
  }
}