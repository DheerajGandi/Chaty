import 'package:chaty/components/my_text_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>_LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              children: [
                const SizedBox(height: 50),
                //logo
                Icon(
                  Icons.message,
                  size: 80,
                  color: Colors.blueAccent,
                ),

                //welcome back message
                const SizedBox(height: 25),
                const Text(
                  "Welcome back you\'ve been missed!",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),

                //email text field
                MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false
                ),

                const SizedBox(height: 10),

                // password text field
                MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                ),

                const SizedBox(height: 25),

                //sign in button

                //not a member?Sign up
              ],
            ),
          ),
        ),
      ),
    );
  }
}