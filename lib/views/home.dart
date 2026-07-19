import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/views/add_expense.dart';
import 'package:flutter_application_1/views/dashboard.dart';
import 'package:flutter_application_1/views/expense_list.dart';
import 'package:flutter_application_1/views/reports.dart';

int position = 0;
var screens = [
  DashboardScreen(),
  AddExpenseScreen(),
  ExpenseListScreen(),
  ReportsScreen(),
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
          Icon(Icons.home, size: 30),
          Icon(Icons.person, size: 30),
          Icon(Icons.list, size: 30),
          Icon(Icons.settings, size: 30),
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
