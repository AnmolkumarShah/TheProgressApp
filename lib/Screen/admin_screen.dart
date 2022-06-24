import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress2/Helper/loader_helper.dart';
import 'package:progress2/Helper/show_snakebar.dart';
import 'package:progress2/Helper/text_form_field_helper.dart';
import 'package:progress2/Screen/admin_add_meeting.dart';
import 'package:progress2/Screen/all_blogs.dart';
import 'package:progress2/Screen/all_meetings.dart';
import 'package:progress2/Screen/all_member_screen.dart';
import 'package:progress2/Screen/allow_screen.dart';

class AdminScreen extends StatelessWidget {
  AdminScreen({Key? key}) : super(key: key);
  final Input _email = Input(label: "Email");
  final Input _pass = Input.password(label: "Password");

  void showAlert(BuildContext context, List<Map<String, dynamic>> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _email.builder(),
            _pass.builder(),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              bool loginResult = data.any((e) {
                if (e['email'] == _email.value() &&
                    e['password'] == _pass.value()) {
                  return true;
                } else {
                  return false;
                }
              });

              if (loginResult == false) {
                showSnakeBar(context, "Email or Password not Matched");
                Navigator.pop(context);
                Navigator.pop(context);
              } else {
                showSnakeBar(context, "Welcome Admin");
                Navigator.pop(context);
              }
            },
            child: const Text("Login"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> loginDetailStream =
        FirebaseFirestore.instance.collection("login").snapshots();

    return Scaffold(
      appBar: AppBar(title: const Text("Admin")),
      body: StreamBuilder<QuerySnapshot>(
        stream: loginDetailStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          }
          List<Map<String, dynamic>> data = snapshot.data!.docs
              .map((e) => {'email': e['email'], 'password': e['password']})
              .toList();
          // Future.delayed(Duration.zero, () => showAlert(context, data));
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.meeting_room),
                  title: const Text("Add Meeting"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddProjectScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text("People In Waiting List"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllowScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.emoji_people_rounded),
                  title: const Text("All Members"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllMember()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.meeting_room),
                  title: const Text("All Meetings"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllMeetings()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.book),
                  title: const Text("All Blogs"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AllBlogs()),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
