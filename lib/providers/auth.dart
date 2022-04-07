import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expireDate;
  String _userid;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userid;
  }



  Future<void> authentication(String email, String password, bool sign) async {
    String urlState;
    if (sign)
      urlState = 'signUp';
    else
      urlState = 'signInWithPassword';
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlState?key=AIzaSyCevhKgfx2UaerDk_jvfRyn_515qMgnA6Y');
    try {
      final response = await http.post(url,
          body: jsonEncode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = jsonDecode(response.body);

      if (responseData['error'] != null) throw responseData['error']['message'];
      _token = responseData['idToken'];
      _userid = responseData['localId'];
      _expireDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      _autologOut();
      notifyListeners();
      final pref = await SharedPreferences.getInstance();
      final authData = jsonEncode({
        'token':_token,
        'userId':_userid,
        'expireDate':_expireDate.toIso8601String()
      });
        pref.setString('userData', authData);
    } catch (error) {
      throw error;
    }
  }

 Future <void> logOut() async{
    _userid = null;
    _token = null;
    _expireDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void _autologOut() {
    if (_authTimer != null) _authTimer.cancel();
    final timetoexpire = _expireDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timetoexpire), logOut);
  }
  Future<bool> autoLogin()async{
    final pref = await SharedPreferences.getInstance();
      if(!pref.containsKey('userData'))
        return false;
    print('ZxcvbnxcvbnmZxcvbzxcvb');
        final userData = jsonDecode(pref.getString('userData'));
        final expiredate= DateTime.parse(userData['expireDate']);
      if(expiredate.isBefore(DateTime.now()))
        return false;

      _token=userData['token'];
    _userid = userData['userId'];
    _expireDate =expiredate;

    notifyListeners();
    _autologOut();
    return true;

  }
}
