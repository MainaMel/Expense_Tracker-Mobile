import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  final store = GetStorage();

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> changePassword() async {
    final userID = store.read("userID");

    if (userID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User ID not found. Please login again.")),
      );
      return;
    }

    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all password fields.")),
      );
      return;
    }

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("New passwords do not match.")));
      return;
    }

    try {
      var response = await http.post(
        Uri.parse('http://localhost/ACS314PROJECT/change_password.php'),
        body: {
          'user_ID': userID.toString(),
          'current_password': currentPassword,
          'new_password': newPassword,
        },
      );

      print("CHANGE PASSWORD RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['success'] == 1) {
          Navigator.pop(context);

          currentPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Password changed successfully.")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                responseData['message'] ?? "Failed to change password.",
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server error. Please try again.")),
        );
      }
    } catch (e) {
      print("CHANGE PASSWORD ERROR: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Could not change password.")));
    }
  }

  void showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Change Password"),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Current Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "New Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Confirm New Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                currentPasswordController.clear();
                newPasswordController.clear();
                confirmPasswordController.clear();
              },
              child: Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text("Change Password"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,

        foregroundColor: Colors.white,

        title: Text("Settings"),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Change Password Card
              Card(
                elevation: 3,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                child: ListTile(
                  leading: Icon(Icons.lock, color: primaryColor),

                  title: Text("Change Password"),

                  subtitle: Text("Update your password"),

                  trailing: Icon(Icons.arrow_forward_ios, size: 16),

                  onTap: () {
                    showChangePasswordDialog();
                  },
                ),
              ),

              SizedBox(height: 15),

              // Dark Mode Card
              Card(
                elevation: 3,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                child: ListTile(
                  leading: Icon(Icons.dark_mode, color: primaryColor),

                  title: Text("Dark Mode"),

                  subtitle: Text("Change app appearance"),

                  trailing: Switch(
                    value: isDarkMode,

                    activeColor: primaryColor,

                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                      });
                    },
                  ),
                ),
              ),

              SizedBox(height: 15),

              // About Wise Wallet Card
              Card(
                elevation: 3,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                child: ListTile(
                  leading: Icon(Icons.info, color: primaryColor),

                  title: Text("About Wise Wallet"),

                  subtitle: Text("Manage your finances wisely"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
