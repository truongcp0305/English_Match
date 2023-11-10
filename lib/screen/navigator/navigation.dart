import 'package:english_match/model/user.dart';
import 'package:english_match/screen/home/homeScreen.dart';
import 'package:english_match/screen/user/user_detail.dart';
import 'package:flutter/material.dart';

class AppNavigation extends StatefulWidget {
  final UserModel user;
  AppNavigation({required this.user, Key? key}) : super(key: key);

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  int currentIndex = 0;
  int selectedPage = 0;
  late List<Map<String, Widget>> _pages;

  @override
  void initState() {
    _pages = [
      {
        'page':  HomeScreen(user: widget.user)
      },
      {
        'page': UserDetail(user: widget.user)
      }
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  _pages[currentIndex]['page'],
      bottomNavigationBar: BottomAppBar(
        color: Color(0xc8fad8d8),
        shape: const CircularNotchedRectangle(),
        child: BottomNavigationBar(
          backgroundColor: Color(0xc8fad8d8),
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          unselectedItemColor: Colors.black,
          selectedItemColor: Colors.green,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              tooltip: 'Home',
              label: 'Home',
              //backgroundColor: Colors.blue
            ),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.pie_chart),
            //     tooltip: 'Chart',
            //     label: 'Chart'
            // ),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.list_alt_sharp),
            //     tooltip: 'Plan',
            //     label: 'Plan'
            // ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                tooltip: "User",
                label: "User"
            )
          ],
        ),
      ),
    );
  }
}
