import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:progress2/Helper/loader_helper.dart';
import 'package:progress2/Helper/show_snakebar.dart';
import 'package:progress2/Model/member_model.dart';
import 'package:progress2/Provider/google_signin_provider.dart';
import 'package:progress2/Provider/member_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../admin_add_meeting.dart';
import '../dashboard_screen.dart';

class EmailSignupScreen extends StatefulWidget {
  Map<String, String>? data;
  EmailSignupScreen({Key? key, this.data}) : super(key: key);

  @override
  State<EmailSignupScreen> createState() => _EmailSignupScreenState();
}

class _EmailSignupScreenState extends State<EmailSignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController? _emailController = TextEditingController(text: "");

  final TextEditingController? _passController =
      TextEditingController(text: "");

  TextEditingController? _fullNameController = TextEditingController(text: "");
  TextEditingController? _mobileController = TextEditingController(text: "");

  bool _loading = false;

  Future<bool> signin() async {
    if (_formKey.currentState!.validate() == true) {
      setState(() {
        _loading = true;
      });
      try {
        final provider =
            Provider.of<GoogleSigninProvider>(context, listen: false);
        String? email = _emailController!.value.text;
        String? password = _passController!.value.text;
        await provider.emailSignUp(email, password);
        setState(() {
          _loading = false;
        });
        return true;
      } catch (e) {
        print(e);
        setState(() {
          _loading = false;
        });
        return false;
      }
    } else {
      return false;
    }
  }

  // bool _loading = false;
  bool _saveLoader = false;
  List<PlatformFile>? selectedFiles;
  List<String>? urls;

  pickFiles() async {
    List<PlatformFile> files = [];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
      allowMultiple: false,
    );
    if (result != null) {
      files = result.files;

      setState(() {
        selectedFiles = files;
      });
    } else {
      files = [];
    }
  }

  save() async {
    if (selectedFiles == null || urls == null || urls!.isEmpty) {
      showSnakeBar(context, "Select And Upload Atleast One File");
      return;
    }

    setState(() {
      _saveLoader = true;
    });

    if (_formKey.currentState!.validate() == true) {
      Member member = Member(
        email: _emailController!.value.text,
        fullname: _fullNameController!.value.text,
        imageUrl: urls![0],
        password: _passController!.value.text,
        mobile: _mobileController!.value.text,
      );

      // bool signin_res = await signin();
      Map<String, dynamic> member_save = await member.save();
      if (member_save['result'] == true) {
        member.id = member_save['data'];
        try {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', member.email!);
          await prefs.setString('password', member.password!);
        } catch (e) {
          showSnakeBar(context, "Error In Saving Credential Locally");
        }
        Provider.of<MemberProvider>(context, listen: false).setMmber(member);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
      } else {
        showSnakeBar(context, "Error In Saving Member");
      }
    }
    setState(() {
      _saveLoader = false;
    });
  }

  reset() {
    setState(() {
      selectedFiles = null;
    });
  }

  uploadFile() async {
    setState(() {
      _loading = true;
    });
    List<String> temp = [];
    await Future.forEach<PlatformFile>(selectedFiles!, (file) async {
      String destination = "files/${file.name}";
      try {
        final ref = FirebaseStorage.instance.ref(destination);
        UploadTask task = ref.putFile(File(file.path!));

        final snapshot = await task.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();
        temp.add(urlDownload);
        showSnakeBar(context,
            " ${selectedFiles!.indexOf(file) + 1} of ${selectedFiles!.length} File Uploaded ");
      } catch (e) {
        showSnakeBar(context, "Error In File Upload ${e.toString()}");
      }
    });

    setState(() {
      _loading = false;
      urls = temp;
    });
  }

  getSet() {
    setState(() {
      _emailController = TextEditingController(text: widget.data!['email']);
      _fullNameController = TextEditingController(text: widget.data!['name']);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data != null) getSet();
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Image.asset(
                    'assets/logo.png',
                    color: Colors.black,
                    scale: 0.8,
                  ),
                ),
                selectedFiles != null
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ShowSelectedFile(files: selectedFiles!),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FloatingActionButton(
                                key: const Key("Anmol"),
                                onPressed: reset,
                                child: const Icon(Icons.delete),
                                backgroundColor: Colors.red,
                              ),
                              const SizedBox(width: 20),
                              _loading == true
                                  ? const Loader()
                                  : FloatingActionButton(
                                      key: const Key("shah"),
                                      onPressed: uploadFile,
                                      child: const Icon(Icons.upload),
                                      backgroundColor: Colors.blue,
                                    ),
                            ],
                          )
                        ],
                      )
                    : Container(
                        width: double.infinity,
                        margin: const EdgeInsets.all(10),
                        height: 200,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                        ),
                        child: DottedBorder(
                          color: Colors.black,
                          strokeWidth: 4,
                          radius: const Radius.circular(5),
                          dashPattern: const [8, 4],
                          child: Center(
                            child: ElevatedButton.icon(
                              onPressed: pickFiles,
                              icon: const Icon(Icons.search),
                              label: const Text("Select Files"),
                            ),
                          ),
                        ),
                      ),
                TextFormField(
                  controller: _fullNameController,
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: "Full Name",
                    border: OutlineInputBorder(),
                  ),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Required"),
                  ]),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _mobileController,
                  decoration: const InputDecoration(
                    hintText: "Mobile Number",
                    border: OutlineInputBorder(),
                  ),
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Required"),
                    MinLengthValidator(10,
                        errorText: "Enter Valid Mobile Number"),
                  ]),
                ),
                const SizedBox(height: 10),
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
                _saveLoader == true
                    ? const Loader()
                    : ElevatedButton.icon(
                        onPressed: save,
                        icon: const Icon(Icons.login),
                        label: const Text("Create Account"),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
