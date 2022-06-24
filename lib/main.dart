import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress2/Provider/member_provider.dart';
import 'package:progress2/Screen/loader_screen.dart';
import 'package:provider/provider.dart';

import 'Provider/google_signin_provider.dart';
import 'Screen/dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSigninProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MemberProvider(),
        ),
      ],
      child: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return MaterialApp(
              title: 'The Progress',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.grey,
              ),
              home: const LoaderScreen(),
              // home: const Dashboard(),
            );
          }),
    );
  }
}
