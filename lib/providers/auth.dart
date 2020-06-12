import 'dart:convert';
import "dart:async";

import 'package:CineMe/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:CineMe/constant.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  // return the token if the token is not expired yet otherwise return null
  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authentication(
      String email, String password, String urlSegmant) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegmant?key=$kFirebaseKey";
    try {
      final response = await http.post(
        url,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }),
      );
      final extractedData = json.decode(response.body);

      // check error
      if (extractedData["error"] != null) {
        throw HttpException(extractedData["error"]["message"]);
      }
      _token = extractedData["idToken"];
      _userId = extractedData["localId"];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(extractedData["expiresIn"]),
        ),
      );
      _autoLogout();
      notifyListeners();
      // save user info to be retreive when try to auto login

      // establish tunnel to communicate with the device storage
      final prefs = await SharedPreferences.getInstance();

      // encode the user data to be stored in JSON format
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String(),
      });

      // save the info
      prefs.setString("userData", userData);
    } catch (error) {
      // throw the http exeption if any

      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authentication(email, password, "signUp");
  }

  Future<void> signin(String email, String password) async {
    return _authentication(email, password, "signInWithPassword");
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    // return a duration of the difference
    int timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    // start the timer when the timer finish logout will be called
    _authTimer = Timer(
        Duration(
          seconds: timeToExpiry,
        ),
        logout);
  }

  // read the stored user info from the disk if the info is valid the user will be automatically logging in
  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final userData =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    DateTime expiryDate = DateTime.parse(userData["expiryDate"]);

    // check if its expired or not
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    //.. if it is reched here than it is not expired so log in automatically
    _token = userData["token"];
    _userId = userData["userId"];
    _expiryDate = expiryDate;

    notifyListeners();
    // start the timer
    _autoLogout();
    return true;
  }
}
