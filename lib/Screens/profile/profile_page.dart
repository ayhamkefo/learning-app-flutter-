import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'change_password_page.dart';
import 'edite_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> confirmSignOut(BuildContext context) async {
    AwesomeDialog(
      context: context,
      dialogBorderRadius: BorderRadius.circular(20),
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      title: 'Sign Out',
      desc: 'Are you sure you want to sign out?',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await Provider.of<Auth>(context, listen: false).logout();
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider _profileImage;
    if (Provider.of<Auth>(context, listen: false)
        .user!
        .profilePhotoUrl
        .isNotEmpty) {
      _profileImage = NetworkImage(
          Provider.of<Auth>(context, listen: false).user!.profilePhotoUrl);
    } else {
      _profileImage = const AssetImage('assets/images/profile.png');
    }
    return Scaffold(
      bottomNavigationBar: const CustomBottomNav(
        select: 'Profile',
      ),
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFF252c4a),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 45,
            ),
            CircleAvatar(
              radius: 50,
              backgroundImage: _profileImage,
            ),
            const SizedBox(height: 16),
            Text(
              Provider.of<Auth>(context, listen: false).user!.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF252c4a),
              ),
            ),
            const SizedBox(height: 55),
            ProfileMenuItem(
              icon: Icons.edit_outlined,
              text: 'Edit Profile',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
            ),
            const SizedBox(
              height: 5,
            ),
            ProfileMenuItem(
              icon: Icons.lock_outlined,
              text: 'Change Password',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage()),
                );
              },
            ),
            const SizedBox(
              height: 5,
            ),
            const SizedBox(
              height: 5,
            ),
            ProfileMenuItem(
              icon: Icons.logout,
              text: 'Sign Out',
              onTap: () => confirmSignOut(context),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  ProfileMenuItem(
      {super.key, required this.icon, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: const Color.fromARGB(255, 66, 83, 168),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      title: Text(
        text,
        style: const TextStyle(
            color: Color(0xFF252c4a),
            fontWeight: FontWeight.bold,
            fontSize: 15),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Color(0xFF252c4a),
        size: 18,
      ),
      onTap: onTap,
    );
  }
}
