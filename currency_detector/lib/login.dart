import 'package:flutter/material.dart';

import 'auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Currency Guru"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/page.png'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5),
                  BlendMode.dstATop), // Semi-transparent overlay
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
                    "Welcome to Currency Guru",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Changed text color
                      shadows: [
                        Shadow(color: Colors.black, offset: Offset(2.0, 2.0))
                      ], // Added text shadow
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Your personal currency assistant",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black), // Changed text color
                  ),
                  const SizedBox(height: 30),
                ],
              ),
              Column(
                children: [
                  const Text("Sign in with",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.white)), // Changed text color
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      Auth().signInWithGoogle();
                    },
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(
                            width: 30,
                            image: AssetImage('assets/google.png'),
                          ),
                          const SizedBox(width: 10),
                          const Text("Google",
                              style: TextStyle(
                                  color: Colors.black)), // Changed text color
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Image(
                            width: 30,
                            image: AssetImage('assets/apple.png'),
                          ),
                          const SizedBox(width: 10),
                          const Text("Apple"),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
