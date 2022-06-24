import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  String? id;
  String? fullname;
  String? imageUrl;
  String? email;
  String? password;
  bool? allowed;
  bool? isAdmin;
  String? mobile;

  Member({
    this.id,
    this.email,
    this.fullname,
    this.imageUrl,
    this.password,
    this.mobile,
    this.allowed = false,
    this.isAdmin = false,
  });

  static Member parse(dynamic data, String id) {
    return Member(
      allowed: data['allowed'],
      email: data['email'],
      fullname: data['fullname'],
      imageUrl: data['imageUrl'],
      isAdmin: data['isAdmin'],
      password: data['password'],
      id: id,
      mobile: data['mobile'],
    );
    // return Member();
  }

  Future<void> alterAllow(bool val) async {
    await FirebaseFirestore.instance
        .collection('members')
        .doc(this.id)
        .update({'allowed': val});
  }

  Future<Map<String, dynamic>> save() async {
    CollectionReference data = FirebaseFirestore.instance.collection("members");
    try {
      final result = await data.add({
        'fullname': fullname,
        'date': DateTime.now().toIso8601String(),
        'email': email,
        'imageUrl': imageUrl,
        'password': password,
        'allowed': allowed,
        'isAdmin': isAdmin,
        'mobile': mobile,
      });

      return {"result": true, "data": result.id};
    } catch (e) {
      print(e);
      return {"result": false, "data": null};
    }
  }
}
