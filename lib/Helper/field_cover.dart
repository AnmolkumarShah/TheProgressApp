import 'package:flutter/material.dart';

Widget fieldcover({Widget? child}) {
  return Container(
    height: 50,
    // decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(10),
    //     border: Border.all(
    //       color: Colors.blue,
    //       width: 0.5,
    //     )),
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: child,
  );
}
