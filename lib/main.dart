import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Screens/login_or_sign_up_page.dart';

import 'Screens/home/home_page.dart';
import 'method/sheradPrefefrancesManger.dart';
import 'providers/auth.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => Auth(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: CheckPage(),
      )));
}

class CheckPage extends StatefulWidget {
  const CheckPage({super.key});

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  void attemptAuthentication() async {
    SharedPreferences prfs = await SharedPreferencesManager.getInstance();
    String? token = prfs.getString('auth');
    await Provider.of<Auth>(context, listen: false).attempt(token);
  }

  @override
  void initState() {
    super.initState();
    attemptAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Consumer<Auth>(builder: (context, auth, child) {
            if (auth.isLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (auth.authenticated) {
              return const HomePage();
            }
            return const LoginOrSignUpPage();
          }),
        ),
      ),
    );
  }
}
