import 'package:chaty/pages/chat_page.dart';
import 'package:chaty/services/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign out user
  void signOut(){
    //get authservice
    final authService = Provider.of<AuthService>(context,listen: false);

    authService.signOut();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Chaty'),
        centerTitle: true,
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
        backgroundColor: Colors.grey[800],
        actions: [
          //signout button
          IconButton(
              onPressed: signOut,
              icon : const Icon(Icons.logout)
          )
        ],
      ),
      body: _buildUserList(),
      backgroundColor: Colors.black,
    );
  }

  // build user list
  Widget _buildUserList(){
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context,snapshot){
        if(snapshot.hasError){
          return const Text("Error");
        }
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Text("Loading..");
        }

        return ListView(
          children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
        );
      },
    );
  }

  //build each user list item
  Widget _buildUserListItem(DocumentSnapshot document){
    Map<String,dynamic> data = document.data()! as Map<String,dynamic>;

  //display all users except current user
    if(_auth.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['username'],style: TextStyle(fontStyle: FontStyle.italic,fontSize: 20,color: Colors.white),),
        onTap: (){
          //pass the clicked users uid to chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiveUserID: data['uid'],
                receiveUserName: data['username'],
              ),
            ),
          );
        },
      );
    }else{
      return Container();
    }
  }
}