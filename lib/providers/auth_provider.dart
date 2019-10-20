import 'dart:convert';
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exceptions.dart';

class AuthProvider with ChangeNotifier {
  String _firebaseKey = 'AIzaSyDZR7tWbQaCiPB56WAH89MKgRVcbmCbkEc';
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    print('tendo is auth');
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      print('tentando o token');
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String endpoint) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$endpoint?key=$_firebaseKey';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        if (responseData['error']['message']
            .toString()
            .contains('EMAIL_EXISTS')) {}

        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      print('inseriu o token: $_token');
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      print('inseriu o date ${_expiryDate.toIso8601String()}');
      _userId = responseData['localId'];
      print('e o user $_userId');
      print(responseData);
      _autoLogout();
      notifyListeners();
      final preferences = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });

      preferences.setString('userData', userData);
      print('estamos a terminar');
    } catch (error) {
      print('erros?:::::. $error');
      if (error.toString().contains('')) {
        login(email, password);
      } else {
        throw error;
      }
    }

    //print(json.decode(response.body));
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefereces = await SharedPreferences.getInstance();
    //prefereces.remove('userData');
    prefereces.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }

  Future<bool> tryAutoLogin() async {
    final preferences = await SharedPreferences.getInstance();
    if (!preferences.containsKey('userData')) {
      return false;
    }
    final extratedUserData =
        json.decode(preferences.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extratedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extratedUserData['token'];
    _userId = extratedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();

    return true;
  }
}
