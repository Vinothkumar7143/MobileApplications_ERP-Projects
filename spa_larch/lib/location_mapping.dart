import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'contactus.dart';
import 'inward_rollback.dart';
import 'loginpage.dart';
import 'mat_inward.dart';
import 'mat_outward.dart';
import 'package:http/http.dart' as http;

import 'outward_rollback.dart';

class LocationMapping extends StatefulWidget {
  const LocationMapping({Key? key}) : super(key: key);

  @override
  _LocationMappingState createState() => _LocationMappingState();
}

class _LocationMappingState extends State<LocationMapping> {

  var location = TextEditingController();
  var barcode = TextEditingController();
  late FocusNode myFocusNode;
  late FocusNode myLocationNode;
  var message = TextEditingController();

  insertlocation() async {
    if(barcode.text.contains('#')==true){
      String result = barcode.text.substring(0,barcode.text.indexOf('#'));
      var url = "http://spaapi.larch.in/home/InsertBinLocation?BinBarcode=${location.text}&Barcode=$result";
      var response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body);
      for(int i=0;i<data.length;i++){
        if(data[i]['Success'] == ''){
          message.text = 'Error';
          location.text = '';
          barcode.text = '';
          myLocationNode.requestFocus();
        }
        else{
          message.text = 'Success';
          location.text = '';
          barcode.text = '';
          myLocationNode.requestFocus();
        }
      }
    }
    else{
      var url = "http://spaapi.larch.in/home/InsertBinLocation?BinBarcode=${location.text}&Barcode=${barcode.text}";
      var response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body);
      for(int i=0;i<data.length;i++){
        if(data[i]['Success'] == ''){
          message.text = 'Error';
          location.text = '';
          barcode.text = '';
          myLocationNode.requestFocus();
          Navigator.pop(context);
        }
        else{
          message.text = 'Success';
          location.text = '';
          barcode.text = '';
          myLocationNode.requestFocus();
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myLocationNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Image.asset('assets/images/LarchLogo.png',height: 150,width: 150,),
          iconTheme: IconThemeData(color: Colors.blue),
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
                          child: Image.asset(
                            'assets/images/LarchLogo.png',
                          )),
                      Divider(
                        height: 1,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10.0,
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
                            Icon(Icons.location_on_outlined),
                            SizedBox(
                              width: 10.0,
                            ),
                            Text('Location Mapping',
                                style: TextStyle(fontSize: 20.0)),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LocationMapping()));
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            Icon(Icons.arrow_forward),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('Inward Rollback',
                                style: TextStyle(fontSize: 20.0)),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InwardRollback()));
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            Icon(Icons.arrow_back),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('Outward Rollback',
                                style: TextStyle(fontSize: 20.0)),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OutwardRollback()));
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            Icon(Icons.contact_support_outlined),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('Contactus', style: TextStyle(fontSize: 20.0)),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Contactus()));
                        },
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            Icon(Icons.logout_rounded),
                            SizedBox(
                              width: 5.0,
                            ),
                            Text('Logout', style: TextStyle(fontSize: 20.0)),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
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
        body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'LOCATION MAPPING',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 25.0),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Text(
                    'Location:',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextFormField(
                      controller: location,
                      focusNode: myLocationNode,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Enter Location',
                        border: OutlineInputBorder(),
                      ),
                      textInputAction: TextInputAction.go,
                      onFieldSubmitted: (go){
                        myFocusNode.requestFocus();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: barcode,
                          focusNode: myFocusNode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.go,
                          onFieldSubmitted: (go){
                            if(barcode.text.isNotEmpty){
                              insertlocation();
                            }
                            else{
                              // ignore: deprecated_member_use
                              Widget okbutton = FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    myFocusNode.requestFocus();
                                  },
                                  color: Colors.red,
                                  textColor: Colors.white,
                                  child: Text('OK'));

                              AlertDialog dialog = AlertDialog(
                                title: Text('Validation'),
                                content: Text('Scan Barcode'),
                                actions: [okbutton],
                              );

                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return dialog;
                                  });
                            }
                          },
                        ),
                        Text(
                          'Scan Barcode',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextFormField(
                      controller: message,
                      textAlign: TextAlign.center,
                      style: message.text == "Error" ? TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 25.0): TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 25.0),
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  )
                  // Text('Material:',
                  //     style:
                  //         TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                  // SizedBox(
                  //   height: 20.0,
                  // ),
                  // Table(
                  //   columnWidths: {
                  //     0: FlexColumnWidth(4),
                  //     1: FlexColumnWidth(1),
                  //     2: FlexColumnWidth(4),
                  //   },
                  //   children: [
                  //     TableRow(children: [
                  //       Column(
                  //           crossAxisAlignment: CrossAxisAlignment.end,
                  //           children: [
                  //             Text(
                  //               'Location',
                  //               style: TextStyle(
                  //                 fontSize: 20.0,
                  //               ),
                  //             )
                  //           ]),
                  //       Column(children: [
                  //         Text(':', style: TextStyle(fontSize: 20.0))
                  //       ]),
                  //       Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text('R1001',
                  //                 style: TextStyle(
                  //                     fontSize: 20.0, color: Colors.green))
                  //           ]),
                  //     ]),
                  //     TableRow(children: [
                  //       Column(
                  //           crossAxisAlignment: CrossAxisAlignment.end,
                  //           children: [
                  //             Text('Material Code',
                  //                 style: TextStyle(fontSize: 20.0))
                  //           ]),
                  //       Column(children: [
                  //         Text(':', style: TextStyle(fontSize: 20.0))
                  //       ]),
                  //       Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text('XXXXXXXXXXX',
                  //                 style: TextStyle(
                  //                     fontSize: 20.0, color: Colors.green))
                  //           ]),
                  //     ]),
                  //     TableRow(children: [
                  //       Column(
                  //           crossAxisAlignment: CrossAxisAlignment.end,
                  //           children: [
                  //             Text('Material Name',
                  //                 style: TextStyle(fontSize: 20.0))
                  //           ]),
                  //       Column(children: [
                  //         Text(':', style: TextStyle(fontSize: 20.0))
                  //       ]),
                  //       Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text('XXXXXXXXXXXXX',
                  //                 style: TextStyle(
                  //                     fontSize: 20.0, color: Colors.green))
                  //           ]),
                  //     ]),
                  //     TableRow(children: [
                  //       Column(
                  //           crossAxisAlignment: CrossAxisAlignment.end,
                  //           children: [
                  //             Text('Quantity', style: TextStyle(fontSize: 20.0))
                  //           ]),
                  //       Column(children: [
                  //         Text(':', style: TextStyle(fontSize: 20.0))
                  //       ]),
                  //       Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text('10 Nos',
                  //                 style: TextStyle(
                  //                     fontSize: 20.0, color: Colors.green))
                  //           ]),
                  //     ]),
                  //   ],
                  // ),
                ],
              ),
            )));
  }
}
