import 'dart:convert';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/views/settings.dart';
import 'package:flutter_application_1/views/add_expense.dart';
import 'package:flutter_application_1/views/dashboard.dart';
import 'package:flutter_application_1/views/profile.dart';
import 'package:flutter_application_1/views/expense_list.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

var store = GetStorage();

bool isLoading = false;

var userList = [];

int position = 0;
var screens = [
  DashboardScreen(),
  AddExpenseScreen(),
  ExpenseListScreen(),
  ProfileScreen(),
  SettingsScreen(),
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[position],

      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: secondaryColor,
        items: <Widget>[
          Icon(Icons.dashboard, size: 25),
          Icon(Icons.add, size: 25),
          Icon(Icons.view_column, size: 25),
          Icon(Icons.person, size: 25),
          Icon(Icons.settings, size: 25),
        ],
        onTap: (index) {
          setState(() {
            position = index;
          });
          //Handle button tap
        },
      ),
    );
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    var response = await http.get(
      Uri.parse("http://localhost/ACS314PROJECT/readusers.php"),
    );

    var serverResponse = jsonDecode(response.body);

    setState(() {
      userList = serverResponse;
      isLoading = false;
    });
  }
}
