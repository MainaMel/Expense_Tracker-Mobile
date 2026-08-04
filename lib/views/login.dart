import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'package:flutter_application_1/configs/colors.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();

var store = GetStorage();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    emailController.text = store.read("email") ?? "";
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Wise Wallet'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.settings),
        //     onPressed: () {
        //       // Handle settings button press
        //     },
        //   ),
        // ],
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(35, 10, 35, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset('/logo.png', width: 180, height: 150)],
            ),

            // Welcome back part
            SizedBox(height: 10),
            Center(
              child: Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),

            // SizedBox(height: 8),
            Center(
              child: Text(
                "Sign in to continue managing your finances.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: secondaryText),
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Email:",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),

            TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: primaryColor, width: 2),
                ),
                prefixIcon: Icon(Icons.person),
              ),
            ),

            SizedBox(height: 15),

            Text(
              "Password:",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),

            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),

                // enabledBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(12),
                //   borderSide: BorderSide(color: Colors.grey.shade400),
                // ),
                // focusedBorder: OutlineInputBorder(
                //   borderRadius: BorderRadius.circular(12),
                //   borderSide: BorderSide(color: primaryColor, width: 2),
                // ),
                prefixIcon: Icon(Icons.lock),
              ),
            ),

            SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () async {
                    var response = await http.get(
                      Uri.parse(
                        "http://localhost/ACS314PROJECT/login.php?email=${emailController.text}&password=${passwordController.text}",
                      ),
                    );
                    print(response.body);
                    var responseBody = jsonDecode(response.body);

                    int LoggedIn = responseBody['success'];
                    // Handle login button press

                    if (LoggedIn == 1) {
                      store.write("email", emailController.text);

                      store.write("userID", responseBody['data'][0]['id']);
                      Get.toNamed("/home");
                    } else {
                      Get.snackbar("Error", "Invalid email or password");
                    }
                  },
                  color: primaryColor,
                  textColor: Colors.white,
                  height: 45,
                  minWidth: 200,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Text(
                    'Login',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
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
