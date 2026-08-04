import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/views/settings.dart';
import 'package:flutter_application_1/views/add_expense.dart';
import 'package:flutter_application_1/views/dashboard.dart';
import 'package:flutter_application_1/views/profile.dart';
import 'package:flutter_application_1/views/expense_list.dart';

int position = 0;
var screens = [
  AddExpenseScreen(),
  ExpenseListScreen(),
  DashboardScreen(),
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
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: secondaryColor,
        items: <Widget>[
          Icon(Icons.add, size: 10),
          Icon(Icons.view_column, size: 25),
          Icon(Icons.dashboard, size: 25),
          Icon(Icons.person, size: 25),
          Icon(Icons.settings, size: 25),
          // Icon(Icons.settings, size: 30),
        ],
        onTap: (index) {
          setState(() {
            position = index;
          });
          //Handle button tap
        },
      ),
      body: screens[position],
    );
  }
}
