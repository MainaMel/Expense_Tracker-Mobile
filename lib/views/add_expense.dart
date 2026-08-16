import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  List<Map<String, dynamic>> categories = [];

  final store = GetStorage();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  int? selectedCategory;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  Future<void> getCategories() async {
    try {
      var response = await http.get(
        Uri.parse('http://localhost/ACS314PROJECT/get_categories.php'),
      );

      print("CATEGORIES RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['success'] == 1) {
          setState(() {
            categories = List<Map<String, dynamic>>.from(responseData['data']);
          });
        }
      }
    } catch (e) {
      print("GET CATEGORIES ERROR: $e");
    }
  }

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime(2020),

      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> saveExpense() async {
    print("SAVE EXPENSE BUTTON CLICKED");
    // Get logged-in user's ID
    final userID = store.read("userID");

    // Check user ID
    if (userID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User ID not found. Please login again.")),
      );
      return;
    }

    // Check amount
    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter a valid amount greater than 0.")),
      );
      return;
    }

    // Check category
    if (selectedCategory == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select a category.")));
      return;
    }

    // Check date
    if (selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please select a date.")));
      return;
    }

    try {
      // Format date as YYYY-MM-DD
      String formattedDate =
          "${selectedDate!.year}-"
          "${selectedDate!.month.toString().padLeft(2, '0')}-"
          "${selectedDate!.day.toString().padLeft(2, '0')}";

      // Send data to PHP API
      var response = await http.post(
        Uri.parse('http://localhost/ACS314PROJECT/add_expense.php'),
        body: {
          'user_ID': userID.toString(),
          'category': selectedCategory.toString(),
          'amount': amount.toString(),
          'description': descriptionController.text.trim(),
          'expense_date': formattedDate,
        },
      );

      print("ADD EXPENSE RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['success'] == 1) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Expense added successfully")));

          // Clear the form
          amountController.clear();
          descriptionController.clear();

          setState(() {
            selectedCategory = null;
            selectedDate = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseData['message'] ?? "Failed to add expense"),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Server error. Please try again.")),
        );
      }
    } catch (e) {
      print("ADD EXPENSE ERROR: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Could not add expense")));
    }
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: Text("Add Expense"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Amount",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),

              SizedBox(height: 8),

              TextField(
                controller: amountController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),

                decoration: InputDecoration(
                  hintText: "Enter Amount",

                  // prefixText: "KES",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Text(
                "Category",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),

              SizedBox(height: 8),

              DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  hintText: "Select category",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),

                items: categories.map((category) {
                  return DropdownMenuItem<int>(
                    value: int.parse(category["category_id"].toString()),
                    child: Text(category["category_name"].toString()),
                  );
                }).toList(),

                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),

              //DATE
              SizedBox(height: 20),

              Text(
                "Date",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),

              SizedBox(height: 8),

              InkWell(
                onTap: pickDate,

                child: Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),

                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),

                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        selectedDate == null
                            ? "Select Date"
                            : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",

                        style: TextStyle(color: secondaryText),
                      ),

                      Icon(Icons.calendar_today, color: primaryColor),
                    ],
                  ),
                ),
              ),

              // Date TextField ends here
              // TextField(
              //   readOnly: true,

              //   decoration: InputDecoration(
              //     hintText: "Select Date",

              //     suffixIcon: Icon(Icons.calendar_today, color: primaryColor),

              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),

              //     enabledBorder: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(12),
              //       borderSide: BorderSide(color: Colors.grey.shade400),
              //     ),
              //   ),
              // ),

              // Description section starts here
              SizedBox(height: 20),

              Text(
                "Description",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),

              SizedBox(height: 8),

              TextField(
                controller: descriptionController,
                maxLines: 3,

                decoration: InputDecoration(
                  hintText: "Enter description",

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),

                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),

                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
              ),

              SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: saveExpense,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,

                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: Text(
                    "Save Expense",

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
