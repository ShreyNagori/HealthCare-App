import 'package:finalapp/reusable_widgets/reusable_widget.dart';
import 'package:finalapp/screens/home_screen.dart';
import 'package:finalapp/screens/signin_screen.dart';
import 'package:finalapp/utils/color_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _fullnameTextController = TextEditingController();
  TextEditingController _ageTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            hexStringToColor("FFFFFF"),
            hexStringToColor("E2F8FF"),
            hexStringToColor("4DCAF1"),
            hexStringToColor("C6E9F4")
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 100, 20, 0),
            child: Column(children: <Widget>[
              logoWidget("assets/images/healthcare2.jpg"),
              const SizedBox(
                height: 15,
              ),
              reusableTextField("Enter Full Name", Icons.person_outline, false,
                  _fullnameTextController),
              const SizedBox(
                height: 15,
              ),
              reusableTextField(
                  "Age", Icons.person_outline, false, _ageTextController),
              const SizedBox(
                height: 15,
              ),
              reusableTextField("Enter Email Id", Icons.person_outline, false,
                  _emailTextController),
              const SizedBox(
                height: 15,
              ),
              reusableTextField("Enter Password", Icons.person_outline, true,
                  _passwordTextController),
              const SizedBox(
                height: 15,
              ),
              signInSignUpButton(context, false, () {
                FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text)
                    .then((value) {
                  print("Created New Account");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                }).onError((error, stackTrace) {
                  print("Error ${error.toString()}");
                });
              })
            ]),
          ))),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Already a user?", style: TextStyle(color: Colors.blue)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignInScreen()));
          },
          child: const Text(
            " Sign In",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
