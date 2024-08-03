import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth.dart';

import '../../widgets/bottom_nav_bar.dart';

import '../profile/profile_page.dart';
import 'components/big_user_card.dart';
import 'components/icon_style.dart';
import 'components/settings_group.dart';
import 'components/settings_item.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Future<void> confirmDeleteAccount(BuildContext context) async {
    AwesomeDialog(
      context: context,
      dialogBorderRadius: BorderRadius.circular(20),
      dialogType: DialogType.error,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      title: 'Delete Account',
      desc:
          'Are you sure you want to delete your account? This action cannot be undone.',
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        await Provider.of<Auth>(context, listen: false).deleteAccount();
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNav(
        select: 'Settings',
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            const Text(
              "Settings",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            BigUserCard(
              backgroundColor: const Color.fromARGB(218, 71, 89, 167),
              userName: Provider.of<Auth>(context, listen: false).user!.name,
              cardActionWidget: SettingsItem(
                icons: Icons.edit,
                iconStyle: IconStyle(
                  withBackground: true,
                  borderRadius: 50,
                  backgroundColor: Colors.yellow[600],
                ),
                title: "Modify",
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => ProfilePage()));
                },
              ),
            ),
            SettingsGroup(
              settingsGroupTitle: "Support",
              items: [
                SettingsItem(
                  onTap: () {},
                  icons: Icons.help_outline_outlined,
                  title: "Help Center",
                  iconStyle: IconStyle(
                    iconsColor: const Color(0xFF252c4a),
                    backgroundColor: const Color.fromARGB(255, 216, 228, 225),
                  ),
                ),
                SettingsItem(
                  onTap: () {},
                  icons: Icons.support_outlined,
                  title: "Contact Support",
                  iconStyle: IconStyle(
                    iconsColor: const Color(0xFF252c4a),
                    backgroundColor: const Color.fromARGB(255, 216, 228, 225),
                  ),
                ),
                SettingsItem(
                  onTap: () {},
                  icons: Icons.feedback_outlined,
                  title: "Feedback",
                  iconStyle: IconStyle(
                    iconsColor: const Color(0xFF252c4a),
                    backgroundColor: const Color.fromARGB(255, 216, 228, 225),
                  ),
                ),
              ],
            ),
            SettingsGroup(
              items: [
                SettingsItem(
                  onTap: () {},
                  icons: Icons.info_outline_rounded,
                  iconStyle: IconStyle(
                    iconsColor: const Color(0xFF252c4a),
                    backgroundColor: const Color.fromARGB(255, 216, 228, 225),
                  ),
                  title: 'About',
                ),
                SettingsItem(
                  onTap: () {},
                  icons: Icons.dark_mode_rounded,
                  iconStyle: IconStyle(
                    iconsColor: Colors.white,
                    withBackground: true,
                    backgroundColor: Colors.black,
                  ),
                  title: 'Dark mode',
                  subtitle: "Automatic",
                  trailing: Switch.adaptive(
                    value: false,
                    onChanged: (value) {},
                  ),
                ),
              ],
            ),
            SettingsGroup(
              settingsGroupTitle: "Account",
              items: [
                SettingsItem(
                  iconStyle: IconStyle(
                    backgroundColor: Colors.red,
                  ),
                  onTap: () {
                    confirmDeleteAccount(context);
                  },
                  icons: Icons.delete_outline_outlined,
                  title: "Delete account",
                  titleStyle: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
