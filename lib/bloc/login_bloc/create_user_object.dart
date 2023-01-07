import 'dart:convert';

import 'package:bowa/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<User> createUserObject(String id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  User newUser = const User.empty();
  if (prefs.getString('$id user') != null) {
    final json = jsonDecode(prefs.getString('$id user')!);
    newUser = User.fromJson(json);
  }

  return newUser;
}
