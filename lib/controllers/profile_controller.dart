import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../views/login_view.dart';

class ProfileController {
  ProfileModel profile = ProfileModel(name: 'Admin Chan Myae', email: 'chan123@gmail.com', imageUrl: 'assets/images/chanmyae.jpg');
  void logout(BuildContext context) {
    // Clear user data here (e.g., clear tokens, user details)

    // Navigate to login/sign-in page and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginView()),
          (Route<dynamic> route) => false,
    );
  }

}
