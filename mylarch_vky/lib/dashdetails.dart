import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;


import 'AdminDashPages/CPB.dart';
import 'AdminDashPages/OAD.dart';
import 'AdminDashPages/OEP.dart';
import 'AdminDashPages/OPP.dart';
import 'AdminDashPages/OSR.dart';
import 'AdminDashPages/ProjectDetails.dart';
import 'loginpage.dart';

class DashboradDetails extends StatefulWidget {
  const DashboradDetails({Key? key}) : super(key: key);

  @override
  _DashboradDetailsState createState() => _DashboradDetailsState();
}

class _DashboradDetailsState extends State<DashboradDetails> {
  var curryear;
  var pettycash;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurryear();
    pettycashAvaliable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text('For Financial Year: $curryear',
                style: GoogleFonts.mcLaren(
                    textStyle: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold))),
            SizedBox(height: 20.0,),

            Container(
              height: 100.0,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  color: Color.fromRGBO(47, 174, 247,0.9)
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Outstanding Sales Receivable ',
                        style: TextStyle(color: Colors.white, fontSize: 20.0,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xff0087a8),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>OSR()));
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
                    color: Color.fromRGBO(29, 194, 109, 0.9)
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Outstanding Purchase Payable',
                        style: TextStyle(color: Colors.white, fontSize: 20.0,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xff0087a8),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>OPP()));
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
              height: 80.0,
              child: Container(
                padding: const EdgeInsets.all(20.0),
                margin: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Color.fromRGBO(0, 0, 0, 0.5)
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Petty Cash Avaliable :',
                        style: TextStyle(color: Colors.white, fontSize: 20.0,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text('Rs.$pettycash',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold,color: Colors.white),)
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
                    color: Color.fromRGBO(61, 3, 255, 0.8)
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Outstanding Expense Payable',
                        style: TextStyle(color: Colors.white, fontSize: 20.0,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xff0087a8),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>OEP()));
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
                    color: Color.fromRGBO(240, 60, 93, 0.9)
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'OverDue AMC Details',
                        style: TextStyle(color: Colors.white, fontSize: 20.0,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xff0087a8),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>OAD()));
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
                    color: Color.fromRGBO(236, 58, 242, 0.9)
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Project Details',
                        style: TextStyle(color: Colors.white, fontSize: 20.0,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xff0087a8),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProjectDetails()));
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
                    color: Color.fromRGBO(247, 138, 64, 0.9)
                ),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Customer Pending Bug',
                        style: TextStyle(color: Colors.white, fontSize: 20.0,fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        backgroundColor: const Color(0xff0087a8),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>CPB()));
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
          ],
        ),
      ),
    );
  }
}
