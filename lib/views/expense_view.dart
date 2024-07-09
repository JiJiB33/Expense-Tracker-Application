import 'package:flutter/material.dart';
import '../views/dashboard_view.dart';
import '../controllers/add_amount_controller.dart';
import '../models/add_amount_model.dart';
import '../views/add_amount_view.dart';
import '../views/income_view.dart';
import '../views/profile_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';

class ExpenseView extends StatefulWidget {
  final AddAmountController controller;

  ExpenseView({required this.controller});

  @override
  State<ExpenseView> createState() => _ExpenseViewState();
}

class _ExpenseViewState extends State<ExpenseView> {
  get onAddExpensePressed => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Expense List',
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        elevation: 0,
        backgroundColor: Color(0xFF203858),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Color(0xFF203858),
      body: FutureBuilder<List<AddAmountModel>>(
        future: widget.controller.fetchAmounts(false), // Fetching expenses
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No expense records found.'));
          } else {
            final expenses = snapshot.data!;
            double totalExpense = expenses.fold(0, (sum, item) => sum + item.amount);

            return Column(
              children: [
                SizedBox(height: 20),
                GlassmorphicContainer(
                  borderRadius: 12,
                  width: 280,
                  height: 60,
                  blur: 10,
                  border: 1,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.red.withOpacity(0.15),
                      Colors.red.withOpacity(0.1),
                    ],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.red.shade200.withOpacity(0.6),
                      Colors.red.shade200.withOpacity(0.2),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Total Expense: ${totalExpense.toStringAsFixed(2)} Ks',
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        color: Colors.red[300],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                Divider(
                  height:10,
                  thickness: 1,
                  indent: 25,
                  endIndent: 25,
                  color: Color(0xFF31587d),
                ),
                SizedBox(width: 20),


                Expanded(
                  child: ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          expenses[index].title,
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                        subtitle: Text(
                          'Amount (Ks): ${expenses[index].amount}',
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            color: Colors.white70,
                          ),
                        ),
                        trailing: PopupMenuButton<String>(
                          color: Color(0xFF6898c4),
                          onSelected: (value) => _handleMenuSelection(context, value, expenses[index]),
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                              value: 'Edit',
                              child: Text(
                                'Edit',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'Delete',
                              child: Text(
                                'Delete',
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color(0xFF3b6a97),
        height: 60,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(icon: Icon(Icons.dashboard,color: Colors.white), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardView()));
            }),
            IconButton(icon: Icon(Icons.trending_up_rounded,color: Colors.white), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => IncomeView(controller: widget.controller)));
            }),
            SizedBox(width: 30),
            IconButton(icon: Icon(Icons.trending_down_rounded, color: Colors.white), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseView(controller: widget.controller)));
            }),
            IconButton(icon: Icon(Icons.person, color: Colors.white), onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen())); // Ensure ProfileScreen exists
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ExpenseAdder.addExpense(context),
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF6898c4),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _handleMenuSelection(BuildContext context, String value, AddAmountModel amount) {
    if (value == 'Edit') {
      _showEditDialog(context, amount);
    } else if (value == 'Delete') {
      _showDeleteDialog(context, amount);
    }
  }

  void _showEditDialog(BuildContext context, AddAmountModel amount) {
    final TextEditingController _titleController = TextEditingController(text: amount.title);
    final TextEditingController _amountController = TextEditingController(text: amount.amount.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF203858),
          alignment: Alignment.center,
          title: Text(
            'Edit Expense',
            style: GoogleFonts.montserrat(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: 'Amount (Ks)',
                  labelStyle: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                  ),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'Save',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                final updatedAmount = AddAmountModel(
                  id: amount.id,
                  title: _titleController.text,
                  amount: double.tryParse(_amountController.text) ?? amount.amount,
                  date: amount.date,
                );

                widget.controller.updateAmount(updatedAmount, false).then((_) {
                  Navigator.of(context).pop();
                  setState(() {});
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, AddAmountModel amount) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF203858),
          title: Text(
            'Delete Expense',
            style: GoogleFonts.montserrat(
              fontSize: 17,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this item?',
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'Delete',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                widget.controller.deleteAmount(amount, false).then((_) {
                  Navigator.of(context).pop();
                  setState(() {});
                });
              },
            ),
          ],
        );
      },
    );
  }
}
