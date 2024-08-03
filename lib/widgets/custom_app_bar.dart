import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double? fontsize;
  final Widget? leading;

  @override
  final Size preferredSize;

  CustomAppBar({super.key, required this.title, this.fontsize, this.leading})
      : preferredSize = const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      title: Text(title),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'JosefinSans',
        color: Colors.white,
        fontSize: fontsize ?? 18,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(237, 37, 44, 74),
              Color.fromARGB(218, 71, 89, 167),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}
