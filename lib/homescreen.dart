import 'package:flutter/material.dart';
import 'package:habit_tracker/maindrawer.dart';
import 'package:habit_tracker/new-task-screen/new_task_screen.dart';
import 'package:habit_tracker/palette.dart';
import 'package:habit_tracker/providers/user.dart';
import 'package:habit_tracker/width.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = "/home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  double opacity = 0;
  final dataKey = new GlobalKey();
  int selectedIndex = 0;
  int currDayIndex = 0;
  DateTime now = DateTime.now();
  late DateTime firstDay;
  late DateTime lastDay;
  Map<int, String> dateMap = {};
  var userProv;

  ScrollController controller = new ScrollController();

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  Tween<Offset> tween = Tween<Offset>(
    begin: Offset(0.0, -1.0),
    end: Offset(0.0, 0.0),
  );
  late Animation<Offset> animation;
  late AnimationController _controller;

  void scroll(double position) {
    controller.jumpTo(position);
  }

  void markAsCompleted(String id, String status) async {
    if (status == "false")
      await userProv.changeStatus(id, "true");
    else
      await userProv.changeStatus(id, "false");
  }

  void initialise() async {
    userProv.getTasks();
  }

  void changeOpacity() {
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        opacity = 1;
      });
    });
  }

  @override
  void initState() {
    userProv = Provider.of<User>(context, listen: false);
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    animation = tween.animate(_controller);
    _controller.forward();
    firstDay = DateTime.now().subtract(Duration(days: 30));
    lastDay = DateTime.now().add(Duration(days: 30));
    selectedIndex = 30;
    currDayIndex = 30;
    WidgetsBinding.instance.addPostFrameCallback((_) => scroll(27 * 51));
    changeOpacity();
  }

  void showSheet(BuildContext context, String id) {
    showBottomSheet(
        enableDrag: true,
        elevation: 10,
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 150,
            decoration: BoxDecoration(
              color: Palette().bgLite,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Divider(
                  color: Colors.grey[800],
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      userProv.deleteTask(id);
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 50,
                            child: Image.asset(
                              "assets/images/trash.png",
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "Delete",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.grey[800],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      drawer: MainDrawer(),
      backgroundColor: Palette().bgColor,
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed(NewTaskScreen.routeName);
          },
          backgroundColor: Palette.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Icon(
            Icons.add,
            color: Colors.white,
          )),
      body: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _key.currentState!.openDrawer();
                  },
                  child: Container(
                    // color: Colors.purple,
                    height: 15,
                    child: Image.asset(
                      "assets/images/drawer.png",
                      color: Palette.primaryColor,
                    ),
                  ),
                ),
                SizedBox(width: 20),
                SlideTransition(
                  position: animation,
                  child: AnimatedOpacity(
                    opacity: opacity,
                    duration: opacity == 0 ? Duration(seconds: 0) : Duration(milliseconds: 600),
                    child: Container(
                      // color: Colors.blue,
                      child: Text(
                        selectedIndex == currDayIndex ? "Today" : DateFormat("dd-MMM-yyyy").format(DateTime.parse(dateMap[selectedIndex].toString())).toString(),
                        style: TextStyle(
                          height: 1.1,
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  color: Colors.grey,
                ),
                SizedBox(width: 10),
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.calendar_month_outlined),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  color: Colors.grey,
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 60,
            child: SingleChildScrollView(
              controller: controller,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Row(
                children: List.generate(
                  lastDay.difference(firstDay).inDays,
                  (index) {
                    var currDay = firstDay.add(Duration(days: index));
                    dateMap.addAll({index: currDay.toString()});

                    return GestureDetector(
                      onTap: () {
                        opacity = 0;
                        _controller.reset();
                        setState(() {
                          _controller.forward();
                          selectedIndex = index;
                          userProv.date = dateMap[selectedIndex];
                          print(userProv.date);
                          initialise();
                          changeOpacity();
                        });
                      },
                      child: Container(
                        width: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          color: selectedIndex == index ? Palette.primaryColor : Palette().bgLite,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 3),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              child: Text(
                                DateFormat('E').format(currDay),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: selectedIndex == index ? Palette().bgLite2.withAlpha(60) : Palette().bgLite2,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                // padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (index == currDayIndex) Spacer(),
                                    Text(
                                      dateMap[index].toString().substring(8, 11),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (index == currDayIndex)
                                      Expanded(
                                          child: Column(
                                        children: [
                                          Spacer(),
                                          Container(
                                            height: 2,
                                            width: 10,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius: BorderRadius.circular(50),
                                            ),
                                          ),
                                        ],
                                      ))
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Consumer<User>(
              builder: (context, user, _) {
                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemBuilder: (ctx, index) {
                    var curr = userProv.tasksOfParticularDay[index];
                    return InkWell(
                      onTap: () {
                        markAsCompleted(curr["id"], curr["completed"]);
                      },
                      onLongPress: () {
                        showSheet(context, curr["id"]);
                      },
                      child: Container(
                        width: double.infinity,
                        constraints: BoxConstraints(
                          minHeight: 50,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade900, width: 0.5),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Container(
                              height: 35,
                              width: 35,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Palette().bgLite2,
                              ),
                              child: Image.asset(
                                "assets/images/clock.png",
                                color: Palette.primaryColor,
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  width: 250,
                                  child: Text(
                                    curr["name"],
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    color: Palette.primaryColor.withAlpha(50),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    "Task" + (curr["priority"] != '1' ? (" | " + curr["priority"]) : ""),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Palette.primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(360),
                                  color: Palette().bgLite2,
                                ),
                                child: curr["completed"] == "true"
                                    ? Image.asset(
                                        "assets/images/complete.png",
                                      )
                                    : SizedBox()),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: userProv.tasksOfParticularDay.length,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
