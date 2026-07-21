import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  DateTime? selectedDate;

  Future<void> pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime(2020),

      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
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
                keyboardType: TextInputType.number,

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

              DropdownButtonFormField<String>(
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

                items: ["Food", "Transport", "Shopping", "Bills", "Other"].map((
                  category,
                ) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),

                onChanged: (value) {},
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
              TextField(
                readOnly: true,

                decoration: InputDecoration(
                  hintText: "Select Date",

                  suffixIcon: Icon(Icons.calendar_today, color: primaryColor),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                ),
              ),

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

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,

                child: ElevatedButton(
                  onPressed: () {},

                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,

                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: const Text(
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
