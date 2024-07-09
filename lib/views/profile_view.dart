import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:savvy_expense_tracker_app/views/dashboard_view.dart';
import 'package:savvy_expense_tracker_app/views/edit_profile_view.dart';
import '../controllers/profile_controller.dart';
import '../widgets/list_in_pf_widget.dart';
import 'package:profile/profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  final ProfileController controller = ProfileController();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
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
          backgroundColor: Color(0xFF203858),
          elevation: 0,
          title: Text(
            'Profile',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 21,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Color(0xFF203858),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(1, 20, 1, 30),
            child: Column(
              children: [
                Profile(
                  imageUrl: controller.profile.imageUrl,
                ),
                SizedBox(height: 13),
                Text(
                  controller.profile.name,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    textStyle: Theme.of(context).textTheme.headlineSmall,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  controller.profile.email,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 25),
                SizedBox(
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6898c4),
                          minimumSize: Size(170, 50),
                          side: BorderSide.none,
                          shape: StadiumBorder(),
                        ),
                        icon: Icon(Icons.edit, color: Colors.white),
                        label: Text(
                          'Edit Profile',
                          style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25),
                Divider(
                  height:10,
                  thickness: 1,
                  indent: 50,
                  endIndent: 50,
                  color: Color(0xFF31587d),
                ),
                //List
                ListInPFWidget(title: 'Account Settings', icon: Icons.manage_accounts_rounded,textColor: Colors.white70, onPress: () {},),
                SizedBox(height: 7),
                ListInPFWidget(title: 'Currency Settings', icon: Icons.currency_exchange_rounded,textColor: Colors.white70, onPress: () {},),
                SizedBox(height: 7),
                ListInPFWidget(title: 'Language', icon: Icons.language_rounded,textColor: Colors.white70, onPress: () {},),
                SizedBox(height: 7),
                ListInPFWidget(title: 'Data Sync', icon: Icons.sync_rounded,textColor: Colors.white70, onPress: () {},),
                SizedBox(height: 7),
                ListInPFWidget(title: 'Notification Preferences', icon: Icons.notifications_rounded,textColor: Colors.white70, onPress: () {},),
                SizedBox(height: 7),
                ListInPFWidget(title: 'Security & Privacy', icon: Icons.security_rounded,textColor: Colors.white70, onPress: () {},),
                SizedBox(height: 7),
                ListInPFWidget(title: 'Feedback & Support', icon: Icons.feedback_rounded,textColor: Colors.white70, onPress: () {},),
                SizedBox(height: 7),
                ListInPFWidget(title: 'Log Out', icon: Icons.logout, textColor: Colors.red[600], endIcon: false, onPress: () => controller.logout(context),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
