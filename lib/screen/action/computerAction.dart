import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:english_match/adapter/repository/apiService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';

import '../../model/user.dart';
import '../../model/word.dart';
import '../navigator/navigation.dart';

class ComputerFight extends StatefulWidget {
  UserModel user;
  List<WordModel> questions = [];
  ComputerFight({required this.user,required this.questions,Key? key}) : super(key: key);

  @override
  State<ComputerFight> createState() => _ComputerFightState();
}

class _ComputerFightState extends State<ComputerFight> {
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
  int computerPont = 0;
  int round = 0;
  String state = 'ready';
  bool onFocus = false;

  @override
  void initState() {
    super.initState();
    currentWord.value = widget.questions[0].text;
    CountDownt();
    //openWebSocketConnection();
    input.addListener(() {
      textValue.value = input.text;
    });
  }
  void _showKeyboard() {
    SystemChannels.textInput.invokeMethod("TextInput.show");
  }

  void _hideKeyboard() {
    SystemChannels.textInput.invokeMethod("TextInput.hide");
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
            _hideKeyboard();
        },
        child: Container(
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
                          'Máy',
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
                        child: Text(
                          '$computerPont',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18
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
              GestureDetector(
                onTap: (){
                  onFocus = true;
                  _showKeyboard();
                  SystemChannels.textInput.invokeMethod("TextInput.show");
                  print('tapp');
                },
                child: Column(
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
      ),
    );
  }

  void CountDownt(){
    Future.delayed(Duration(seconds: 1), (){
      timeSeconds--;
      setState(() {}); // Cập nhật giao diện
    }).then((_) async{
      if (round == 4){
        ShowDialog();
        return;
      }
      if (timeSeconds == 10) {
        setState(() {
          if (round != 0){
            CaculatePoint();
            CaculateComputerPoint();
            currentWord.value = widget.questions[round].text;
          }
          isFinishCountDown = false;
          assertResult.value = [];
        });
        state = 'listen';
          await audioPlayer.play(UrlSource(widget.questions[round].audio));
          state= 'play';
        CountDownt();
      }else if (timeSeconds == 0){
        Assert();
        setState(() {
          //TODO
          round++;
          isFinishCountDown = true;
          timeSeconds = 14;
          input.text = '';
          state = 'ready';
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

  void GetFinsh() {

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

  void CaculateComputerPoint (){
    Random random = Random();
    int randomNumber = random.nextInt(currentWord.value.length) + 1;
    double point = 100 - (100/ currentWord.value.length * randomNumber);
    computerPont += point.round();
  }

  // void openWebSocketConnection() {
  //   channel.stream.listen((message) {
  //     // Xử lý tin nhắn nhận được ở đây
  //     print('Nhận thông điệp: $message');
  //   });
  // }
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
                          Column(
                            children: [
                              if (computerPont == goalPoint)
                                Text('Hòa',style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),),
                                SizedBox(height: 10,),
                              if (computerPont == goalPoint)
                                Image.network(
                                'https://cdn3.iconfinder.com/data/icons/success-flat-3/60/Stars-review-star-win-achievement-512.png',
                                height: 50,
                                width: 50,
                              ),
                              if (computerPont < goalPoint)
                                Text('Chiến Thắng',style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),),
                              if (computerPont < goalPoint)
                                Image.network(
                                "https://cdn4.iconfinder.com/data/icons/business-marketing-and-management-hexagone/128/4-512.png",
                                height: 50,
                                width: 50,
                              ),
                              if (computerPont > goalPoint)
                                Text('Thất bại',style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),),
                              if (computerPont > goalPoint)
                                Image.network(
                                "https://cdn1.iconfinder.com/data/icons/chess-game-outline-1/32/game-result-player-loser-lose-fail-banner-512.png",
                                height: 50,
                                width: 50,
                              ),
                                SizedBox(height: 20,),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Get.off(()=>AppNavigation(user: widget.user));
                                  },
                                  child: Text('Quay về'),
                                ),
                            ],
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

