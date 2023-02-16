import 'package:flutter/material.dart';
import 'package:habit_tracker/palette.dart';
import 'package:habit_tracker/providers/user.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NewTaskScreen extends StatefulWidget {
  static const routeName = "/newTask";

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNode = new FocusNode();
  bool pending = true;
  DateTime _selectedDate = DateTime.now();
  int priority = 1;
  final TextEditingController controller = new TextEditingController();
  final TextEditingController taskController = new TextEditingController();
  var userProv;

  @override
  void initState() {
    userProv = Provider.of<User>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => FocusScope.of(context).requestFocus(focusNode));
  }

  void addTask() async {
    Map<String, Object> data = {
      "id": DateTime.now().toString(),
      "name": taskController.text,
      "date": _selectedDate.toString(),
      "priority": controller.text == "" ? "1" : controller.text,
      "pending": pending.toString(),
      "completed": "false",
    };
    await userProv.addToTable(data);
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                    primary: Palette.primaryColor,
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      primary: Colors.red, // button text color
                    ),
                  ),
                ),
                child: child!,
              );
            },
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2024))
        .then(
      (pickedDate) {
        if (pickedDate == null)
          return;
        else {
          setState(() {
            _selectedDate = pickedDate;
          });
        }
      },
    );
  }

  void dialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          controller.text = priority.toString();
          int temp = priority;
          return StatefulBuilder(builder: (context, StateSetter ss) {
            return Material(
              color: Palette().bgColor.withAlpha(60),
              child: Center(
                child: Container(
                    width: 250,
                    height: 280,
                    decoration: BoxDecoration(
                      color: Palette().bgLite,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DefaultTextStyle(
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontSize: 14,
                              ),
                              child: Text(
                                "Set a priority",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  ss(() {
                                    temp--;
                                    if (temp == 0) temp = 1;
                                    controller.text = temp.toString();
                                  });
                                },
                                child: Container(
                                  height: double.infinity,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Palette.primaryColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomLeft: Radius.circular(20),
                                      )),
                                  child: Center(
                                    child: Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Container(
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: Palette().bgColor,
                                ),
                                child: Center(
                                  child: TextField(
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    keyboardType: TextInputType.number,
                                    cursorColor: Palette.primaryColor,
                                    textAlign: TextAlign.center,
                                    controller: controller,
                                    decoration: InputDecoration.collapsed(hintText: ""),
                                  ),
                                ),
                              )),
                              GestureDetector(
                                onTap: () {
                                  ss(() {
                                    temp++;
                                    controller.text = temp.toString();
                                  });
                                },
                                child: Container(
                                  height: double.infinity,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Palette.primaryColor,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(20),
                                        bottomRight: Radius.circular(20),
                                      )),
                                  child: Center(
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Palette.primaryColor.withAlpha(60),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Default - 1",
                            style: TextStyle(
                              color: Palette.primaryColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: double.infinity,
                          child: Divider(
                            color: Colors.grey,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Higher priority activities will be displayed",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(0),
                                ),
                                child: Text(
                                  "CLOSE",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                )),
                            TextButton(
                                onPressed: () {
                                  try {
                                    int.parse(controller.text);

                                    Navigator.of(context).pop();
                                  } catch (err) {}
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(0),
                                ),
                                child: Text(
                                  "CONFIRM",
                                  style: TextStyle(
                                    color: Palette.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ))
                          ],
                        ),
                      ],
                    )),
              ),
            );
          });
        });
    setState(() {
      priority = int.parse(controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette().bgColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Palette().bgLite2,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "New Task",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
              child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: 10),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: TextFormField(
                              controller: taskController,
                              validator: ((value) {
                                if (value!.isEmpty) return "Please enter the task name!";
                              }),
                              focusNode: focusNode,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              cursorColor: Palette.primaryColor,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 12,
                                ),
                                isDense: true,
                                labelText: "Task",
                                labelStyle: TextStyle(
                                  color: Palette.primaryColor,
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Palette.primaryColor,
                                    width: 2,
                                  ),
                                ),
                                errorStyle: TextStyle(
                                  color: Palette.primaryColor,
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Palette.primaryColor,
                                    width: 2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Palette.primaryColor,
                                    width: 2,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                    color: Palette.primaryColor,
                                    width: 2,
                                  ),
                                ),
                              )),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                  "assets/images/category.png",
                                  color: Palette.primaryColor,
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Category",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                              Spacer(),
                              Text(
                                "Task",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Palette.primaryColor,
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: 30,
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Palette().bgLite2,
                                ),
                                child: Image.asset(
                                  "assets/images/clock.png",
                                  color: Palette.primaryColor,
                                ),
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.grey[800],
                        ),
                        GestureDetector(
                          onTap: () {
                            _presentDatePicker();
                          },
                          child: Container(
                            height: 50,
                            // color: Colors.blue,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // color: Colors.green,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                height: 20,
                                                width: 20,
                                                child: Icon(
                                                  Icons.calendar_month_outlined,
                                                  color: Palette.primaryColor,
                                                )),
                                            SizedBox(width: 10),
                                            Text(
                                              "Date",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Palette.primaryColor.withAlpha(50),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          DateFormat('dd/MM/yy').format(DateTime.now()) == DateFormat('dd/MM/yy').format(_selectedDate) ? "TODAY" : DateFormat('dd/MM/yy').format(_selectedDate),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Palette.primaryColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[800],
                        ),
                        GestureDetector(
                          onTap: () {
                            dialog();
                          },
                          child: Container(
                            height: 50,
                            // color: Colors.blue,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    // color: Colors.green,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                                height: 20,
                                                width: 20,
                                                child: Image.asset(
                                                  "assets/images/flag.png",
                                                  color: Palette.primaryColor,
                                                )),
                                            SizedBox(width: 10),
                                            Text(
                                              "Priority",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: Palette.primaryColor.withAlpha(50),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          priority == 1 ? "Default" : priority.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Palette.primaryColor,
                                            fontSize: 12,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[800],
                        ),
                        Container(
                          height: 50,
                          // color: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  // color: Colors.green,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              height: 20,
                                              width: 20,
                                              child: Image.asset(
                                                "assets/images/checklist.png",
                                                color: Palette.primaryColor,
                                              )),
                                          SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Pending Task",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              Text(
                                                "It will be shown each day until completed",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      pending = !pending;
                                    });
                                  },
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(360),
                                      color: Palette().bgLite2,
                                    ),
                                    child: pending
                                        ? Image.asset(
                                            "assets/images/check.png",
                                            color: Palette.primaryColor,
                                          )
                                        : SizedBox(),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          color: Colors.grey[800],
                        )
                      ],
                    )),
              ],
            ),
          )),
          Divider(
            color: Colors.grey[800],
          ),
          Container(
            height: 50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(0),
                        ),
                        child: Text(
                          "CANCEL",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        )),
                  ),
                ),
                Flexible(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            addTask();
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(0),
                        ),
                        child: Text(
                          "CONFIRM",
                          style: TextStyle(
                            color: Palette.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        )),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
