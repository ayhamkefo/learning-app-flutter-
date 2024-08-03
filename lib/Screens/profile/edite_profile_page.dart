import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../method/validtador.dart';
import '../../providers/auth.dart';
import '../home/home_page.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  File? _profilePhoto;

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (!mounted) return;
      await Provider.of<Auth>(context, listen: false).updateProfile(
        name: _name!,
        email: _email!,
        profilePhoto: _profilePhoto,
      );
      if (Provider.of<Auth>(context, listen: false).errorMessge == null) {
        _showSuccessDialog('Profile Updated Successfully');
      } else {
        _showErrorDialog(
            Provider.of<Auth>(context, listen: false).errorMessge!);
      }
    }
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

  void _showSuccessDialog(String message) {
    AwesomeDialog(
      context: context,
      dialogBorderRadius: BorderRadius.circular(20),
      dialogType: DialogType.success,
      headerAnimationLoop: false,
      animType: AnimType.topSlide,
      title: 'success',
      desc: message,
      btnOkOnPress: () async {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
      },
    ).show();
  }

  Future<void> _pickImage() async {
    if (kIsWeb || !Platform.isAndroid && !Platform.isIOS) {
      // Use file_picker for web and desktop platforms
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.single.path != null) {
        setState(() {
          _profilePhoto = File(result.files.single.path!);
        });
      }
    } else {
      // Use image_picker for mobile platforms
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profilePhoto = File(pickedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider profileImage;
    if (_profilePhoto != null) {
      profileImage = FileImage(_profilePhoto!);
    } else if (Provider.of<Auth>(context, listen: false)
        .user!
        .profilePhotoUrl
        .isNotEmpty) {
      profileImage = NetworkImage(
          Provider.of<Auth>(context, listen: false).user!.profilePhotoUrl);
    } else {
      profileImage = const AssetImage('assets/images/profile.png');
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF252c4a)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('Edit Profile',
            style: TextStyle(
                color: Color(0xFF252c4a),
                fontSize: 25,
                fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 60),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: profileImage,
                    child: const Align(
                      alignment: Alignment.bottomRight,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.camera_alt_outlined,
                            color: Color(0xFF252c4a)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              buildTextField(
                'Name:',
                Provider.of<Auth>(context, listen: false).user!.name,
                (value) => _name = value,
              ),
              const SizedBox(height: 16),
              buildTextField(
                'Email:',
                Provider.of<Auth>(context, listen: false).user!.email,
                (value) => _email = value,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF252c4a),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Save',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, FormFieldSetter<String> onSaved) {
    return ListTile(
      leading: Padding(
        padding: const EdgeInsets.only(right: 10.0, top: 5),
        child: Text(
          labelText,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ),
      title: TextFormField(
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        validator: (value) {
          if (labelText == 'Name:') {
            return Validte.validateName(value);
          } else if (labelText == 'Email:') {
            return Validte.validateEmail(value);
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }
}
