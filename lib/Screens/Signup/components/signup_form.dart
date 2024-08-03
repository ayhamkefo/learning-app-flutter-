import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants.dart';
import '../../../method/validtador.dart';
import '../../../providers/auth.dart';
import '../../Login/login_screen.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmedPassword = true;

  @override
  void dispose() {
    _password.dispose();
    _confirmPassword.dispose();
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (_formKey.currentState!.validate()) {
      print(
          "name: ${_name.text}  password : ${_password.text}  email: ${_email.text}");
      await Provider.of<Auth>(context, listen: false).register(
          email: _email.text, password: _password.text, name: _name.text);

      if (!mounted) return;
      if (Provider.of<Auth>(context, listen: false).errorMessge != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(Provider.of<Auth>(context, listen: false).errorMessge!),
            backgroundColor: Colors.red,
          ),
        );
        Provider.of<Auth>(context, listen: false).resetErrorMessage();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration successful!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Sign Up Failed ):"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _name,
              validator: Validte.validateName,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              onSaved: (name) => _name,
              decoration: const InputDecoration(
                hintText: "Your name",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _email,
              onSaved: (email) => _email,
              validator: Validte.validateEmail,
              textInputAction: TextInputAction.done,
              obscureText: false,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your Email",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.email),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _password,
              onSaved: (password) => _password,
              validator: Validte.validatePassword,
              textInputAction: TextInputAction.done,
              obscureText: _obscurePassword,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xFF252c4a),
                  ),
                  onPressed: () => setState(() {
                    _obscurePassword = !_obscurePassword;
                  }),
                ),
                hintText: "Your password",
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _confirmPassword,
              onSaved: (password) => _confirmPassword,
              validator: (password) {
                if (password == null || password.isEmpty) {
                  return 'Please Enter The Password';
                }
                if (password.length < 6) {
                  return 'Password Must Be More Than 6 Letters ';
                }
                if (password != _password.text) {
                  return "Password Don't Match";
                }
                return null;
              },
              textInputAction: TextInputAction.done,
              obscureText: _obscureConfirmedPassword,
              cursorColor: kPrimaryColor,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmedPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: const Color(0xFF252c4a),
                  ),
                  onPressed: () => setState(() {
                    _obscureConfirmedPassword = !_obscureConfirmedPassword;
                  }),
                ),
                hintText: "Confirm Your password",
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding / 2),
          ElevatedButton(
            onPressed: () {
              submit();
            },
            child: Text("Sign Up".toUpperCase()),
          ),
          const SizedBox(height: defaultPadding),
          AlreadyHaveAnAccountCheck(
            login: false,
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const LoginScreen();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
