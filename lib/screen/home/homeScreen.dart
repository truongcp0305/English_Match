import 'package:english_match/adapter/repository/apiService.dart';
import 'package:english_match/screen/action/findMatchScreen.dart';
import 'package:english_match/screen/action/finishMatchScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/user.dart';
import '../action/computerAction.dart';

class HomeScreen extends StatefulWidget {
  final UserModel user;
  const HomeScreen({required this.user, Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiService api = ApiService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color:Color(0xc8fad8d8),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50,),
            Container(
              padding: EdgeInsets.only(left: 10),
              width: 100,
              height: 40,
              margin: EdgeInsets.only(left: 230),
              decoration: BoxDecoration(
                color: Color(0xc8c4dc7d),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black26, width: 1.5)
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.school_sharp,
                    color: Colors.green,
                  ),
                  SizedBox(width: 20,),
                  Text(
                    widget.user.point
                  )
                ],
              ),
            ),
            const SizedBox(height: 30,),
            Image.asset(
              'assets/logo.png',
              width: 450,
              height: 300,
            ),
            //const SizedBox(height: 15,),
            GestureDetector(
              onTap: ()async{
                Get.to(()=> FindMatchScreen(user: widget.user,));
              },
              child: Container( //CARD
                padding: const EdgeInsets.all(15),
                height: 100,
                width: 330,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: const [BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                    offset: Offset(0, 3),
                  )]
                ),
                child: Row(
                  children: [
                    Image.network(
                      "https://cdn0.iconfinder.com/data/icons/pokemon-go-vol-1/135/_fight-256.png",
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 35),
                    const Text(
                      "Đấu với người chơi",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        fontFamily: "RobotoMono"
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 45,),
            GestureDetector(
              onTap: ()async{
                var listWord = await api.GetQuestions("1");
                Get.to(()=>ComputerFight(user: widget.user,questions: listWord));
              },
              child: Container( //CARD
                padding: const EdgeInsets.all(15),
                height: 100,
                width: 330,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black26),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: const [BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.0,
                      spreadRadius: 2.0,
                      offset: Offset(0, 3),
                    )]
                ),
                child: Row(
                  children: [
                    Image.network(
                      "https://cdn2.iconfinder.com/data/icons/new-year-resolutions/64/resolutions-07-256.png",
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 35),
                    const Text(
                      "Đấu với máy",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontWeight: FontWeight.w500,
                          fontFamily: "RobotoMono"
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),

      ),
    );
  }
}
