import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savvy_expense_tracker_app/models/add_amount_model.dart';
import '../controllers/add_amount_controller.dart';
import '../views/expense_view.dart';
import '../views/income_view.dart';
import 'dashboard_view.dart';

class AddAmountView extends StatefulWidget {
  final AddAmountController controller;
  final Function(bool isIncome) onSaveComplete; // Add this line

  AddAmountView({
    required this.controller,
    required this.onSaveComplete, // Add this line
  });

  @override
  _AddAmountViewState createState() => _AddAmountViewState();
}


class _AddAmountViewState extends State<AddAmountView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String selectedOption = '';
  Widget? _nextScreen;
  void _onSavePressed() async {
    final String title = _titleController.text.trim();
    final double amount = double.tryParse(_amountController.text.trim()) ?? 0.0;

    if (title.isNotEmpty && amount > 0) {
      final newAmount = AddAmountModel(
        id: DateTime.now().millisecondsSinceEpoch,
        title: title,
        amount: amount,
        date: DateTime.now(),
      );

      bool isIncome = selectedOption == 'Income';
      await widget.controller.addAmount(newAmount, isIncome);

      // Call the onSaveComplete callback and pass isIncome
      widget.onSaveComplete(isIncome);

      // Pop the current screen
      Navigator.pop(context);
    }
  }


  void _showAddAmountView() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddAmountView(
        controller: widget.controller,
        onSaveComplete: (isIncome) {
          _showSnackBarAfterAddingAmount(isIncome);
        },
      ),
    ));
  }

  void _showSnackBarAfterAddingAmount(bool isIncome) {
    final snackBar = SnackBar(
      content: Text(
        isIncome ? "Income added successfully" : "Expense added successfully",
      ),
      action: SnackBarAction(
        label: 'View',
        textColor: Colors.green,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
              isIncome ? IncomeView(controller: widget.controller) : ExpenseView(controller: widget.controller),
            ),
          );
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }



  void _navigateToView(bool isIncome) {
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => isIncome ? IncomeView(controller: widget.controller) : ExpenseView(controller: widget.controller),
        ),
      ).then((_) {
        // Once navigation is complete, pop the current context if it's still mounted
        if (mounted) {
          Navigator.pop(context);
        }
      });
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DashboardView(),
              ),
            );
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white70,
          ),
        ),
        title: Text(
          "Add Amount",
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        elevation: 0,
        backgroundColor: Color(0xFF203858),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF203858),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                labelText: "Category",
                labelStyle: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 14,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
              ),
            ),

            SizedBox(height: 16),
            TextField(
              controller: _amountController,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 15,
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Amount (MMK)",
                labelStyle: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 14,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                ),
              ),
            ),

            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOptionButton('Income', Colors.green, 120, 50),
                _buildOptionButton('Expense', Colors.red, 120, 50),
              ],
            ),
            SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: _onSavePressed,
              style: ElevatedButton.styleFrom(
              fixedSize: Size(220, 45),
              primary: Color(0xFF6898c4),
            ),
              icon: Icon(Icons.save, color: Colors.white),
              label: Text(
                'Save',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String option, Color color, double width, double height) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            selectedOption = option;
          });
        },
        style: ElevatedButton.styleFrom(
          primary: selectedOption == option ? color : Colors.white30?.withOpacity(0.2),
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text(
          option,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
