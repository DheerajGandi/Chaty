import 'package:chaty/components/my_button.dart';
import 'package:chaty/components/my_text_field.dart';
import 'package:chaty/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget{
  final void Function()? onTap;
  const RegisterPage({super.key,required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{

  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final usernameController = TextEditingController();

  //signup
  void signUp() async{
    if(passwordController.text != confirmpasswordController.text){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Passwords do not match!"),),);
      return;
    }

    //get auth service if passwords match
    final authService = Provider.of<AuthService>(context,listen : false);
    try{
      await authService.signUpWithEmailAndPassword(emailController.text, passwordController.text,usernameController.text);
    }catch (e){
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

                  //create account message
                  const SizedBox(height: 25),
                  const Text(
                    "Let's create an account for you!",
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

                  //username text field
                  MyTextField(
                      controller: usernameController,
                      hintText: "Username",
                      obscureText: false
                  ),

                  const SizedBox(height: 10),

                  // password text field
                  MyTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // confirm password text field
                  MyTextField(
                    controller: confirmpasswordController,
                    hintText: "Confirm Password",
                    obscureText: true,
                  ),

                  const SizedBox(height: 25),

                  //sign in button
                  MyButton(onTap: signUp, text: "Sign Up"),

                  const SizedBox(height: 50),

                  //not a member?Sign up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already a Member?"),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          "Login Now",
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