import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rapidor/report/provider/report_provider.dart';

class Reports extends StatefulWidget {
  const Reports({super.key});

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  @override
  void initState() {
    // TODO: implement initState

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Orientation currentOrientation = MediaQuery.of(context).orientation;

      if (currentOrientation == Orientation.portrait) {
        log("TRUE");
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Click Here to Rotate your screen'),
                content: InkWell(
                    onTap: () {
                      var reportCtrl =
                          Provider.of<ReportsProvider>(context, listen: false);
                      reportCtrl.changeOrientation(true);
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Icon(
                      Icons.screen_rotation_rounded,
                      size: 45,
                    )),
                actions: [
                  // Text('Click Here to Rotate your screen'),
                  // InkWell(
                  //     onTap: () {}, child: Icon(Icons.screen_rotation_rounded)),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text('Dismiss'),
                  ),
                ],
              );
            },
          );
        });
      } else {
        log("False");
      }
    });

    super.initState();
  }

  // Step 3

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  List<Widget> _buildCellsColHeader(
    int count,
  ) {
    var reportCtrl = Provider.of<ReportsProvider>(context, listen: false);
    return List.generate(
      count,
      (index) => Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).orientation == Orientation.portrait
            ? 145.0
            : 135.0,
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? 70
            : 65.0,
        color: Colors.white,
        margin: EdgeInsets.all(4.0),
        child: Text(
          " ${reportCtrl.headerCols[index]["name"]}",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  List<Widget> _buildCells(
    int count,
  ) {
    var reportCtrl = Provider.of<ReportsProvider>(context, listen: false);

    return reportCtrl.returnTextWidget(context);
    // return List.generate(count, (index) {
    //   print(index);
    //   var item = data["times"];

    //   if (index == 0) {
    //     return Container(
    //       alignment: Alignment.center,
    //       width: 135.0,
    //       height: 65.0,
    //       color: Colors.white,
    //       margin: EdgeInsets.all(4.0),
    //       child: Text("${data["total"]}"),
    //     );
    //   }
    //   return Container(
    //     alignment: Alignment.center,
    //     width: 135.0,
    //     height: 65.0,
    //     color: Colors.white,
    //     margin: EdgeInsets.all(4.0),
    //     child: returnText(index, data["times"]),
    //   );
    // });
  }

//
  List<Widget> _buildCellsHeade2(
    int count,
  ) {
    var reportCtrl = Provider.of<ReportsProvider>(context, listen: false);
    return List.generate(
      count,
      (index) => Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).orientation == Orientation.portrait
            ? 145.0
            : 135.0,
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? 70
            : 65.0,
        color: Colors.white,
        margin: EdgeInsets.all(4.0),
        child: Text(
          "${reportCtrl.headerRows2[index]["name"]}",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

//
  List<Widget> _buildCellsHeader(
    int count,
  ) {
    var reportCtrl = Provider.of<ReportsProvider>(context, listen: false);
    return List.generate(
      count,
      (index) => Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).orientation == Orientation.portrait
            ? 145.0
            : 135.0,
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? 70
            : 65.0,
        color: Colors.white,
        margin: EdgeInsets.all(4.0),
        child: Text(
          " ${reportCtrl.headerRows[index]["name"]}",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  List<Widget> _buildRows(int count) {
    var rows = List.generate(
      count,
      (index) => Row(
        children: _buildCells(8),
      ),
    );
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    Orientation currentOrientation = MediaQuery.of(context).orientation;

    return Scaffold(
        appBar: AppBar(
          title: Text("Reports"),
          backgroundColor: Colors.amber,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    var reportCtrl =
                        Provider.of<ReportsProvider>(context, listen: false);
                    reportCtrl.changeOrientation(!reportCtrl.status);
                  },
                  child: Icon(
                    Icons.screen_rotation_rounded,
                  )),
            ),
          ],
        ),
        body: Consumer<ReportsProvider>(
            builder: (context, ReportsProvider reportProvider, _) {
          reportProvider.sortDates();
          return Column(
            children: [
              Column(
                children: [
                  SingleChildScrollView(
                      // physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: _buildCellsHeader(
                              reportProvider.headerRows.length))),
                  SingleChildScrollView(
                      // physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: _buildCellsHeade2(
                              reportProvider.headerRows2.length))),
                ],
              ),
              Divider(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //
                      SingleChildScrollView(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                right: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                              )),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _buildCellsColHeader(
                                    reportProvider.headerCols.length),
                              ),
                            ),
                            Flexible(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _buildRows(
                                      reportProvider.headerCols.length),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }));
  }
}
