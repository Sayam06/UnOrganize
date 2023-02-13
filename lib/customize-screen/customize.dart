import 'package:flutter/material.dart';
import 'package:habit_tracker/homescreen.dart';
import 'package:habit_tracker/palette.dart';
import 'package:habit_tracker/providers/user.dart';
import 'package:provider/provider.dart';

class CustomizeScreen extends StatefulWidget {
  static const routeName = "/color";

  @override
  State<CustomizeScreen> createState() => _CustomizeScreenState();
}

class _CustomizeScreenState extends State<CustomizeScreen> {
  late Color initialColor;
  bool change = false;

  @override
  void initState() {
    initialColor = Palette.primaryColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (initialColor == Palette.primaryColor)
          Navigator.of(context).pop();
        else
          Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
        return false;
      },
      child: Scaffold(
        backgroundColor: Palette().bgColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: () {
                        if (initialColor == Palette.primaryColor)
                          Navigator.of(context).pop();
                        else
                          Navigator.of(context).pushNamedAndRemoveUntil(HomeScreen.routeName, (route) => false);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Palette.primaryColor,
                        size: 15,
                      )),
                  SizedBox(width: 10),
                  Text(
                    "Customize",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Accent colors",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              runSpacing: 10,
              children: [
                ...Palette().colors.map((e) => GestureDetector(
                      onTap: () {
                        setState(() {
                          int index = Palette().colors.indexWhere((element) => element == e);
                          // print(Palette().colors.indexWhere((element) => element == e));
                          Provider.of<User>(context, listen: false).changeColor(index);
                          Palette().setColor(index);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(360),
                          border: e == Palette.primaryColor ? Border.all(color: e, width: 2) : null,
                        ),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(360),
                            color: e,
                            border: Border.all(color: e),
                          ),
                        ),
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
