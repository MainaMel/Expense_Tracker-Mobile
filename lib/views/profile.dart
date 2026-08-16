import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final store = GetStorage();
  void checkStorage() {
    print("USER ID: ${store.read("userID")}");
    print("EMAIL: ${store.read("email")}");
    print("FIRST NAME: ${store.read("first_name")}");
    print("LAST NAME: ${store.read("last_name")}");
    print("PHONE: ${store.read("phone_number")}");
    print("PROFILE PIC: ${store.read("profile_pic")}");
  }

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  // XFile? selectedImage;
  Uint8List? imageBytes;
  String? profilePic;

  @override
  void initState() {
    super.initState();

    checkStorage();
    profilePic = store.read("profile_pic");
    print(
      "PROFILE IMAGE URL: http://localhost/ACS314PROJECT/profile_pics/$profilePic",
    );

    nameController = TextEditingController(
      text: "${store.read("first_name") ?? ""} ${store.read("last_name") ?? ""}"
          .trim(),
    );

    emailController = TextEditingController(text: store.read("email") ?? "");

    phoneController = TextEditingController(
      text: store.read("phone_number") ?? "",
    );
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image == null) {
      return;
    }

    final bytes = await image.readAsBytes();

    setState(() {
      // selectedImage = image;
      imageBytes = bytes;
    });

    final userID = store.read("userID");

    if (userID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User ID not found. Please login again.")),
      );
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost/ACS314PROJECT/update_profile_pic.php'),
      );

      request.fields['userID'] = userID.toString();

      request.files.add(
        http.MultipartFile.fromBytes(
          'profile_pic',
          bytes,
          filename: image.name,
        ),
      );

      var streamedResponse = await request.send();

      var response = await http.Response.fromStream(streamedResponse);

      print(response.body);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['success'] == 1) {
          setState(() {
            profilePic = responseData['profile_pic'];
          });

          store.write("profile_pic", profilePic);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Profile picture updated successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                responseData['message'] ?? "Failed to update profile picture",
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
      print("UPLOAD ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not upload profile picture")),
      );
    }
  }

  Future<void> updateProfile() async {
    final userID = store.read("userID");

    if (userID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User ID not found. Please login again.")),
      );
      return;
    }

    // Separating the full name into f_name and l_name
    List<String> names = nameController.text.trim().split(" ");

    String firstName = names.isNotEmpty ? names.first : "";
    String lastName = names.length > 1 ? names.sublist(1).join(" ") : "";

    try {
      var response = await http.post(
        Uri.parse('http://localhost/ACS314PROJECT/edit_profile.php'),
        body: {
          'userID': userID.toString(),
          'first_name': firstName,
          'last_name': lastName,
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
        },
      );

      print("UPDATE PROFILE RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['success'] == 1) {
          // Update GetStorage with the new information
          store.write("first_name", firstName);
          store.write("last_name", lastName);
          store.write("email", emailController.text.trim());
          store.write("phone_number", phoneController.text.trim());

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Profile updated successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                responseData['message'] ?? "Failed to update profile",
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
      print("UPDATE PROFILE ERROR: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Could not update profile")));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

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
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: primaryColor,

                      backgroundImage: imageBytes != null
                          ? MemoryImage(imageBytes!)
                          : (profilePic != null && profilePic!.isNotEmpty)
                          ? NetworkImage(
                              "http://localhost/ACS314PROJECT/profile_pics/$profilePic",
                            )
                          : null,

                      child:
                          imageBytes == null &&
                              (profilePic == null || profilePic!.isEmpty)
                          ? Icon(Icons.person, size: 50, color: Colors.white)
                          : null,
                    ),

                    SizedBox(height: 10),

                    TextButton.icon(
                      onPressed: pickImage,
                      icon: Icon(Icons.camera_alt, color: primaryColor),
                      label: Text(
                        "Change Profile Picture",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
                  onPressed: updateProfile,

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
                    store.remove("userID");
                    store.remove("email");
                    store.remove("first_name");
                    store.remove("last_name");
                    store.remove("phone_number");
                    store.remove("profile_pic");

                    Get.offAllNamed("/");
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
