import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:flutter_application_1/views/edit_expense.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseListScreen> {
  final store = GetStorage();

  List<Map<String, dynamic>> expenses = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    getExpenses();
  }

  Future<void> getExpenses() async {
    final userID = store.read("userID");

    print("EXPENSE LIST USER ID: $userID");

    if (userID == null) {
      setState(() {
        isLoading = false;
      });

      return;
    }

    try {
      var response = await http.post(
        Uri.parse('http://localhost/ACS314PROJECT/get_expenses.php'),
        body: {'user_ID': userID.toString()},
      );

      print("GET EXPENSES RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['success'] == 1) {
          setState(() {
            expenses = List<Map<String, dynamic>>.from(responseData['data']);

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
      print("GET EXPENSES ERROR: $e");

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteExpense(dynamic expenseID) async {
    final userID = store.read("userID");

    if (userID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User ID not found. Please login again.")),
      );

      return;
    }

    try {
      var response = await http.post(
        Uri.parse('http://localhost/ACS314PROJECT/delete_expense.php'),

        body: {
          'user_ID': userID.toString(),
          'expense_id': expenseID.toString(),
        },
      );

      print("DELETE EXPENSE RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['success'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Expense deleted successfully")),
          );

          // Refresh expense list
          getExpenses();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                responseData['message'] ?? "Failed to delete expense",
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Server error. Please try again.")),
        );
      }
    } catch (e) {
      print("DELETE EXPENSE ERROR: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not delete expense")));
    }
  }

  Future<void> showDeleteConfirmation(
    dynamic expenseID,
    String category,
    String amount,
  ) async {
    bool? confirm = await showDialog<bool>(
      context: context,

      builder: (context) {
        return AlertDialog(
          title: const Text("Delete Expense?"),

          content: Text(
            "Are you sure you want to delete your "
            "$category expense of KES $amount?",
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: expenseColor,
                foregroundColor: Colors.white,
              ),

              child: const Text("Delete"),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      deleteExpense(expenseID);
    }
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

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);

    return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text("Expenses"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Your Expenses",

              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),

            const SizedBox(height: 15),

            // Loading
            if (isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            // No expenses
            else if (expenses.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    "You haven't added any expenses yet.",
                    style: TextStyle(fontSize: 16, color: secondaryText),
                  ),
                ),
              )
            // Display expenses
            else
              Expanded(
                child: RefreshIndicator(
                  onRefresh: getExpenses,

                  child: ListView.builder(
                    itemCount: expenses.length,

                    itemBuilder: (context, index) {
                      final expense = expenses[index];

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
                          contentPadding: const EdgeInsets.all(10),

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

                          subtitle: Text("$description\n${formatDate(date)}"),

                          isThreeLine: true,

                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              Text(
                                "- KES $amount",

                                style: TextStyle(
                                  color: expenseColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  //Edit Expense Button
                                  if (value == "edit") {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditExpenseScreen(expense: expense),
                                      ),
                                    ).then((updated) {
                                      if (updated == true) {
                                        getExpenses();
                                      }
                                    });
                                  }

                                  //Delete Expense Button
                                  if (value == "delete") {
                                    showDeleteConfirmation(
                                      expense['expense_id'],
                                      category,
                                      amount,
                                    );
                                  }
                                },

                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: "edit",
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit),
                                        SizedBox(width: 10),
                                        Text("Edit"),
                                      ],
                                    ),
                                  ),

                                  const PopupMenuItem(
                                    value: "delete",
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete),
                                        SizedBox(width: 10),
                                        Text("Delete"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
