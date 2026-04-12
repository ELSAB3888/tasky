import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:todo/models/task_model.dart';

import '../../core/constants/storage_key.dart';
import '../../core/services/preferences_manager.dart';

class HomeController with ChangeNotifier {
  List<TaskModel> tasksList = [];
  String? username = "Default";
  String? userImagePath;

  init() {
    lodeUserData();
  }

  void lodeUserData() async {
    username = PreferencesManager().getString(StorageKey.username);
    userImagePath = PreferencesManager().getString(StorageKey.userImage);

    notifyListeners();
  }
}
