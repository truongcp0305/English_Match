import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:english_match/model/account.dart';

class FileSignInService {
  Future<File> getFile() async{
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${appDocumentDirectory.path}/your_file_name.txt');
    try {
      if (!await file.exists()) {
        await file.create(recursive: true);
      }
    } catch (e) {
      print('Lỗi: $e');
    }
    return file;
  }

  Future<void> writeToFile (username, password) async{
    final file = await getFile();
    final sink = file.openWrite(mode: FileMode.write);
    sink.write('{"username":"$username","password":"$password"}');
    await sink.close();
  }

  Future<AccountModel> readFile () async{
    final file = await getFile();
    if (await file.exists()){
      final contents = await file.readAsString();
      var decode = jsonDecode(contents);
      return AccountModel(userName: decode["username"], password: decode["password"]);
    }else{
      return AccountModel(userName: "", password: "");
    }
  }
}