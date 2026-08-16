import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final store = GetStorage();

  double totalExpenses = 0;
  double totalIncome = 0;
  double totalBalance = 0;
  double todayExpenses = 0;
  double monthlyExpenses = 0;

  bool isLoading = true;

  List<Map<String, dynamic>> recentExpenses = [];
  List<Map<String, dynamic>> expenseSummary = [];

  @override
  void initState() {
    super.initState();

    getDashboardSummary();
    getRecentExpenses();
    getTotalIncome();
    getExpenseSummary();
  }

  Future<void> getDashboardSummary() async {
    final userID = store.read("userID");

    print("DASHBOARD USER ID: $userID");

    if (userID == null) {
      setState(() {
        isLoading = false;
      });

      return;
    }

    try {
      var response = await http.post(
        Uri.parse('http://localhost/ACS314PROJECT/dashboard_summary.php'),
        body: {'user_ID': userID.toString()},
      );

      print("DASHBOARD RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['success'] == 1) {
          var data = responseData['data'];

          setState(() {
            totalExpenses =
                double.tryParse(data['total_expenses'].toString()) ?? 0;

            todayExpenses =
                double.tryParse(data['today_expenses'].toString()) ?? 0;

            monthlyExpenses =
                double.tryParse(data['monthly_expenses'].toString()) ?? 0;

            totalBalance = totalIncome - totalExpenses;

            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("DASHBOARD ERROR: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> getTotalIncome() async {
    final userID = store.read("userID");

    print("INCOME USER ID: $userID");

    if (userID == null) {
      return;
    }

    try {
      var response = await http.post(
        Uri.parse('http://localhost/ACS314PROJECT/get_income.php'),
        body: {'user_id': userID.toString()},
      );

      print("INCOME RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['success'] == 1) {
          var data = responseData['data'];

          setState(() {
            totalIncome = double.tryParse(data['total_income'].toString()) ?? 0;

            totalBalance = totalIncome - totalExpenses;
          });
        }
      }
    } catch (e) {
      print("GET INCOME ERROR: $e");
    }
  }

  Future<void> getRecentExpenses() async {
    final userID = store.read("userID");

    print("RECENT EXPENSES USER ID: $userID");

    if (userID == null) {
      return;
    }

    try {
      var response = await http.post(
        Uri.parse('http://localhost/ACS314PROJECT/get_expenses.php'),
        body: {'user_ID': userID.toString()},
      );

      print("RECENT EXPENSES RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['success'] == 1) {
          setState(() {
            recentExpenses = List<Map<String, dynamic>>.from(
              responseData['data'],
            );
          });
        }
      }
    } catch (e) {
      print("GET RECENT EXPENSES ERROR: $e");
    }
  }

  Future<void> getExpenseSummary() async {
    final userID = store.read("userID");

    print("EXPENSE SUMMARY USER ID: $userID");

    if (userID == null) {
      return;
    }

    try {
      var response = await http.post(
        Uri.parse('http://localhost/ACS314PROJECT/get_expense_summary.php'),
        body: {'user_ID': userID.toString()},
      );

      print("EXPENSE SUMMARY RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['success'] == 1) {
          setState(() {
            expenseSummary = List<Map<String, dynamic>>.from(
              responseData['data'],
            );
          });
        }
      }
    } catch (e) {
      print("GET EXPENSE SUMMARY ERROR: $e");
    }
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);

    return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
  }

  IconData getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case "food":
        return Icons.fastfood;

      case "transport":
        return Icons.directions_car;

      case "shopping":
        return Icons.shopping_cart;

      case "bills":
        return Icons.receipt_long;

      default:
        return Icons.category;
    }
  }

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
                        "KES ${totalBalance.toStringAsFixed(2)}",
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
                              "KES ${totalIncome.toStringAsFixed(2)}",
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
                              "KES ${totalExpenses.toStringAsFixed(2)}",
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

              if (recentExpenses.isEmpty)
                const Text(
                  "No recent transactions.",
                  style: TextStyle(color: secondaryText, fontSize: 16),
                )
              else
                Column(
                  children: recentExpenses.take(3).map((expense) {
                    String category =
                        expense['category_name']?.toString() ?? "Other";

                    String amount = expense['amount']?.toString() ?? "0.00";

                    String description =
                        expense['description']?.toString() ?? "";

                    String date = expense['expense_date']?.toString() ?? "";

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 15),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: expenseColor.withOpacity(0.1),

                          child: Icon(
                            getCategoryIcon(category),
                            color: expenseColor,
                          ),
                        ),

                        title: Text(
                          category,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        subtitle: Text(
                          "$description\n${formatDate(date)}",
                          style: const TextStyle(color: secondaryText),
                        ),

                        isThreeLine: true,

                        trailing: Text(
                          "- KES $amount",
                          style: TextStyle(
                            color: expenseColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

              SizedBox(height: 25),

              Text(
                "Expense Summary",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),

              SizedBox(height: 15),

              if (expenseSummary.isEmpty)
                const Text(
                  "No expense data available.",
                  style: TextStyle(color: secondaryText, fontSize: 16),
                )
              else
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: expenseSummary.map((expense) {
                        String category =
                            expense['category_name']?.toString() ?? "Other";

                        double amount =
                            double.tryParse(expense['total'].toString()) ?? 0;

                        double percentage = totalExpenses > 0
                            ? amount / totalExpenses
                            : 0;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    category,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    "KES ${amount.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              LinearProgressIndicator(
                                value: percentage,
                                minHeight: 8,
                                borderRadius: BorderRadius.circular(10),
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  primaryColor,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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
