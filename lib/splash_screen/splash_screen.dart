import 'package:flutter/material.dart';
import 'package:habit_tracker/homescreen.dart';
import 'package:habit_tracker/palette.dart';
import 'package:habit_tracker/providers/user.dart';
import 'package:provider/provider.dart';

import 'package:home_widget/home_widget.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = "/splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var userProv;
  Future<void> initialise() async {
    await userProv.initialise();
    userProv.date = DateTime.now().toString();
    await userProv.getTasks();

    await userProv.checkColor();
    await updateAppWidget();
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  @override
  void initState() {
    userProv = Provider.of<User>(context, listen: false);
    initialise();
    HomeWidget.widgetClicked.listen((Uri? uri) => loadData());
    loadData(); // This will load data from widget every time app is opened
    super.initState();
  }

  void loadData() async {
    await HomeWidget.getWidgetData<String>('label', defaultValue: "App not opened!");
  }

  Future<void> updateAppWidget() async {
    if (userProv.tasksOfParticularDay.isEmpty)
      await HomeWidget.saveWidgetData<String>('label', "Hooray! No tasks left!!!!");
    else {
      String tasks = "";
      for (int i = 0; i < userProv.tasksOfParticularDay.length; i++) {
        if (userProv.tasksOfParticularDay[i]["completed"] == "false") tasks += userProv.tasksOfParticularDay[i]["name"] + "\n";
      }

      await HomeWidget.saveWidgetData<String>('label', tasks);
    }

    await HomeWidget.updateWidget(name: 'HomeScreenWidgetProvider', iOSName: 'HomeScreenWidgetProvider');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette().bgColor,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 200,
                  child: Image.asset("assets/images/icon.png"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
