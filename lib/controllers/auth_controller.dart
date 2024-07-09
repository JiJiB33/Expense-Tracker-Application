import '../models/user_model.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AuthController {
  Future<List<User>> _loadUsers() async {
    try {
      String jsonString = await rootBundle.loadString('assets/users.json');
      List<dynamic> jsonResponse = json.decode(jsonString);
      List<User> users = jsonResponse.map((user) => User.fromJson(user)).toList();
      return users;
    } catch (e) {
      print("Error loading users: $e");
      return [];
    }
  }

  Future<bool> login(String email, String password) async {
    // Hardcoded test
    if (email == "test@example.com" && password == "test123") {
      return true;
    }

    // Original code for checking against JSON data
    List<User> users = await _loadUsers();
    return users.any((user) => user.email == email && user.password == password);
  }
}
