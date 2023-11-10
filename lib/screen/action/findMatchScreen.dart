import 'package:english_match/adapter/repository/apiService.dart';
import 'package:english_match/model/user.dart';
import 'package:english_match/model/word.dart';
import 'package:english_match/screen/action/realAction.dart';
import 'package:english_match/screen/animation/loadingDotAnimation.dart';
import 'package:english_match/screen/navigator/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FindMatchScreen extends StatefulWidget {
  final UserModel user;
  const FindMatchScreen({required this.user,Key? key}) : super(key: key);

  @override
  State<FindMatchScreen> createState() => _FindMatchScreenState();
}

class _FindMatchScreenState extends State<FindMatchScreen> {
  final api = ApiService();

  @override
  void initState() {
    super.initState();
    GetMatch();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color(0xc8fad8d8)
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50,),
            Image.asset(
              'assets/logo.png',
              width: 450,
              height: 300,
            ),
            SizedBox(height: 100,),
            Text(
              'Đang tìm trận...'
            ),
            Container(
              width: double.infinity,
              height: 100,
              child: Padding(
                padding: EdgeInsets.only(left: 183),
                child: LoadingDotsAnimation(),
              ),
            ),
            ElevatedButton(onPressed: (){
              api.LeaveMatch(widget.user.userName);
              Get.off(()=> AppNavigation(user: widget.user));
            },
                child: Text(
                  "Hủy"
                ))
          ],
        ),
      ),
    );
  }

  void GetMatch(){
    Future.delayed(Duration(seconds: 2), (){

    }).then((_) async{
      var res = await api.FindMatch(widget.user.userName, "1");
      print(res);
      if (res.id != '' && res.status == 'matching'){
          Get.off(()=>RealActionScreen(user: widget.user,myStatus: res,));
          return;
      }else{
        GetMatch();
      }
    });
  }
}
