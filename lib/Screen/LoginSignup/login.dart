import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:progress2/Helper/loader_helper.dart';
import 'package:progress2/Helper/show_snakebar.dart';
import 'package:progress2/Model/member_model.dart';
import 'package:progress2/Provider/google_signin_provider.dart';
import 'package:progress2/Provider/member_provider.dart';
import 'package:progress2/Screen/dashboard_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController? _emailController =
      TextEditingController(text: "");

  final TextEditingController? _passController =
      TextEditingController(text: "");

  bool? _loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  login_event(String mail, String password) async {
    print(mail);
    print(password);
    setState(() {
      _loading = true;
    });

    if (_formKey.currentState!.validate() == true) {
      try {
        Member member =
            await Provider.of<GoogleSigninProvider>(context, listen: false)
                .login(
          // email: _emailController!.value.text,
          // pass: _passController!.value.text,
          email: mail,
          pass: password,
        );
        

        Provider.of<MemberProvider>(context, listen: false).setMmber(member);
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', member.email!);
          await prefs.setString('password', member.password!);
        } catch (e) {
          showSnakeBar(context, "Error In Saving Credential Locally");
        }
        Navigator.pop(context);
        showSnakeBar(context, "Welcome ${member.fullname}");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } catch (e) {
        showSnakeBar(context, "No Member Found");
      }
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(height: 50),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Image.asset(
                    'assets/logo.png',
                    color: Colors.black,
                    scale: 0.4,
                  ),
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Required"),
                    EmailValidator(errorText: "Enter Correct Email Address"),
                  ]),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passController,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Required"),
                    MinLengthValidator(6,
                        errorText: "Password Should Be 6 Character Long"),
                  ]),
                ),
                const SizedBox(height: 10),
                _loading == true
                    ? Loader()
                    : ElevatedButton(
                        onPressed: () => login_event(
                            _emailController!.value.text,
                            _passController!.value.text),
                        child: const Text("Login"),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
