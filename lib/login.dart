import 'package:flutter/material.dart';
import 'package:myapp/home.dart';
import 'package:myapp/components/my_textfield.dart';
import 'package:myapp/signup.dart';

import 'admin.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void _login() {
    final String email = usernameController.text.trim();
    final String password = passwordController.text.trim();

    // Check if the provided email and password match the credentials
    if (email == 'admin@admin.com' && password == 'admin123') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const Admin()));
    } else if (email == 'user@user.com' && password == 'user123') {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const Home()));
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Incorrect Information'),
          content:
              const Text('The email or password you entered is incorrect.'),
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
