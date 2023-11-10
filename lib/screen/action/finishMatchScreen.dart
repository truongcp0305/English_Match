import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../navigator/navigation.dart';

class DialogScreen extends StatefulWidget {
  @override
  State<DialogScreen> createState() => _DialogScreenState();
}

class _DialogScreenState extends State<DialogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Popup Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
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
                                        // if(!isOpDone.value)
                                        //   Text('Đợi đối thủ hoàn thành trân đấu',style: TextStyle(
                                        //     fontWeight: FontWeight.w600,
                                        //     fontSize: 15,
                                        //   ),),
                                        // if (isOpDone.value && isWin.value)
                                          Text('Chiến Thắng',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 15,
                                            ),
                                          ),
                                        SizedBox(height: 10,),
                                        Image.network(
                                          "https://cdn4.iconfinder.com/data/icons/business-marketing-and-management-hexagone/128/4-512.png",
                                          height: 50,
                                          width: 50,
                                        ),
                                        // if (isOpDone.value && !isWin.value)
                                        //   Text('Thất bại', style: TextStyle(
                                        //     fontWeight: FontWeight.w600,
                                        //     fontSize: 15,
                                        //   ),),
                                        // SizedBox(height: 10,),
                                        // Image.network(
                                        //   "https://cdn1.iconfinder.com/data/icons/chess-game-outline-1/32/game-result-player-loser-lose-fail-banner-512.png",
                                        //   height: 50,
                                        //   width: 50,
                                        // ),
                                          SizedBox(height: 20,),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              //Get.off(()=> AppNavigation(user: widget.user));
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
          },
          child: Text('Show Popup'),
        ),
      ),
    );
  }
}

