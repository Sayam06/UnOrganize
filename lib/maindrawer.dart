import 'package:flutter/material.dart';
import 'package:habit_tracker/customize-screen/customize.dart';
import 'package:habit_tracker/palette.dart';
import 'package:intl/intl.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.5,
      height: MediaQuery.of(context).size.height,
      color: Palette().bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 50),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Un",
                      style: TextStyle(
                        color: Palette.primaryColor,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      "Organize",
                      style: TextStyle(
                        color: Palette.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  DateFormat('EEEE').format(DateTime.now()).toString(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  DateFormat('dd MMMM yyyy').format(DateTime.now()).toString(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 10),
                Divider(
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(CustomizeScreen.routeName).then((value) {
                  setState(() {});
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                child: Row(
                  children: [
                    Container(
                      height: 20,
                      child: Image.asset(
                        "assets/images/color.png",
                        color: Palette.primaryColor,
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      child: Text(
                        "Customize",
                        style: TextStyle(
                          color: Palette.primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
