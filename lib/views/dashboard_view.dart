import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/horizontal_boxes.dart';
import '../views/income_view.dart';
import '../views/expense_view.dart';
import '../views/profile_view.dart';
import '../views/add_amount_view.dart';
import '../controllers/add_amount_controller.dart';
import '../widgets/bar_chart_widget.dart';
import '../widgets/combination_bar_chart_widget.dart';
import 'package:intl/intl.dart';
import 'package:glassmorphism/glassmorphism.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  DashboardViewState createState() => DashboardViewState();
}

class DashboardViewState extends State<DashboardView> {
  final AddAmountController _controller = AddAmountController();
  late DateTime _startDate;
  late DateTime _endDate;
  double totalIncome = 0;
  double totalExpense = 0;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now().subtract(Duration());
    _endDate = _startDate.add(Duration(days: 1));
    fetchData();
  }

  // Function to format DateTime as "yyyy-MM-dd HH:mm"
  String _formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('dd-MM-yy HH:mm');
    return formatter.format(dateTime);
  }

  void fetchData() async {
    var incomeData = await _controller.getAggregatedData(true);
    var expenseData = await _controller.getAggregatedData(false);
    setState(() {
      totalIncome = incomeData.values.fold(0, (sum, value) => sum + value);
      totalExpense = expenseData.values.fold(0, (sum, value) => sum + value);
    });
  }

  void refreshData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF203858),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 110,
                  color: Color(0xFF3b6a97),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(18,0,8,0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Image.asset('assets/images/logowhite.png', height: 140, width: 140),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          color: Colors.white,
                          onPressed: fetchData,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                // Total Income Container
                GlassmorphicContainer(
                  borderRadius: 12,
                  width: 280,
                  height: 95,
                  blur: 10,
                  border: 1,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green.withOpacity(0.15),
                      Colors.green.withOpacity(0.1),
                    ],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.green.withOpacity(0.6),
                      Colors.green.withOpacity(0.2),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total Income',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${totalIncome.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},')} Ks',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Total Expense Container
                GlassmorphicContainer(
                  borderRadius: 12,
                  width: 280,
                  height: 95,
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
                      Colors.red.withOpacity(0.6),
                      Colors.red.withOpacity(0.2),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total Expense',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${totalExpense.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},')} Ks',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Profit Container
                GlassmorphicContainer(
                  borderRadius: 12,
                  width: 280,
                  height: 95,
                  blur: 10,
                  border: 1,
                  linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.withOpacity(0.15),
                      Colors.blue.withOpacity(0.1),
                    ],
                  ),
                  borderGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.withOpacity(0.6),
                      Colors.blue.withOpacity(0.2),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profit',
                          style: GoogleFonts.montserrat(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${(totalIncome - totalExpense).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match match) => '${match[1]},')} Ks',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                Divider(),
                SizedBox(height: 16),
                Text(
                  "Total Incomes, Total Expenses, and Profit",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 300,
                  child: CombinationBarChartWidget(
                    totalIncome: totalIncome,
                    totalExpense: totalExpense,
                    profit: totalIncome - totalExpense,
                  ),
                ),
                Divider(),
                SizedBox(height: 16),
                HorizontalMagazine(),
                SizedBox(height: 16),
                Text(
                  "Incomes from ${_formatDateTime(_startDate)} to ${_formatDateTime(_endDate)}",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.green[200],
                      fontWeight: FontWeight.bold,
                    ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 300, // Set a fixed height
                  child: FutureBuilder<Map<String, double>>(
                    future: _controller.getAggregatedData(true),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text("No income data available");
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BarChartWidget(data: snapshot.data!, isIncome: true),
                      );
                    },
                  ),
                ),
                Divider(),
                SizedBox(height: 16),
                Text(
                  "Expenses from ${_formatDateTime(_startDate)} to ${_formatDateTime(_endDate)}",
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: Colors.red[200],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 300, // Set a fixed height
                  child: FutureBuilder<Map<String, double>>(
                    future: _controller.getAggregatedData(false),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Text("No expense data available");
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: BarChartWidget(data: snapshot.data!, isIncome: false),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => IncomeView(controller: _controller)));
              }),
              SizedBox(width: 30),
              IconButton(icon: Icon(Icons.trending_down_rounded, color: Colors.white), onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ExpenseView(controller: _controller)));
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
      ),
    );
  }

  Widget _buildTotalAmountContainer(String title, String amount, Color color) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(10),
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            '$amount Ks',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class ExpenseAdder {
  static void addExpense(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAmountView(
          controller: AddAmountController(),
          onSaveComplete: (isIncome) {
            SnackBarHandler.showSnackBar(context, isIncome);
          },
        ),
      ),
    );
  }
}


class SnackBarHandler {
  static void showSnackBar(BuildContext context, bool isIncome) {
    final snackBar = SnackBar(
      content: Text(isIncome ? "Income added successfully" : "Expense added successfully"),
      action: SnackBarAction(
        label: 'View',
        textColor: Colors.green,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => isIncome ? IncomeView(controller: AddAmountController()) : ExpenseView(controller: AddAmountController()),
          ));
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

