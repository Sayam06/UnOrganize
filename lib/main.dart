import 'package:flutter/material.dart';
import 'package:habit_tracker/customize-screen/customize.dart';
import 'package:habit_tracker/homescreen.dart';
import 'package:habit_tracker/new-task-screen/new_task_screen.dart';
import 'package:habit_tracker/providers/user.dart';
import 'package:habit_tracker/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:home_widget/home_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HomeWidget.registerBackgroundCallback(backgroundCallback);
  runApp(const MyApp());
}

Future<void> backgroundCallback(Uri? uri) async {
  if (uri?.host == 'updatecounter') {
    int counter = 0;
    await HomeWidget.getWidgetData<int>('_counter', defaultValue: 0).then((value) {
      counter = value!;
      counter++;
    });
    await HomeWidget.saveWidgetData<int>('_counter', counter);
    await HomeWidget.updateWidget(
        //this must the class name used in .Kt
        name: 'HomeScreenWidgetProvider',
        iOSName: 'HomeScreenWidgetProvider');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => User()),
      ],
      child: Consumer<User>(builder: (ctx, user, _) {
        return MaterialApp(
          title: 'UnOrganize',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            fontFamily: "Poppins",
          ),
          home: SplashScreen(),
          routes: {
            SplashScreen.routeName: (ctx) => SplashScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            NewTaskScreen.routeName: (ctx) => NewTaskScreen(),
            CustomizeScreen.routeName: (ctx) => CustomizeScreen(),
          },
        );
      }),
    );
  }
}
