import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../models/add_amount_model.dart';

class AddAmountController {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _file(bool isIncome) async {
    final path = await _localPath;
    return File('$path/${isIncome ? 'income_list.json' : 'expense_list.json'}');
  }

  Future<List<AddAmountModel>> fetchAmounts(bool isIncome) async {
    final file = await _file(isIncome);
    List<AddAmountModel> _amounts = [];
    if (await file.exists()) {
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      _amounts = jsonList.map((jsonItem) => AddAmountModel.fromJson(jsonItem)).toList();
    }
    return _amounts;
  }

  Future<void> addAmount(AddAmountModel amount, bool isIncome) async {
    final file = await _file(isIncome);
    List<AddAmountModel> _amounts = await fetchAmounts(isIncome);
    _amounts.add(amount);
    await file.writeAsString(json.encode(_amounts.map((amount) => amount.toJson()).toList()));
  }

  Future<void> updateAmount(AddAmountModel updatedAmount, bool isIncome) async {
    final file = await _file(isIncome);
    List<AddAmountModel> _amounts = await fetchAmounts(isIncome);
    final index = _amounts.indexWhere((element) => element.id == updatedAmount.id);
    if (index != -1) {
      _amounts[index] = updatedAmount;
      await file.writeAsString(json.encode(_amounts.map((amount) => amount.toJson()).toList()));
    }
  }

  Future<void> deleteAmount(AddAmountModel amount, bool isIncome) async {
    final file = await _file(isIncome);
    List<AddAmountModel> _amounts = await fetchAmounts(isIncome);
    _amounts.removeWhere((element) => element.id == amount.id);
    await file.writeAsString(json.encode(_amounts.map((amount) => amount.toJson()).toList()));
  }

  Future<File> _getFile(bool isIncome) async {
    final path = await _localPath;
    return File('$path/${isIncome ? 'income_list.json' : 'expense_list.json'}');
  }

  Future<List<AddAmountModel>> _fetchAmounts(bool isIncome) async {
    final file = await _getFile(isIncome);
    if (await file.exists()) {
      final contents = await file.readAsString();
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((jsonItem) => AddAmountModel.fromJson(jsonItem)).toList();
    } else {
      return [];
    }
  }

  Future<Map<String, double>> getAggregatedData(bool isIncome) async {
    final List<AddAmountModel> amounts = await _fetchAmounts(isIncome);
    Map<String, double> aggregatedData = {};

    for (var amount in amounts) {
      aggregatedData.update(amount.title, (value) => value + amount.amount, ifAbsent: () => amount.amount);
    }

    return aggregatedData;
  }

  // New method to fetch all income and expense data
  Future<Map<String, double>> getAllAggregatedData() async {
    final Map<String, double> incomeData = await getAggregatedData(true);
    final Map<String, double> expenseData = await getAggregatedData(false);

    // Calculate profit
    final Map<String, double> profitData = {};
    for (var key in incomeData.keys) {
      profitData[key] = (incomeData[key] ?? 0) - (expenseData[key] ?? 0);
    }

    return {
      'Total Income': incomeData['Total'] ?? 0,
      'Total Expense': expenseData['Total'] ?? 0,
      'Profit': profitData['Total'] ?? 0,
    };
  }
}
