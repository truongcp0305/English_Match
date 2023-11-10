import 'dart:convert';
import 'package:english_match/model/matchStatus.dart';
import 'package:english_match/model/user.dart';
import 'package:web_socket_channel/io.dart';
import 'package:english_match/model/word.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String _endpoint = "https://android-service.fly.dev";
  final String _freeDriectory = "https://api.dictionaryapi.dev/api/v2/entries/en";

  Future<UserModel> createAccount(String userName,String password) async{
    var url = Uri.parse( '$_endpoint/user');
    var response = await http.post(url, body: {
      'username': userName,
      'password': password,
    },);
    var result = UserModel(userId: '', userName: '', point: '', otherInfor: '');
    if (response.statusCode == 200){
      final parsed = json.decode(response.body);
      result.userId = parsed['userId'];
      result.userName = parsed['userName'];
      result.point = parsed['point'];
      //result.otherInfor = parsed['otherInfo'];
    }
    return result;
  }

  Future<UserModel> login (String userName,String password) async {
    var url = Uri.parse( '$_endpoint/user/login');
    var response = await http.post(url, body: {
      'username': userName,
      'password': password,
    },);
    var result = UserModel(userId: '', userName: '', point: '', otherInfor: '');
    if (response.statusCode == 200){
      final parsed = json.decode(response.body);
      print(parsed);
      result.userId = parsed['userId'];
      result.userName = parsed['userName'];
      result.point = parsed['point'];
      //result.otherInfor = parsed['otherInfo'] == null ? parsed['otherInfo'] : '';
    }
    return result;
  }

  Future<String> GetAudio (String word) async{
    var url = Uri.parse('$_freeDriectory/$word');
    var response = await http.get(url);
    if (response.statusCode == 200){
      var parsed = json.decode(response.body);
      print(parsed);
      var audio = parsed[0]["phonetics"][0]["audio"];
      if (audio == '') {
        audio = parsed[1]["phonetics"][0]["audio"];
      }
      if (audio == '') {
        audio = parsed[2]["phonetics"][0]["audio"];
      }
      return audio;
    }
    return "";
  }

  Future<List<WordModel>> GetQuestions (String level) async{
    var url = Uri.parse( '$_endpoint/word/question/$level');
    var response = await http.get(url);
    if (response.statusCode == 200){
      var parsed = json.decode(response.body);
      print(parsed);
      List<WordModel> listWord = (parsed as List<dynamic>).map((item)=> WordModel(
          id: item['Id'],
          text: item['text'],
          level: item['level'],
          audio: item['audio']
      )).toList();
      return listWord;
    }else{
      List<WordModel> listWord = [];
      return listWord;
    }
  }

  void sendWebSocketMessage(String message) {
    final channel = IOWebSocketChannel.connect('ws://android-service/room');
    channel.sink.add(message);
    channel.sink.close(); // Đóng kết nối sau khi gửi
  }

  Future<MatchStatusModel> FindMatch(String id, String level)async{
    var result = MatchStatusModel(id: '', message: '',status: '', point: '', question: []);
    var url = Uri.parse('$_endpoint/match/join/$id/$level');
    var response = await http.get(url);
    if (response.statusCode == 200){
      var parsed = json.decode(response.body);
      print(parsed);
      if (parsed['questions'] != null){
        List<WordModel> listWord = (parsed['questions'] as List<dynamic>).map((item)=> WordModel(
            id: item['Id'],
            text: item['text'],
            level: item['level'],
            audio: item['audio']
        )).toList();
        result.question = listWord;
      }
      result.id = parsed['Id'];
      result.status = parsed['status'];
      result.point = parsed['point'];
      result.message = parsed['message'];
    }
    return result;
  }

  Future<MatchStatusModel> GetStatus(String id, String status, String point)async{
    var result = MatchStatusModel(id: '', message: '',status: '', point: '', question: []);
    var url = Uri.parse('$_endpoint/match/status');
    var response = await http.post(url, body: {
      'id': id,
      'status': status,
      'point': point
    });
    if (response.statusCode == 200){
      var parsed = json.decode(response.body);
      result.id = parsed['Id'];
      result.status = parsed['status'];
      result.point = parsed['point'];
      result.message = parsed['message'];
    }
    return result;
  }

  Future<void> UpdateUserInfo (UserModel user) async{
    var url = Uri.parse('$_endpoint/user/update');
    var response = await http.post(url, body: {
      'userId': user.userId,
      'userName': user.userName,
      'point': user.point
    });
  }


  Future<void> LeaveMatch (String id) async{
    var url = Uri.parse('$_endpoint/match/leave/$id');
    await http.get(url);
  }
}