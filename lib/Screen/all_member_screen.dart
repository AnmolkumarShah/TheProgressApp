import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress2/Helper/loader_helper.dart';
import 'package:progress2/Model/member_model.dart';
import 'package:progress2/Screen/allow_screen.dart';

class AllMember extends StatelessWidget {
  const AllMember({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Query<Map<String, dynamic>> filter =
        FirebaseFirestore.instance.collection("members");

    return Scaffold(
      appBar: AppBar(title: const Text("All Members")),
      body: StreamBuilder<QuerySnapshot>(
        stream: filter.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loader();
          }
          List<QueryDocumentSnapshot<Object?>> data = snapshot.data!.docs;
          List<Member> memberlist =
              data.map((e) => Member.parse(e, e.id)).toList();

          if (memberlist.isEmpty) {
            return Center(
              child: Chip(label: const Text("No Request")),
            );
          }

          return ListView.builder(
            itemCount: memberlist.length,
            itemBuilder: (context, index) =>
                MemberTile(member: memberlist[index]),
          );
        },
      ),
    );
  }
}
