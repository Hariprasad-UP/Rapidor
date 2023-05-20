import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ReportsProvider with ChangeNotifier {
  bool status = true;
  changeOrientation(statusVal) {
    status = statusVal;
    if (status) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  List headerRows2 = [
    {"name": ""},
    {"name": ""},
    {"name": "Date"},
    {"name": "Date"},
    {"name": "Date"},
    {"name": "Date"},
    {"name": "Date"},
    {"name": "Date"},
    {"name": "Date"},
  ];
  List headerRows = [
    {"name": "Total Info for the WEEK"},
    {"name": "Total(Sun-Sat)"},
    {"name": "Sun"},
    {"name": "Mon"},
    {"name": "Tue"},
    {"name": "Wed"},
    {"name": "Thu"},
    {"name": "Fri"},
    {"name": "Sat"},
  ];
  List headerCols = [
    {"name": "Running Time", "time": []},
    {"name": "Jogging Time"},
    {"name": "Exercise Time"},
    {"name": "Total Time(Running+Jogging+Exercise)"},
    {"name": "Running Time engagement % (Running / Total Time)"},
    {"name": "Jogging Time engagement % (Jogging / Total Time)"},
    {"name": "Exercise Time engagement % (Exercise / Total Time)"},
  ];

  Map<String, Object> timeUpdate() {
    List<String> times = [];
    Random random = Random();

    for (int i = 0; i < 7; i++) {
      int minutes =
          random.nextInt(120); // Generate random minutes within 0 to 119
      int seconds = random.nextInt(60);

      String formattedTime =
          '00:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

      times.add(formattedTime);
    }
    // print(times);
    var total = "0";
    // print({"times": times, "total": calculateTotalTime(times)});

    return {
      "times": times,
      "total": removeExcessiveZeros(calculateTotalTime(times).toString())
    };
  }

  String removeExcessiveZeros(String durationString) {
    int endIndex = durationString.indexOf('.') + 3;
    return durationString.substring(0, endIndex);
  }

  Text returnText(index, data) => Text(" ${data[index]}");

  List<Widget> returnTextWidget(context) {
    List<String> timeList = [];
    var data = timeUpdate();
    return List.generate(7, (index) {
      print(index);
      var item = data["times"];

      if (index == 0) {
        return Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).orientation == Orientation.portrait
              ? 145.0
              : 135.0,
          height: MediaQuery.of(context).orientation == Orientation.portrait
              ? 70
              : 65.0,
          color: Colors.white,
          margin: EdgeInsets.all(4.0),
          child: Text("${data["total"]}"),
        );
      }
      return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).orientation == Orientation.portrait
            ? 145.0
            : 135.0,
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? 70
            : 65.0,
        color: Colors.white,
        margin: EdgeInsets.all(4.0),
        child: returnText(index, data["times"]),
      );
    });
  }

  // Duration calculateTotalTime
  Duration calculateTotalTime(List<String> timeList) {
    Duration totalTime = Duration();

    for (String timeString in timeList) {
      List<String> timeComponents = timeString.split(':');
      int hours = int.parse(timeComponents[0]);
      int minutes = int.parse(timeComponents[1]);
      int seconds = int.parse(timeComponents[2]);

      Duration time =
          Duration(hours: hours, minutes: minutes, seconds: seconds);
      totalTime += time;
    }
    print(timeList);
    print(totalTime);
    return totalTime;
  }

  //Sort Dates

  sortDates() {
    DateTime today = DateTime.now();

    DateTime previousSunday = today.subtract(Duration(days: today.weekday));

    List<DateTime> dates = [
      previousSunday, // Sunday
      previousSunday.add(Duration(days: 1)), // Monday
      previousSunday.add(Duration(days: 2)), // Tuesday
      previousSunday.add(Duration(days: 3)), // Wednesday
      previousSunday.add(Duration(days: 4)), // Thursday
      previousSunday.add(Duration(days: 5)), // Friday
      previousSunday.add(Duration(days: 6)), // Saturday
    ];

    // Format the dates to display in the "dd/MMMM/yyyy" format
    DateFormat formatter = DateFormat('dd/MMMM/yyyy');
    List<String> formattedDates =
        dates.map((date) => formatter.format(date)).toList();

    headerRows2 = [
      {"name": ""},
      {"name": ""},
      {
        "name": DateFormat('EEE').format(dates[0]) + " " + formattedDates[0]
      }, // Sunday
      {
        "name": DateFormat('EEE').format(dates[1]) + " " + formattedDates[1]
      }, // Monday
      {
        "name": DateFormat('EEE').format(dates[2]) + " " + formattedDates[2]
      }, // Tuesday
      {
        "name": DateFormat('EEE').format(dates[3]) + " " + formattedDates[3]
      }, // Wednesday
      {
        "name": DateFormat('EEE').format(dates[4]) + " " + formattedDates[4]
      }, // Thursday
      {
        "name": DateFormat('EEE').format(dates[5]) + " " + formattedDates[5]
      }, // Friday
      {
        "name": DateFormat('EEE').format(dates[6]) + " " + formattedDates[6]
      }, // Saturday
    ];

    // Print the headerRows2 list
    for (int i = 0; i < headerRows2.length; i++) {
      print(headerRows2[i]["name"]);
    }
  }
}
