import 'package:english_match/model/word.dart';

class MatchStatusModel{
  String id;
  String message;
  String status;
  String point;
  List<WordModel> question;
  MatchStatusModel({required this.id, required this.message, required this.status, required this.point, required this.question});
}