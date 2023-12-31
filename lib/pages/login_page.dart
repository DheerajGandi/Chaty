import 'package:chaty/components/my_button.dart';
import 'package:chaty/components/my_text_field.dart';
import 'package:chaty/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget{
  final void Function()? onTap;
  const LoginPage({super.key,required this.onTap});

  @override
  State<LoginPage> createState() =>_LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  //sign in
  void signIn() async{
    //get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try{
      await authService.signInWithEmailAndPassword(
          emailController.text,
          passwordController.text
      );
    } catch (e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString(),),),);
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  //logo
                  Icon(
                    Icons.message,
                    size: 100,
                    color: Colors.blueGrey,
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
                  MyButton(onTap: signIn, text: "Sign In"),

                  const SizedBox(height: 50),

                  //not a member?Sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Not a Member?"),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Register Now",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}