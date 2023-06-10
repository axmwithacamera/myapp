import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/home.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? nameErrorText;
  String? phoneNumberErrorText;
  String? emailErrorText;
  String? passwordErrorText;
  String? confirmPasswordErrorText;

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
              Color.fromARGB(255, 84, 221, 255),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: 'Enter your name eg: Ahmed Mohamed',
                  hintStyle: const TextStyle(color: Colors.black45),
                  errorText: nameErrorText,
                ),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 10),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Phone Number',
                  hintText: 'Enter your mobile number',
                  hintStyle: const TextStyle(color: Colors.black45),
                  errorText: phoneNumberErrorText,
                ),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 10),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Email',
                  hintText: 'Enter valid email id as abc@gmail.com',
                  hintStyle: const TextStyle(color: Colors.black45),
                  errorText: emailErrorText,
                ),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 10),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  hintStyle: const TextStyle(color: Colors.black45),
                  errorText: passwordErrorText,
                ),
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 10),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Confirm Password',
                  hintText: 'Enter your password',
                  hintStyle: const TextStyle(color: Colors.black45),
                  errorText: confirmPasswordErrorText,
                ),
              ),
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
                onPressed: () async {
                  setState(() {
                    nameErrorText = null;
                    phoneNumberErrorText = null;
                    emailErrorText = null;
                    passwordErrorText = null;
                    confirmPasswordErrorText = null;
                  });

                  if (_validateFields()) {
                    try {
                      // Create the user in Firebase Authentication
                      UserCredential userCredential =
                          await _auth.createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      // Get the created user's UID
                      String uid = userCredential.user!.uid;

                      // Store additional user data in Firestore
                      await _firestore.collection('users').doc(uid).set({
                        'name': nameController.text,
                        'phoneNumber': phoneNumberController.text,
                        'admin': false,
                      });

                      // Navigate to the home screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Home()),
                      );
                    } catch (e) {
                      print('Error creating user: $e');
                      showDialog(
                        context: context,
                        builder: (BuildContext dialogContext) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                'An error occurred during signup. Please try again.'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(dialogContext).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                child: const Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                );
                debugPrint("pressed Back to login");
              },
              child: const Text(
                'Have an account? Back to login',
                style: TextStyle(
                    color: Color.fromARGB(255, 2, 32, 36), fontSize: 13.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateFields() {
    bool isValid = true;

    if (nameController.text.isEmpty) {
      setState(() {
        nameErrorText = 'Please enter your name';
      });
      isValid = false;
    }

    if (phoneNumberController.text.isEmpty) {
      setState(() {
        phoneNumberErrorText = 'Please enter your phone number';
      });
      isValid = false;
    } else if (!isNumeric(phoneNumberController.text)) {
      setState(() {
        phoneNumberErrorText = 'Phone number should contain only numbers';
      });
      isValid = false;
    }

    if (emailController.text.isEmpty) {
      setState(() {
        emailErrorText = 'Please enter your email';
      });
      isValid = false;
    } else if (!isValidEmail(emailController.text)) {
      setState(() {
        emailErrorText = 'Please enter a valid email';
      });
      isValid = false;
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordErrorText = 'Please enter a password';
      });
      isValid = false;
    }

    if (confirmPasswordController.text.isEmpty) {
      setState(() {
        confirmPasswordErrorText = 'Please confirm your password';
      });
      isValid = false;
    } else if (confirmPasswordController.text != passwordController.text) {
      setState(() {
        confirmPasswordErrorText = 'Passwords do not match';
      });
      isValid = false;
    }

    return isValid;
  }

  bool isNumeric(String value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  bool isValidEmail(String value) {
    // Email validation logic
    // You can use a regular expression or any other validation method here
    // For simplicity, we will check if it contains '@' and '.'
    return value.contains('@') && value.contains('.');
  }
}
