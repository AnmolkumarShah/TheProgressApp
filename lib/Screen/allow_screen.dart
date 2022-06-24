import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progress2/Helper/loader_helper.dart';
import 'package:progress2/Helper/phone_call.dart';
import 'package:progress2/Helper/show_snakebar.dart';
import 'package:progress2/Helper/whatsApp.dart';
import 'package:progress2/Model/member_model.dart';

class AllowScreen extends StatelessWidget {
  const AllowScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Query<Map<String, dynamic>> filter = FirebaseFirestore.instance
        .collection("members")
        .where('allowed', isEqualTo: false)
        .where('isAdmin', isEqualTo: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Members In Waiting")),
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

class MemberTile extends StatefulWidget {
  const MemberTile({Key? key, required this.member}) : super(key: key);
  final Member member;

  @override
  State<MemberTile> createState() => _MemberTileState();
}

class _MemberTileState extends State<MemberTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.member.imageUrl!),
          ),
          title: Text(widget.member.fullname!),
          subtitle: Text(widget.member.email!),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch(
                  value: widget.member.allowed!,
                  onChanged: (val) async {
                    await widget.member.alterAllow(val);
                    showSnakeBar(
                        context, "${widget.member.fullname} is allowed now");
                  }),
              PhoneCall(number: widget.member.mobile!, onlyIcon: true),
              WhatsAppContact(number: widget.member.mobile!, onlyIcon: true),
            ],
          ),
        ),
        Divider(),
      ],
    );
  }
}
