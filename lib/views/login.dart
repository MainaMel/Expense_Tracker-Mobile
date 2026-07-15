import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'package:flutter_application_1/configs/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Tracker'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings button press
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(35, 10, 35, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset('/logo.jpg', width: 180, height: 150)],
            ),
            SizedBox(height: 30),
            Text(
              "Username:",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),

            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            SizedBox(height: 20),
            Text(
              "Password:",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),

            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    Get.toNamed("/home");
                    // Handle login button press
                  },
                  color: primaryColor,
                  textColor: Colors.white,
                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  height: 45,
                  minWidth: 100,
                ),
              ],
            ),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // This code handles the navigation
                    Get.toNamed("/register");
                  },
                  child: Text(
                    "Not Registered? Sign Up",
                    style: TextStyle(
                      color: secondaryColor,
                      fontWeight: FontWeight
                          .bold, // Optional: makes it look more like a link
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  "Forgot Password? Reset",
                  style: TextStyle(
                    color: secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
