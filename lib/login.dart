import 'package:flutter/material.dart';
import 'package:myapp/home.dart';
import 'package:myapp/components/my_textfield.dart';
import 'package:myapp/signup.dart';

import 'admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String? emailErrorText;
  String? passwordErrorText;

  void _login() async {
    final String email = usernameController.text.trim();
    final String password = passwordController.text.trim();

    BuildContext context = this.context; // Store the BuildContext in a variable

    if (!_validateFields()) {
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      bool isAdmin = userSnapshot['admin'];

      if (isAdmin) {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const Admin()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const Home()));
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred during login.';
      print('Error logging in: $e');
      if (e.code == 'user-not-found') {
        setState(() {
          emailErrorText = 'User not found';
          passwordErrorText = null;
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          emailErrorText = null;
          passwordErrorText = 'Incorrect password';
        });
      }
    } catch (e) {
      print('Error logging in: $e');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('An error occurred during login.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  bool _validateFields() {
    bool isValid = true;

    if (usernameController.text.isEmpty) {
      setState(() {
        emailErrorText = 'Please enter your email';
      });
      isValid = false;
    } else if (!isValidEmail(usernameController.text)) {
      setState(() {
        emailErrorText = 'Please enter a valid email';
      });
      isValid = false;
    } else {
      setState(() {
        emailErrorText = null;
      });
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordErrorText = 'Please enter a password';
      });
      isValid = false;
    } else {
      setState(() {
        passwordErrorText = null;
      });
    }

    return isValid;
  }

  bool isValidEmail(String value) {
    // Email validation logic
    // You can use a regular expression or any other validation method here
    // For simplicity, we will check if it contains '@' and '.'
    return value.contains('@') && value.contains('.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(5, 100, 92, 1),
      body: Container(
        padding: const EdgeInsets.all(30),
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-1.0, -1.0),
            end: Alignment(-1.0, 1.0),
            colors: [
              Color.fromARGB(255, 248, 248, 248),
              Color.fromARGB(255, 155, 255, 252),
              Color.fromARGB(255, 84, 221, 255)
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MyTextField(
              controller: usernameController,
              labelText: 'Email',
              hintText: 'Enter valid email id as abc@gmail.com',
              obscureText: false,
              errorText: emailErrorText,
            ),
            const Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 10),
            ),
            MyTextField(
              controller: passwordController,
              labelText: 'Password',
              hintText: 'Enter your password',
              obscureText: true,
              errorText: passwordErrorText,
            ),
            const Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 30, bottom: 30),
            ),
            Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 2, 91, 104),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: _login,
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const Signup()));
              },
              child: const Text(
                'New User? Create Account',
                style: TextStyle(
                    color: Color.fromARGB(255, 2, 32, 36), fontSize: 13.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
