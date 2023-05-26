import 'package:flutter/material.dart';
import 'package:myapp/home.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //     appBar: AppBar(
      //   title: const Text("Signup"),
      //   centerTitle: true,
      //   backgroundColor: Colors.amber,
      // )

      backgroundColor: const Color.fromRGBO(5, 100, 92, 1),
      // appBar: AppBar(
      //   backgroundColor: Colors.black,
      //   title: const Text(
      //     'AppBar',
      //     style: TextStyle(color: Colors.white),
      //   ),
      // ),
      // body: Column(children: [Text("what"), col_2(), hhhhghh()]),
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
            //Name field
            const Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    hintText: 'Enter your name eg: Ahmed Mohamed',
                    hintStyle: TextStyle(color: Colors.black45)),
              ),
            ),

            const Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 10),
            ),
            //Phone number field
            const Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                    hintText: 'Enter your mobile number',
                    hintStyle: TextStyle(color: Colors.black45)),
              ),
            ),

            const Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 10),
            ),

            //email field
            const Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com',
                    hintStyle: TextStyle(color: Colors.black45)),
              ),
            ),

            const Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 10),
            ),

            //email field
            const Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: Colors.black45)),
              ),
            ),

            const Padding(
              padding:
                  EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 10),
            ),

            //Password field
            const Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: Colors.black45)),
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
                  borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  setState(() {});
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => const Home()));
                  debugPrint("pressed Sign Up");
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
                    context, MaterialPageRoute(builder: (_) => const Login()));
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
}
