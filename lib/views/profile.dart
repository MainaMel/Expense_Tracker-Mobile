import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController(
    text: "Helena Margo",
  );

  final TextEditingController emailController = TextEditingController(
    text: "helenamargo@gmail.com",
  );

  final TextEditingController phoneController = TextEditingController(
    text: "0712345678",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,

        foregroundColor: Colors.white,

        title: Text("Profile"),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // Profile picture
              Center(
                child: CircleAvatar(
                  radius: 45,

                  backgroundColor: primaryColor,

                  child: Icon(Icons.person, size: 50, color: Colors.white),
                ),
              ),

              SizedBox(height: 25),

              Text(
                "Personal Details",

                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 15),

              // Name Field
              TextField(
                controller: nameController,

                decoration: InputDecoration(
                  labelText: "Full Name",

                  prefixIcon: Icon(Icons.person),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Email Field
              TextField(
                controller: emailController,

                decoration: InputDecoration(
                  labelText: "Email",

                  prefixIcon: Icon(Icons.email),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 15),

              // Phone Field
              TextField(
                controller: phoneController,

                keyboardType: TextInputType.phone,

                decoration: InputDecoration(
                  labelText: "Phone Number",

                  prefixIcon: Icon(Icons.phone),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Save Button
              SizedBox(
                width: double.infinity,

                height: 50,

                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Profile updated successfully")),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,

                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: Text(
                    "Save Changes",

                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Logout Button
              SizedBox(
                width: double.infinity,

                height: 50,

                child: ElevatedButton(
                  onPressed: () {
                    // Logout logic will be connected later

                    Navigator.pop(context);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: expenseColor,

                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: Text(
                    "Logout",

                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
