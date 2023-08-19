import 'package:chaty/components/chat_bubble.dart';
import 'package:chaty/components/receiver_chat_bubble.dart';
import 'package:chaty/components/my_text_field.dart';
import 'package:chaty/services/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget{
  final String receiveUserName;
  final String receiveUserID;
  const ChatPage({super.key,required this.receiveUserID,required this.receiveUserName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>{

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService(); // creating an instance of chatservice
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async{
    //only send message if the text controller is not empty
    if(_messageController.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiveUserID, _messageController.text);
      //clear the controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text(widget.receiveUserName),centerTitle: false,backgroundColor: Colors.grey[800],),
      body: Column(
        children: [
          //messages
          Expanded(
            child: _buildMessageList(),
          ),

          //user input
          _buildMessageInput(),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
  //build message list
  Widget _buildMessageList(){
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiveUserID, _firebaseAuth.currentUser!.uid),
      builder: (context,snapshot){
        if(snapshot.hasError){
          return Text('Error${snapshot.error}');
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text('Loading..');
        }

        return ListView(
          children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList()
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String,dynamic> data = document.data() as Map<String,dynamic>;

    //align messages to the right if it is from the current user else align to the left
    var alignment = (data['senderId']==_firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId']==_firebaseAuth.currentUser!.uid) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId']==_firebaseAuth.currentUser!.uid) ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            // Text(data['senderEmail']),
            (data['senderId']==_firebaseAuth.currentUser!.uid) ? ChatBubbleNew(message: data['message']) : ChatBubble(message: data['message']),

          ],
        ),
      ),
    );
  }

  //build message input
  Widget _buildMessageInput(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 4.0),
      child: Row(
        children: [
          //text field
          Expanded(
            child: MyTextField(
                controller: _messageController,
                hintText: 'Enter Message',
                obscureText: false
            ),
          ),

          //send button
          IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                  Icons.send_rounded,
                  size: 40,
              ),
              color: Colors.blue,
          ),
        ],
      ),
    );
  }
}