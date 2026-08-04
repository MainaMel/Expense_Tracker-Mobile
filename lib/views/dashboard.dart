import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text("Dashboard"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),

              SizedBox(height: 8),

              Text(
                "Track your expenses and stay on budget.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 25),

              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Balance",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),

                      SizedBox(height: 10),

                      Text(
                        "KES 0.00",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Icon(Icons.arrow_downward, color: incomeColor),

                            SizedBox(height: 10),

                            Text(
                              "Income",
                              style: TextStyle(
                                fontSize: 16,
                                color: secondaryText,
                              ),
                            ),

                            SizedBox(height: 5),
                            Text(
                              "KES 0.00",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 15),

                  Expanded(
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: Padding(
                        padding: EdgeInsets.all(15),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Icon(Icons.arrow_upward, color: expenseColor),

                            SizedBox(height: 10),

                            Text(
                              "Expenses",
                              style: TextStyle(
                                fontSize: 16,
                                color: secondaryText,
                              ),
                            ),

                            SizedBox(height: 5),

                            Text(
                              "KES 0.00",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 25),

              Text(
                "Recent Transcations",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),
              SizedBox(height: 15),

              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),

                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: expenseColor,

                    child: Icon(Icons.fastfood, color: expenseColor),
                  ),

                  title: Text(
                    "Food",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text(
                    "Today",
                    style: TextStyle(color: secondaryText),
                  ),

                  trailing: Text(
                    "- KES 500",
                    style: TextStyle(
                      color: expenseColor,
                      fontWeight: FontWeight.bold,
                    ),
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
