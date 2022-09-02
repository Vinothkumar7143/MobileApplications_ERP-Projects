import 'dart:async';
import 'dart:convert';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mylarch_vky/taskupdate.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'AdminDashPages/CPB.dart';
import 'AdminDashPages/OAD.dart';
import 'AdminDashPages/OEP.dart';
import 'AdminDashPages/OPP.dart';
import 'AdminDashPages/OSR.dart';
import 'AdminDashPages/ProjectDetails.dart';
import 'attendance.dart';
import 'card-small.dart';
import 'categories.dart';
import 'expenseentry.dart';
import 'home_category.dart';
import 'loginpage.dart';
import 'package:http/http.dart' as http;


var sales;
var purchase;
var expense;
var salestoInt;
var purchasetoInt;
var expensetoInt;


class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  var now = DateTime.now();

  getChartDetails() async {
    var url = "http://m.demo.larchvms.com/Home/FetchChartDetails";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    for(int i=0;i<data.length;i++){
      setState(() {
        sales = data[i]['SalesVal'];
        purchase = data[i]['PurchaseVal'];
        expense = data[i]['ExpenseVal'];
      });
    }
    salestoInt = int.parse(sales);
    purchasetoInt = int.parse(purchase);
    expensetoInt = int.parse(expense);
    print(salestoInt);
    print(purchasetoInt);
    print(expensetoInt);
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => AdminDash(),
            )
        )
    );
    getChartDetails();
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


class AdminDash extends StatefulWidget {
  const AdminDash({Key? key}) : super(key: key);

  @override
  _AdminDashState createState() => _AdminDashState();
}

class _AdminDashState extends State<AdminDash> {
  var curryear;
  var pettycash;
  late List<GDPData> _chartdata;
  late TooltipBehavior _tooltipBehavior;



  getcurryear() async {
    var url = "http://m.demo.larchvms.com/Home/FetchYearDetails";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    for(int i=0;i<data.length;i++){
      setState(() {
        curryear = data[i]['CurYear'];
      });
    }
  }

  pettycashAvaliable() async {
    var url = "http://m.demo.larchvms.com/Home/FetchPettyCashDetails";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    for(int i=0;i<data.length;i++){
      setState(() {
        pettycash = data[i]['PettyCash'];
      });
    }
  }

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurryear();
    pettycashAvaliable();
    _chartdata = getdata();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
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
              child: FloatingActionButton(heroTag: "btn4",onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreeen()));
              },child:
              Icon(Icons.logout,size: 20,),backgroundColor: Colors.red,),
            )
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10.0,),
              Align(
                alignment: Alignment.topLeft,
                child: Text('Menu : ',style: GoogleFonts.mcLaren(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.0),),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      height: 65.0,
                      child:
                      HomeCategory(
                        icon: Icons.check_circle_sharp,
                        title: "Attendance",
                        items: "Payroll",
                        color: Color.fromRGBO(127,173,242,0.8),
                        isHome: true, tap: () {
                          management = true;
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OutSalesReceivable()));
                        },
                      ),
                    ),
                    Container(
                      height: 65.0,
                      child:
                      HomeCategory(
                        icon: Icons.attach_money_sharp,
                        title: "Expense Entry",
                        items: "Expense",
                        color: Color.fromRGBO(240,164,94,0.8),
                        isHome: true, tap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpenseEntry()));
                        },
                      ),
                    ),
                    Container(
                      height: 65.0,
                      child:
                      HomeCategory(
                        icon: Icons.note_add_sharp,
                        title: "Task Update",
                        items: "Project",
                        color: Color.fromRGBO(237,99,139,0.8),
                        isHome: true, tap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskUpdate()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.0),
              Align(
                alignment: Alignment.topLeft,
                child: Text('Dashboard (For Financial Year $curryear) : ',style: GoogleFonts.mcLaren(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.0),),
              ),
              SizedBox(height: 15.0),
              Container(
                height: 65.0,
                child:
                Card(
                  color: Color.fromRGBO(203,122,242,0.8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  elevation: 4.0,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 0.0, right: 10.0),
                          child: Icon(
                            Icons.money,
                            color: Colors.white,
                          ),
                        ),
                            Text(
                              "Petty Cash Available",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 17,
                              ),
                            ),
                        Spacer(),
                        Text(
                            'Rs. $pettycash',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 17,
                            ),),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Container(
                width: 500,
                height: 250,
                child:
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  elevation: 4.0,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                    child: FlipCard(
                      direction: FlipDirection.HORIZONTAL,
                      speed: 1000,
                      onFlipDone: (status) {
                        print(status);
                      },
                      front: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network('https://assets.website-files.com/5e6aa7798a5728055c457ebb/6101feacb06eff19939f8506_hero-profit%20and%20loss%20statement.jpg'),
                            Text('Profit and Loss',style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 17,
                            ),)
                          ],
                        ),
                      ),
                      back: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: SfCircularChart(
                          legend: Legend(isVisible: true,overflowMode: LegendItemOverflowMode.wrap),
                          tooltipBehavior: _tooltipBehavior,
                          series: <CircularSeries>[
                            PieSeries<GDPData,String>(
                              dataSource:  _chartdata,
                              xValueMapper: (GDPData data,_) => data.contries,
                              yValueMapper: (GDPData data,_) => data.gdp,
                              dataLabelSettings: DataLabelSettings(isVisible: true),
                              enableTooltip: true,
                            )
                          ],),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardSmall(
                      cta: "View",
                      title : "Outstanding Sales Receivable",
                      img: "https://secure2.sfdcstatic.com/assets/images/hub/sales/tips-for-sales-pipeline-management/sales-pipeline-management-header.png",
                      tap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OSR()));
                      }),
                  CardSmall(
                      cta: "View",
                      title: "Outstanding Purchase Payable",
                      img: "https://www.cflowapps.com/wp-content/uploads/2021/07/purchse_requistn.jpg",
                      tap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OPP()));
                      })
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardSmall(
                      cta: "View",
                      title: "Outstanding Expense Payable",
                      img: "https://asset5.scripbox.com/wp-content/uploads/2020/03/expense-ratio-vector.png",
                      tap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OEP()));
                      }),
                  CardSmall(
                      cta: "View",
                      title: "OverDue AMC Details",
                      img: "https://s3.ap-south-1.amazonaws.com/img1.creditmantri.com/community/article/how-to-pay-overdue-loan-emis.jpg",
                      tap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>OAD()));
                      })
                ],
              ),
              SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CardSmall(
                      cta: "View",
                      title: "Project Details",
                      img: "https://miro.medium.com/max/920/1*uxErXo6q0-N5dkFK_ttSZw.png",
                      tap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ProjectDetails()));
                      }),
                  CardSmall(
                      cta: "View",
                      title: "Customer Pending Bug",
                      img: "https://learnsql.com/blog/error-with-group-by/7-Common-GROUP-BY-Errors.png",
                      tap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CPB()));
                      })
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
  List<GDPData> getdata() {
    final List<GDPData> chartdata = [
      GDPData(contries: 'Sales',gdp: salestoInt),
      GDPData(contries: 'Purchase',gdp: purchasetoInt),
      GDPData(contries: 'Expense',gdp: expensetoInt),
    ];
    return chartdata;
  }
}

class GDPData {
  GDPData({this.contries,this.gdp});
  final String? contries;
  final int? gdp;
}
