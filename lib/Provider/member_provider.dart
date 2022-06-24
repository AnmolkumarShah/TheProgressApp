import 'package:flutter/material.dart';
import 'package:progress2/Model/member_model.dart';

class MemberProvider with ChangeNotifier {
  Member? _currentMemberl;

  Member get member => _currentMemberl!;

  void setMmber(Member member) {
    _currentMemberl = member;
    notifyListeners();
  }
}
