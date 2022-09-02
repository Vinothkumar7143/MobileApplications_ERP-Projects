import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/material.dart';
import 'package:kfti/fgoutward.dart';

import 'Inward.dart';
import 'outward.dart';

class ProductionOutward extends StatefulWidget {
  const ProductionOutward({Key? key}) : super(key: key);

  @override
  _ProductionOutwardState createState() => _ProductionOutwardState();
}

class _ProductionOutwardState extends State<ProductionOutward> {

  String? mySelection;
  List dropitem =[];
  String? mySelection1;
  List dropitem1 = [];
  BsSelectBoxController _select1 = BsSelectBoxController();
  BsSelectBoxController _select2 = BsSelectBoxController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[40],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset('assets/images/KFTI_Icon.ico'),
            SizedBox(width: 20.0,),
            Text('KOREA FUEL TECH INDIA',style: TextStyle(color: Colors.blue),)
          ],
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/KFTI_Icon.ico',width: 30,height: 30,),
                          SizedBox(width: 10.0,),
                          Text('KOREA FUEL TECH INDIA',style: TextStyle(color: Colors.indigo),),
                        ],
                      ),
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.login_outlined),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Inward', style: TextStyle(fontSize: 20.0)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Inward()));
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.logout_outlined),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Outward', style: TextStyle(fontSize: 20.0)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Outward()));
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.logout_outlined),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Production Outward', style: TextStyle(fontSize: 20.0)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductionOutward()));
                      },
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    ListTile(
                      title: Row(
                        children: [
                          Icon(Icons.logout_outlined),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text('Fg Outward', style: TextStyle(fontSize: 20.0)),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FgOutward()));
                      },
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Column(
                    children: [
                      Divider(color: Colors.black),
                      Text('Version 1.0.0.1')
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 20),
              alignment: Alignment.center,
              child: Text('Production Outward',style: TextStyle(fontSize: 25,decoration: TextDecoration.underline,fontWeight: FontWeight.bold),),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('Prod Line', style: TextStyle(fontSize: 20.0)),
                      Text('Operator', style: TextStyle(fontSize: 20.0)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        width: 200,
                        child: BsSelectBox(
                          hintText: 'Select',
                          controller: _select1,
                        ),
                      ),
                      Container(
                        width: 200,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: BsSelectBox(
                          hintText: 'Select',
                          controller: _select2,
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ),
            Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(prefixIcon: Icon(Icons.qr_code_scanner),border: OutlineInputBorder()),
                      textInputAction: TextInputAction.go,
                      onFieldSubmitted: (go){
                      },
                    ),
                    Text('Scan Barcode'),
                  ],
                )
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(4),
                },
                children: [
                  TableRow( children: [
                    Column(children:[Text('Material', style: TextStyle(fontSize: 20.0))]),
                    Column(children:[Text('Part No', style: TextStyle(fontSize: 20.0))]),
                  ]),
                  TableRow( children: [
                    Column(children:[Text('-',style: TextStyle(color: Colors.green,fontSize: 20.0),)]),
                    Column(children:[Text('-',style: TextStyle(color: Colors.green,fontSize: 20.0))]),
                  ]),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(4),
                },
                children: [
                  TableRow( children: [
                    Column(children:[Text('Part Name', style: TextStyle(fontSize: 20.0))]),
                    Column(children:[Text('Quantity', style: TextStyle(fontSize: 20.0))]),
                  ]),
                  TableRow( children: [
                    Column(children:[Text('-',style: TextStyle(color: Colors.green,fontSize: 20.0))]),
                    Column(children:[Text('-',style: TextStyle(color: Colors.green,fontSize: 20.0))]),
                  ]),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: Table(
                columnWidths: {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(4),
                },
                children: [
                  TableRow( children: [
                    Column(children:[Text('Prod Line', style: TextStyle(fontSize: 20.0))]),
                    Column(children:[Text('Operator', style: TextStyle(fontSize: 20.0))]),
                  ]),
                  TableRow( children: [
                    Column(children:[Text('-',style: TextStyle(color: Colors.green,fontSize: 20.0))]),
                    Column(children:[Text('-',style: TextStyle(color: Colors.green,fontSize: 20.0))]),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 5.0,),
              Text('Support : +91 9884164415',style: TextStyle(color: Colors.black),),
            ],
          ),
        ),
      ),
    );
  }
}
