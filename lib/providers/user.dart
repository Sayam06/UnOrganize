import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:habit_tracker/database/db.dart';
import 'package:habit_tracker/palette.dart';
import 'package:home_widget/home_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User with ChangeNotifier {
  List allTasksFromDB = [];
  List completedTasks = [];
  List incompleteTasks = [];
  List pendingTasks = [];

  List tasksOfParticularDay = [];

  String date = "";
  String currentTableName = "tasks";

  Future<void> initialise() async {
    final db = await DB.database();
    allTasksFromDB = await db.query(currentTableName);
    completedTasks.clear();
    incompleteTasks.clear();
    pendingTasks.clear();
    tasksOfParticularDay.clear();
  }

  Future<void> sortTasks() async {
    incompleteTasks.sort((a, b) => int.parse(b["priority"]).compareTo(int.parse(a["priority"])));
    pendingTasks.sort((a, b) => int.parse(b["priority"]).compareTo(int.parse(a["priority"])));
  }

  Future<void> getTasks() async {
    completedTasks.clear();
    incompleteTasks.clear();
    pendingTasks.clear();
    tasksOfParticularDay.clear();
    for (int i = 0; i < allTasksFromDB.length; i++) {
      if (allTasksFromDB[i]["date"].toString().substring(0, 10) != date.substring(0, 10)) {
        DateTime creationDate = DateTime.parse(allTasksFromDB[i]["date"]);
        DateTime now = DateTime.parse(date);
        if (now.difference(creationDate).inHours / 24 < 0) continue;
        if (allTasksFromDB[i]["pending"] == "true" && allTasksFromDB[i]["completed"] == "false") pendingTasks.add(allTasksFromDB[i]);
        continue;
      }

      var currentTask = allTasksFromDB[i];
      if (currentTask["completed"] == "true") {
        completedTasks.add(currentTask);
      } else {
        incompleteTasks.add(currentTask);
      }
    }

    sortTasks();

    pendingTasks.forEach((element) {
      tasksOfParticularDay.add(element);
    });
    incompleteTasks.forEach((element) {
      tasksOfParticularDay.add(element);
    });
    completedTasks.forEach((element) {
      tasksOfParticularDay.add(element);
    });
    if (date.toString().substring(0, 10) == DateTime.now().toString().substring(0, 10)) {
      if (tasksOfParticularDay.isEmpty)
        await HomeWidget.saveWidgetData<String>('label', "Hooray! No tasks left!!!!");
      else {
        String tasks = "";
        for (int i = 0; i < tasksOfParticularDay.length; i++) {
          if (tasksOfParticularDay[i]["completed"] == "false") tasks += tasksOfParticularDay[i]["name"] + "\n";
        }

        await HomeWidget.saveWidgetData<String>('label', tasks);
      }

      await HomeWidget.updateWidget(name: 'HomeScreenWidgetProvider', iOSName: 'HomeScreenWidgetProvider');
    }
  }

  Future<void> addToTable(Map<String, Object> data) async {
    final db = await DB.insertIntoTable(currentTableName, data);
    await initialise();
    await getTasks();
    notifyListeners();
  }

  Future<void> changeStatus(String id, String status) async {
    final db = await DB.changeStatus(currentTableName, id, status);
    await initialise();
    await getTasks();
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    final db = await DB.deleteTask(currentTableName, id);
    await initialise();
    await getTasks();
    notifyListeners();
  }

  Future<void> checkColor() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('colorData')) {
      final colorData = json.encode({
        "color": 0,
      });
      prefs.setString("colorData", colorData);
    } else {
      final extractedColorData = json.decode(prefs.getString('colorData').toString()) as Map<String, dynamic>;
      Palette().setColor(extractedColorData["color"]);
    }
  }

  Future<void> changeColor(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final colorData = json.encode({"color": index});

    prefs.setString("colorData", colorData);
  }
}
