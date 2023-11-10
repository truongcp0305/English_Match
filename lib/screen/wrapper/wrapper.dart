import 'package:english_match/adapter/repository/apiService.dart';
import 'package:english_match/model/account.dart';
import 'package:english_match/model/user.dart';
import 'package:english_match/screen/authentication/signInScreen.dart';
import 'package:english_match/screen/navigator/navigation.dart';
import 'package:flutter/material.dart';
import 'package:english_match/adapter/log/signIn.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final api = ApiService();
    final fileService = FileSignInService();
    return FutureBuilder<AccountModel>(
      future: fileService.readFile(),
      builder: (context, AsyncSnapshot<AccountModel> snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          AccountModel account = snapshot.data!;
          if (account.userName == '' || account.password == ''){
            return const SignInScreen();
          }else{
            return FutureBuilder<UserModel>(
              future: api.login(account.userName, account.password),
              builder: (context, AsyncSnapshot<UserModel> loginSnapshot){
                if (loginSnapshot.connectionState == ConnectionState.done){
                  var user = loginSnapshot.data!;
                  return AppNavigation(user: user,);
                }
                return const CircularProgressIndicator();
              },
            );
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
