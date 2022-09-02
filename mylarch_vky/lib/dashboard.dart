import 'dart:async';
import 'dart:convert';

import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylarch_vky/taskupdate.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

import 'attendance.dart';
import 'dashdetails.dart';
import 'expenseentry.dart';
import 'loginpage.dart';

var present;
var absent;
var leave;
var presenttoInt;
var absenttoInt;
var leavetoInt;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var now = DateTime.now();

  summary() async {
    var url = "http://m.demo.larchvms.com/Home/FetchPresentAbsentDetails?EmpId=$userid&Year=${now.year}&Month=${now.month}";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    for(int i=0;i<data.length;i++){
      setState(() {
        present = data[i]['Present'];
        absent = data[i]['Absent'];
        leave = data[i]['Leave'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => Dashboard(),
            )
        )
    );
    summary();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 10.0,),
          Text('Logging you in....',style: GoogleFonts.mcLaren(textStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20.0)),)
        ],
      ),
    );
  }
}


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  var now = DateTime.now();
  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.white,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];
  final List<String> letters = [
    "Outstanding Sales Receivable",
    "Outstanding Purchase Payable",
    "Outstanding Expense Payable",
    "Profit and Loss",
    "OverDue AMC Details",
    "Project Details",
    "Customer Pending Bug",
  ];
  CarouselSliderController? _sliderController;
  late List<GDPData> _chartdata;
  late TooltipBehavior _tooltipBehavior;

  summary() async {
    var url = "http://m.demo.larchvms.com/Home/FetchPresentAbsentDetails?EmpId=$userid&Year=${now.year}&Month=${now.month}";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    for(int i=0;i<data.length;i++){
        setState(() {
          present = data[i]['Present'];
          absent = data[i]['Absent'];
          leave = data[i]['Leave'];
        });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    summary();
    _chartdata = getdata();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    var dts = DTS(context: context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        titleTextStyle: TextStyle(color: Colors.black),
        title: Row(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Welcome,',
                  style: GoogleFonts.mcLaren(fontSize: 20,color: Colors.black),
                ),
                SizedBox(
                  width: 2.0,
                ),
                Text(
                  '$userfirstname',
                  style: GoogleFonts.mcLaren(
                      textStyle: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black)),
                ),
              ],
            ),
            Spacer(),
            Container(
              height: 40,
              child: FloatingActionButton(heroTag: "Dashboard",onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreeen()));
              },child:
                Icon(Icons.logout,size: 20,),backgroundColor: Colors.red,),
            )
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text('Dashboard',
                style: GoogleFonts.mcLaren(
                    textStyle: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold))),
            SizedBox(height: 20.0,),

            Container(
              height: 100.0,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blue,
                      Colors.red,
                    ],
                  )
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Attendance ',
                        style: TextStyle(color: Colors.white, fontSize: 25.0,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xff0087a8),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OutSalesReceivable()));
                        },
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 25.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 100.0,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.grey,
                        Colors.indigo,
                      ],
                    )
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Expense Entry',
                        style: TextStyle(color: Colors.white, fontSize: 25.0,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xff0087a8),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ExpenseEntry()));
                        },
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 25.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              height: 100.0,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.indigoAccent,
                        Color.fromRGBO(0, 0, 0, 0.5),
                      ],
                    )
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Task Update',
                        style: TextStyle(color: Colors.white, fontSize: 25.0,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xff0087a8),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskUpdate()));
                        },
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 25.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            management == true?
            Container(
              height: 100.0,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.red,
                        Colors.blue,
                      ],
                    )
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Dashboard Details ',
                        style: TextStyle(color: Colors.white, fontSize: 25.0,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xff0087a8),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboradDetails()));
                        },
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 25.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ):SizedBox(),
            management == false ?
                Container(
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Row(
                          children: [
                            Text('Summary',
                                style: GoogleFonts.mcLaren(
                                    textStyle: TextStyle(
                                        fontSize: 25, fontWeight: FontWeight.bold))),
                            Spacer(),
                          ],
                        ),
                      ),
                      SfCircularChart(
                        legend: Legend(isVisible: true,overflowMode: LegendItemOverflowMode.wrap),
                        tooltipBehavior: _tooltipBehavior,
                        series: <CircularSeries>[
                          RadialBarSeries<GDPData,String>(
                            dataSource:  _chartdata,
                            xValueMapper: (GDPData data,_) => data.contries,
                            yValueMapper: (GDPData data,_) => data.gdp,
                            dataLabelSettings: DataLabelSettings(isVisible: true),
                            enableTooltip: true,
                            maximumValue: 31,
                          )
                        ],),
                    ],
                  ),
                ):SizedBox(),
          ],
        ),
      ),
    );
  }
  List<GDPData> getdata() {
    presenttoInt = int.parse(present);
    absenttoInt = int.parse(absent);
    leavetoInt = int.parse(leave);
    final List<GDPData> chartdata = [
      GDPData(contries: 'Present',gdp: presenttoInt),
      GDPData(contries: 'Absent',gdp: absenttoInt),
      GDPData(contries: 'Leave',gdp: leavetoInt),
    ];
    return chartdata;
  }
}

class GDPData {
  GDPData({this.contries,this.gdp});
  final String? contries;
  final int? gdp;
}

class Source extends DataTableSource {
  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text("Rowl$index")),
      DataCell(Text("Android Mobile Application")),
      DataCell(Text("Row3$index")),
      DataCell(Text("Android Mobile Application")),
    ]);
  }
  @override
  bool get isRowCountApproximate => true;

  @override
  int get rowCount => 100;

  @override
  int get selectedRowCount => 0;
}


class DTS extends DataTableSource {
  DTS({required this.context});
  var source = Source();
  BuildContext context;
  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text("Rowl$index")),
      DataCell(Text("Row2$index")),
      DataCell(Text("Android Mobile Application")),
      DataCell(TextButton(child: Text("Row4$index"),onPressed: (){
        showDialog(
            context: context,
            builder: (context) => BsModal(
              context: context,
              dialog: BsModalDialog(
                size: BsModalSize.xxl,
                child: BsModalContent(
                  children: [
                    BsModalContainer(
                        title: Text('New Task Update'),
                        closeButton: true),
                    BsModalContainer(
                      child:
                      Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Contributor :',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                Text('MAHESH VAL SD',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                              ],
                            ),
                            SizedBox(height: 5.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Invoice No :',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                Text('L0038/21-22',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                              ],
                            ),
                            SizedBox(height: 5.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Invoice Date :',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                Text('08/12/2021',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                              ],
                            ),
                            SizedBox(height: 5.0,),
                            SafeArea(
                              child: SingleChildScrollView(
                                child: PaginatedDataTable(
                                  columns: [
                                    DataColumn(label: Text("col#1")),
                                    DataColumn(label: Text("col#2")),
                                    DataColumn(label: Text("col#3")),
                                    DataColumn(label: Text("col#4")),
                                  ],
                                  source: source,
                                  rowsPerPage: 1,
                                ),
                              ),
                            )
                          ]
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },)),
    ]);
  }

  @override
  bool get isRowCountApproximate => true;

  @override
  int get rowCount => 100;

  @override
  int get selectedRowCount => 0;
}
