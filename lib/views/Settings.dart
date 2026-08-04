import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,

        foregroundColor: Colors.white,

        title: const Text("Settings"),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),

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
                  leading: const Icon(Icons.lock, color: primaryColor),

                  title: const Text("Change Password"),

                  subtitle: const Text("Update your password"),

                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                  onTap: () {
                    // Navigate to change password screen later
                  },
                ),
              ),

              const SizedBox(height: 15),

              // Dark Mode Card
              Card(
                elevation: 3,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                child: ListTile(
                  leading: const Icon(Icons.dark_mode, color: primaryColor),

                  title: const Text("Dark Mode"),

                  subtitle: const Text("Change app appearance"),

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

              const SizedBox(height: 15),

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
