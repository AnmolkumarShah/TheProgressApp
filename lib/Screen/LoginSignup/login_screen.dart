import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress2/Helper/loader_helper.dart';
import 'package:progress2/Helper/show_snakebar.dart';
import 'package:progress2/Provider/google_signin_provider.dart';
import 'package:progress2/Screen/LoginSignup/login.dart';
import 'package:provider/provider.dart';

import 'email_signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _loading = false;

  login() async {
    setState(() {
      _loading = true;
    });
    final googleProvider =
        Provider.of<GoogleSigninProvider>(context, listen: false);
    try {
      dynamic result = await googleProvider.googleLogin();
      if (result != null) {
        Map<String, String> data = {
          'name': result['given_name'],
          'email': result['email']
        };
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmailSignupScreen(data: data),
          ),
        );
      }
    } catch (e) {
      print(e);
      showSnakeBar(context, "Error In Signup ${e.toString()}");
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Image.asset(
                'assets/logo.png',
                color: Colors.white,
                scale: 0.8,
              ),
            ),
            const Spacer(),
            _loading == true
                ? const Loader()
                : ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      fixedSize: const Size(250, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: login,
                    icon: const FaIcon(FontAwesomeIcons.google),
                    label: const Text("Signin With Google"),
                  ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: Colors.black,
                fixedSize: const Size(250, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              },
              icon: const FaIcon(FontAwesomeIcons.accusoft),
              label: const Text("Login To Application"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
