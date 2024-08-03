import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../method/validtador.dart';
import '../../providers/auth.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  String? _currentPassword;
  String? _newPassword;
  String? _confirmedPassword;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmedPassword = true;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_newPassword != _confirmedPassword) {
        _showErrorDialog('New password and confirmation do not match.');
        return;
      }
      await Provider.of<Auth>(context, listen: false).changePassword(
        currentPassword: _currentPassword!,
        newPassword: _newPassword!,
      );
      if (Provider.of<Auth>(context, listen: false).errorMessge == null) {
        _showSuccessDialog('Password changed successfully');
      } else {
        _showErrorDialog(
            Provider.of<Auth>(context, listen: false).errorMessge!);
      }
    }
  }

  void _showSuccessDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogBorderRadius: BorderRadius.circular(20),
      dialogType: DialogType.success,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      title: 'Success',
      desc: message,
      btnOkOnPress: () {
        Navigator.of(context).pop();
      },
    ).show();
  }

  void _showErrorDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogBorderRadius: BorderRadius.circular(20),
      dialogType: DialogType.error,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      title: 'Error',
      desc: message,
      btnOkOnPress: () async {
        Navigator.of(context).pop();
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: 'RobotoMono',
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: kPrimaryLightColor,
            iconColor: kPrimaryColor,
            prefixIconColor: kPrimaryColor,
            contentPadding: EdgeInsets.symmetric(
                horizontal: defaultPadding, vertical: defaultPadding),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide.none,
            ),
          )),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF252c4a)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: const Text('Change Password',
              style: TextStyle(
                  color: Color(0xFF252c4a),
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(25),
            children: [
              const SizedBox(height: 70),
              buildTextField(
                  'Current Password:',
                  (value) => _currentPassword = value,
                  _obscureCurrentPassword, () {
                setState(() {
                  _obscureCurrentPassword = !_obscureCurrentPassword;
                });
              }),
              const SizedBox(height: 16),
              buildTextField('New Password:', (value) => _newPassword = value,
                  _obscureNewPassword, () {
                setState(() {
                  _obscureNewPassword = !_obscureNewPassword;
                });
              }),
              const SizedBox(height: 16),
              buildTextField(
                  'Confirmed Password:',
                  (value) => _confirmedPassword = value,
                  _obscureConfirmedPassword, () {
                setState(() {
                  _obscureConfirmedPassword = !_obscureConfirmedPassword;
                });
              }),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF252c4a),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Save',
                    style: TextStyle(fontSize: 17, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, FormFieldSetter<String> onSaved,
      bool obscureText, VoidCallback togglePasswordVisibility) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          obscureText: obscureText,
          validator: (value) {
            if (labelText == 'Current Password:' ||
                labelText == 'New Password:' ||
                labelText == 'Confirmed Password:') {
              return Validte.validatePassword(value);
            }
            return null;
          },
          onSaved: onSaved,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: const Color(0xFF252c4a),
              ),
              onPressed: togglePasswordVisibility,
            ),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
