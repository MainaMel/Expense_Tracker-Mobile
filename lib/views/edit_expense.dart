import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class EditExpenseScreen extends StatefulWidget {
  final Map<String, dynamic> expense;

  const EditExpenseScreen({super.key, required this.expense});

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final store = GetStorage();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  List<Map<String, dynamic>> categories = [];

  int? selectedCategory;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();

    // Fill the form with the existing expense
    amountController.text = widget.expense['amount']?.toString() ?? '';

    descriptionController.text =
        widget.expense['description']?.toString() ?? '';

    selectedCategory = int.tryParse(widget.expense['category'].toString());

    selectedDate = DateTime.tryParse(widget.expense['expense_date'].toString());

    getCategories();
  }

  Future<void> getCategories() async {
    try {
      var response = await http.get(
        Uri.parse('http://localhost/ACS314PROJECT/get_categories.php'),
      );

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
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> updateExpense() async {
    final userID = store.read("userID");

    if (userID == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User ID not found. Please login again.")),
      );
      return;
    }

    final amount = double.tryParse(amountController.text.trim());

    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid amount.")),
      );
      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a category.")),
      );
      return;
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a date.")));
      return;
    }

    try {
      String formattedDate =
          "${selectedDate!.year}-"
          "${selectedDate!.month.toString().padLeft(2, '0')}-"
          "${selectedDate!.day.toString().padLeft(2, '0')}";

      var response = await http.post(
        Uri.parse('http://localhost/ACS314PROJECT/update_expense.php'),
        body: {
          'expense_id': widget.expense['expense_id'].toString(),

          'user_ID': userID.toString(),

          'category': selectedCategory.toString(),

          'amount': amount.toString(),

          'description': descriptionController.text.trim(),

          'expense_date': formattedDate,
        },
      );

      print("UPDATE EXPENSE RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);

        if (responseData['success'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Expense updated successfully")),
          );

          // Return to expense list
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                responseData['message'] ?? "Failed to update expense",
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
      print("UPDATE EXPENSE ERROR: $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Could not update expense")));
    }
  }

  String displayDate() {
    if (selectedDate == null) {
      return "Select Date";
    }

    return "${selectedDate!.day}/"
        "${selectedDate!.month}/"
        "${selectedDate!.year}";
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
        title: const Text("Edit Expense"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Amount",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: amountController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),

              decoration: InputDecoration(
                hintText: "Enter Amount",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Category",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<int>(
              value: selectedCategory,

              decoration: InputDecoration(
                hintText: "Select category",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              items: categories.map((category) {
                return DropdownMenuItem<int>(
                  value: int.parse(category['category_id'].toString()),

                  child: Text(category['category_name'].toString()),
                );
              }).toList(),

              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Date",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),

            const SizedBox(height: 8),

            InkWell(
              onTap: pickDate,

              child: Container(
                width: double.infinity,

                padding: const EdgeInsets.all(15),

                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),

                  borderRadius: BorderRadius.circular(12),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Text(
                      displayDate(),
                      style: const TextStyle(color: secondaryText),
                    ),

                    Icon(Icons.calendar_today, color: primaryColor),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: primaryText,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: descriptionController,
              maxLines: 3,

              decoration: InputDecoration(
                hintText: "Enter description",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: updateExpense,

                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),

                child: const Text(
                  "Update Expense",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
