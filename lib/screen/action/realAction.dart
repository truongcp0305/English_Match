import 'dart:async';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:english_match/adapter/repository/apiService.dart';
import 'package:english_match/model/matchStatus.dart';
import 'package:english_match/screen/action/finishMatchScreen.dart';
import 'package:english_match/screen/navigator/navigation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/user.dart';

class RealActionScreen extends StatefulWidget {
  UserModel user;
  MatchStatusModel myStatus;
  RealActionScreen({required this.user,required this.myStatus,Key? key}) : super(key: key);

  @override
  State<RealActionScreen> createState() => _RealActionScreenState();
}

class _RealActionScreenState extends State<RealActionScreen> {
  int timeSeconds = 14;
  int contQues = 1;
  RxString currentWord = 'hello'.obs;
  TextEditingController input = TextEditingController();
  final RxString textValue = "".obs;
  final api = ApiService();
  final AudioPlayer audioPlayer = AudioPlayer();
  var isFinishCountDown = false;
  RxList<bool> assertResult = [false, false, false, false, false].obs;
  int goalPoint = 0;
  RxInt opPoint = 0.obs;
  int round = 0;
  RxBool isOpDone = false.obs;
  RxBool isWin = false.obs;
  String nameOp = '';
  String state = 'ready';

  @override
  void initState() {
    super.initState();
    UpdateStatus();
    currentWord.value = widget.myStatus.question[0].text;
    CountDownt();
    input.addListener(() {
      textValue.value = input.text;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 60,),
            Container(
              height: 20,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      'Bạn',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    margin: EdgeInsets.only(right: 10),
                    child: Text(
                      nameOp,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 5,),
            Container(
              height: 50,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    width: 100,
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15) )
                    ),
                    child: Center(
                      child: Text(
                        '$goalPoint',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18
                        ),
                      ),
                    ),
                  ),
                  Image.network(
                    'https://cdn0.iconfinder.com/data/icons/arcade-game-center-color-outline/64/18-versus-512.png',
                    height: 100,
                    width: 100,
                  ),
                  Container(
                    height: 50,
                    width: 100,
                    margin: EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15) )
                    ),
                    child: Center(
                      child: Obx(
                        ()=> Text(
                          '${opPoint.value}',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 50,),
            Text(
              'Round ${round +1}',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.redAccent
              ),
            ),
            SizedBox(height: 20,),
            Column(
              children: [
                if(state == 'play')
                  Center(
                    child: Container(
                      child: Text(
                        '$timeSeconds',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                if(state == 'ready')
                  Center(
                    child: Text('Chuẩn bị nghe',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17
                      ),
                    ),
                  ),
                if (state == 'listen')
                  Center(
                    child: Image.network(
                      'https://cdn0.iconfinder.com/data/icons/essentials-solid-glyphs-vol-1/100/Sound-Volume-Audio-512.png',
                      width: 30,
                      height: 30,
                    ),
                  )
              ],
            ),
            const SizedBox(height: 50,),
            Column(
              children: [
                if (!isFinishCountDown)
                  Center(
                    child: Container(
                      width: 350,
                      height: 150,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Center(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: List.generate(currentWord.value.length, (index) => Obx(
                                ()=> Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(10)// Viền đen cho ô vuông
                              ),
                              child: Center(
                                child: Text(
                                  textValue.value.length -1 >= index ? textValue.value[index] : "",
                                  style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          )),
                        ),
                      ),
                    ),
                  ),
                if(isFinishCountDown)
                  Container(
                    width: 350,
                    height: 150,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Center(
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: List.generate(currentWord.value.length, (index) => Obx(
                              ()=> Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: assertResult.value[index] ? Colors.blue : Colors.red,
                            ),
                            child: Center(
                              child: Text(
                                currentWord.value[index],
                                style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        )),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 50,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                controller: input,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Nhập câu trả lời',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void CountDownt(){
    Future.delayed(Duration(seconds: 1), (){
      timeSeconds--;
      setState(() {}); // Cập nhật giao diện
    }).then((_) async{
      if (round == 4){
        widget.myStatus.status = 'done';
        Future.delayed(Duration(seconds: 2));
        ShowDialog();
        return;
      }
      if (timeSeconds == 10) {
        setState(() {
          if (round != 0){
            CaculatePoint();
            currentWord.value = widget.myStatus.question[round].text;
          }
          isFinishCountDown = false;
          assertResult.value = [];
        });
        //var audioUrl = await api.GetAudio(widget.myStatus.question[round].text);
        state = 'listen';
        await audioPlayer.play(UrlSource(widget.myStatus.question[round].audio));
        state = 'play';
        CountDownt();
      }else if (timeSeconds == 0){
        Assert();
        setState(() {
          state = 'ready';
          round++;
          isFinishCountDown = true;
          timeSeconds = 14;
          input.text = '';
        });
        CountDownt();
      }else{
        CountDownt();
      }
    });
  }

  void Assert (){
    for (var i = 0; i < currentWord.value.length; i++){
      assertResult.value.add(false);
    }
    for (var j =0; j < textValue.value.length && j< currentWord.value.length; j++){
      if (textValue.value[j] == currentWord.value[j]){
        assertResult.value[j] = true;
      }
    }
  }

  void CaculatePoint (){
    int inCorrect = 0;
    for (var i =0; i< assertResult.length; i ++){
      if (assertResult.value[i] == false){
        inCorrect++;
      }
    }
    double point = 100 - (100/ assertResult.value.length * inCorrect);
    goalPoint += point.round();
  }


  void UpdateStatus(){
    Future.delayed(Duration(seconds: 5), (){
      //timeSeconds--;
      setState(() {}); // Cập nhật giao diện
    }).then((_) async{
      var status = await api.GetStatus(widget.myStatus.id, widget.myStatus.status, goalPoint.toString());
      setState(() {
        print(status.point + status.status);
        opPoint.value = int.parse(status.point);
        nameOp = status.id;
      });
      if (status.status == 'done' && status.point != ''){
        GetFinish();
        isOpDone.value = true;
        if (round == 4){
          return;
        }
      }
      UpdateStatus();
    });
  }

  void WaitingFinish(){
    Future.delayed(Duration(seconds: 2), (){
      //timeSeconds--;
      setState(() {}); // Cập nhật giao diện
    }).then((_) async{
      var status = await api.GetStatus(widget.myStatus.id, widget.myStatus.status, goalPoint.toString());
      if (status.status == 'done'){
        opPoint.value = int.parse(status.point);
        setState(() {
          isOpDone.value = true;
        });
        //TODO
        return;
      }
      WaitingFinish();
    });
  }

  void GetFinish(){
    if (goalPoint > opPoint.value){
      isWin.value = true;
      widget.user.point = (int.parse(widget.user.point) + 100).toString();
    }
  }


  void FinshMatch(){
    Get.to(()=> DialogScreen());
  }

  void ShowDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Dialog(
              backgroundColor:  Colors.white,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 200, // Set the desired height
                    width: 300, // Set the desired width
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Obx(
                              ()=> Column(
                              children: [
                                if(!isOpDone.value)
                                  Text('Đợi đối thủ hoàn thành trân đấu',style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),),
                                if (isOpDone.value && isWin.value)
                                  Text('Chiến Thắng',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                if (isOpDone.value && isWin.value)
                                  Image.network(
                                    "https://cdn4.iconfinder.com/data/icons/business-marketing-and-management-hexagone/128/4-512.png",
                                    height: 50,
                                    width: 50,
                                  ),
                                if (isOpDone.value && !isWin.value)
                                  Text('Thất bại', style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),),
                                  SizedBox(height: 10,),
                                if (isOpDone.value && !isWin.value)
                                  Image.network(
                                    "https://cdn1.iconfinder.com/data/icons/chess-game-outline-1/32/game-result-player-loser-lose-fail-banner-512.png",
                                    height: 50,
                                    width: 50,
                                  ),
                                if (isOpDone.value)
                                  SizedBox(height: 20,),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Get.off(()=> AppNavigation(user: widget.user));
                                    },
                                    child: Text('Quay về'),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
// Create a ModalBarrier to make the background blurred
                ],
              ),
            ),
          ),
        );

      },
    );
  }
}
