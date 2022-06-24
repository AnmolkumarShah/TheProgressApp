import 'package:flutter/material.dart';
import 'package:progress2/Helper/loader_helper.dart';
import 'package:progress2/Helper/show_snakebar.dart';
import 'package:progress2/Model/member_model.dart';
import 'package:progress2/Provider/google_signin_provider.dart';
import 'package:progress2/Provider/member_provider.dart';
import 'package:progress2/Screen/LoginSignup/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen.dart';

class LoaderScreen extends StatefulWidget {
  const LoaderScreen({Key? key}) : super(key: key);

  @override
  State<LoaderScreen> createState() => _LoaderScreenState();
}

class _LoaderScreenState extends State<LoaderScreen> {
  start() async {
    try {
      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final SharedPreferences prefs = await _prefs;
      final String? email = prefs.getString('email');
      final String? password = prefs.getString('password');
      print(email);
      print(password);
      if (email != null && password != null) {
        try {
          dynamic member =
              await Provider.of<GoogleSigninProvider>(context, listen: false)
                  .login(
            email: email,
            pass: password,
          );
          if (member == null) {
            throw "Welcome";
          }
          Provider.of<MemberProvider>(context, listen: false).setMmber(member);
          Navigator.pop(context);
          showSnakeBar(context, "Welcome ${member.fullname}");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Dashboard()),
          );
        } catch (e) {
          showSnakeBar(context, "No Member Found");
        }
        showSnakeBar(context, "Welcome Back");
      } else {
        throw "Welcome";
      }
    } catch (e) {
      print(e);
      showSnakeBar(context, "You Need To Login/Signup To Application");
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  void initState() {
    start();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png'),
            const SizedBox(
              height: 10,
            ),
            const Loader(),
          ],
        ),
      ),
    );
  }
}
