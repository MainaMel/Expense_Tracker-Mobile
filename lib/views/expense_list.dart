import 'package:flutter/material.dart';
import 'package:flutter_application_1/configs/colors.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({super.key});

  @override
  State<ExpenseListScreen> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Text(
                "Your Expenses",

                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),

              SizedBox(height: 15),

              //expense card
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

                  subtitle: Text("Lunch at restaurant\n21 July 2026"),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Text(
                        "- KES 500",

                        style: TextStyle(
                          color: expenseColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: "edit",

                            child: Text("Edit"),
                          ),

                          const PopupMenuItem(
                            value: "delete",

                            child: Text("Delete"),
                          ),
                        ],
                        onSelected: (value) {
                          if (value == "edit") {
                            // edit logic later
                          } else if (value == "delete") {
                            // delete logic later
                          }
                        },
                      ),
                    ],
                  ),
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

                    child: Icon(Icons.directions_car, color: expenseColor),
                  ),

                  title: Text(
                    "Transport",

                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text("Bus fare\n20 July 2026"),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Text(
                        "- KES 200",

                        style: TextStyle(
                          color: expenseColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: "edit",
                            child: Text("Edit"),
                          ),

                          const PopupMenuItem(
                            value: "delete",
                            child: Text("Delete"),
                          ),
                        ],

                        onSelected: (value) {
                          if (value == "edit") {
                            // edit later
                          } else if (value == "delete") {
                            // delete later
                          }
                        },
                      ),
                    ],
                  ),
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

                    child: Icon(Icons.shopping_cart, color: expenseColor),
                  ),

                  title: Text(
                    "Shopping",

                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text("Clothes purchase\n18 July 2026"),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Text(
                        "- KES 1500",

                        style: TextStyle(
                          color: expenseColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: "edit",
                            child: Text("Edit"),
                          ),

                          const PopupMenuItem(
                            value: "delete",
                            child: Text("Delete"),
                          ),
                        ],

                        onSelected: (value) {
                          if (value == "edit") {
                            // edit later
                          } else if (value == "delete") {
                            // delete later
                          }
                        },
                      ),
                    ],
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
