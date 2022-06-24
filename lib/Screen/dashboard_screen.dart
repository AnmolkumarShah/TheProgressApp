import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress2/Model/member_model.dart';
import 'package:progress2/Provider/google_signin_provider.dart';
import 'package:progress2/Provider/member_provider.dart';
import 'package:progress2/Screen/admin_screen.dart';
import 'package:progress2/Screen/blog_screen.dart';
import 'package:progress2/Widget/blogs.dart';
import 'package:progress2/Widget/drawer_tile.dart';
import 'package:progress2/Widget/image_slider.dart';
import 'package:progress2/Widget/upcomming_meeting.dart';
import 'package:progress2/control.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginSignup/login_screen.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Member member = Provider.of<MemberProvider>(context, listen: false).member;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          elevation: 0,
          child: Column(
            children: [
              Container(
                height: 200,
                padding: const EdgeInsets.all(10),
                child: Image.asset("assets/the_progress_logo.png"),
              ),
              const Spacer(),
              DrawerTile(control: Control['about']!),
              DrawerTile(control: Control['team']!),
              DrawerTile(control: Control['contact']!),
              DrawerTile(control: Control['News']!),
              DrawerTile(control: Control['research']!),
              if (member.allowed == true)
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.blog),
                  title: const Text("Publish A Blog"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddBlogScreen(),
                      ),
                    );
                  },
                ),
              if (member.isAdmin == true)
                ListTile(
                  leading: const FaIcon(FontAwesomeIcons.accusoft),
                  title: const Text("Admin Login"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminScreen(),
                      ),
                    );
                  },
                ),
              ListTile(
                leading: const FaIcon(FontAwesomeIcons.outdent),
                title: const Text("Logout"),
                onTap: () async {
                  final Future<SharedPreferences> _prefs =
                      SharedPreferences.getInstance();
                  final SharedPreferences prefs = await _prefs;
                  await prefs.clear();
                  Provider.of<GoogleSigninProvider>(context, listen: false)
                      .googleLogout();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(300),
          child: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            title: const Text(
              "The Progress",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            flexibleSpace: Image.network(
              "https://theprogress.in/img/home/slider/slider_image_1.jpg",
              height: double.infinity,
              color: Colors.grey,
              colorBlendMode: BlendMode.modulate,
              fit: BoxFit.fitHeight,
            ),
            bottom: TabBar(
              tabs: [
                Tab(
                  child: Text(
                    "Meetings",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  icon: Icon(
                    Icons.meeting_room,
                    color: Colors.white,
                  ),
                ),
                Tab(
                  child: Text(
                    "Blogs",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  icon: Icon(
                    Icons.book,
                    color: Colors.white,
                  ),
                )
              ],
              indicatorWeight: 5,
            ),
          ),
        ),
        body: member.allowed == false
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "You Are Not Allowed, You Have To Wait Till Admin Allow",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              )
            : TabBarView(
                children: [
                  const UpcommingMeeting(),
                  const BlogsRead(),
                ],
              ),
      ),
    );
  }
}
