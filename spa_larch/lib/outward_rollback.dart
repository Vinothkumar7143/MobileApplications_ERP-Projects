import 'dart:convert';

import 'package:flutter/material.dart';

import 'contactus.dart';
import 'inward_rollback.dart';
import 'location_mapping.dart';
import 'loginpage.dart';
import 'mat_inward.dart';
import 'mat_outward.dart';
import 'package:http/http.dart' as http;

class OutwardRollback extends StatefulWidget {
  const OutwardRollback({Key? key}) : super(key: key);

  @override
  _OutwardRollbackState createState() => _OutwardRollbackState();
}

class _OutwardRollbackState extends State<OutwardRollback> {
  late FocusNode myFocusNode;
  var t_barcode = TextEditingController();
  var mat_code = TextEditingController();
  var mat_name = TextEditingController();
  var qty = TextEditingController();

  fetchapi(fetch_url) async {
    var response = await http.get(Uri.parse(fetch_url));
    var data = await jsonDecode(response.body);
    for (var i = 0; i < data.length; i++) {
      if (data[i]["MaterialCode"] == '') {
        Widget okbutton = FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.red,
            textColor: Colors.white,
            child: Text('OK'));

        AlertDialog dialog = AlertDialog(
          title: Text('Validation'),
          content: Text("${data[i]["Error"]}"),
          actions: [okbutton],
        );

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialog;
            });
      } else {
        mat_code.text = data[i]["MaterialCode"];
        mat_name.text = data[i]["MaterialName"];
        qty.text = data[i]["Qty"];
      }
    }
  }

  rollbackbarcode(rollback_url) async {
    var response = await http.get(Uri.parse(rollback_url));
    var data = jsonDecode(response.body);
    for (var i = 0; i < data.length; i++) {
      if (data[i]["Success"] == '') {
        Widget okbutton = FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.red,
            textColor: Colors.white,
            child: Text('OK'));

        AlertDialog dialog = AlertDialog(
          title: Text('Validation'),
          content: Text("${data[i]["Error"]}"),
          actions: [okbutton],
        );

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialog;
            });
        myFocusNode.requestFocus();
      } else {
        Widget okbutton = FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.red,
            textColor: Colors.white,
            child: Text('OK'));

        AlertDialog dialog = AlertDialog(
          title: Text('Validation'),
          content: Text("${data[i]["Success"]}"),
          actions: [okbutton],
        );

        showDialog(
            context: context,
            builder: (BuildContext context) {
              return dialog;
            });
        t_barcode.text = '';
        mat_code.text = '';
        mat_name.text = '';
        qty.text = '';
        myFocusNode.requestFocus();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode = FocusNode();
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Inward()));
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Outward()));
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
                            width: 5.0,
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
              children: [
                Text(
                  'OUTWARD ROLLBACK',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      fontSize: 25.0),
                ),
                SizedBox(
                  height: 35.0,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: TextFormField(
                    controller: t_barcode,
                    focusNode: myFocusNode,
                    autofocus: true,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (go) {
                      if(t_barcode.text.isNotEmpty){
                        if(t_barcode.text.contains('#')==true){
                          String result = t_barcode.text.substring(0,t_barcode.text.indexOf('#'));
                          var url =
                              "http://spaapi.larch.in/home/FetchBarcodeDetailsRollback?Barcode=${result}";
                          fetchapi(url);
                        }
                        else{
                          var url =
                              "http://spaapi.larch.in/home/FetchBarcodeDetailsRollback?Barcode=${t_barcode.text}";
                          fetchapi(url);
                        }
                      }
                      else{
                        Widget okbutton = FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
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
                        myFocusNode.requestFocus();
                      }
                    },
                  ),
                ),
                Text('Scan Barcode'),
                SizedBox(
                  height: 35.0,
                ),
                Column(
                  children: [
                    Text(
                      'Material Code',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: TextFormField(
                        controller: mat_code,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(border: OutlineInputBorder()),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 35.0,
                ),
                Column(
                  children: [
                    Text(
                      'Material name',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: TextFormField(
                        controller: mat_name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(border: OutlineInputBorder()),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 35.0,
                ),
                Column(
                  children: [
                    Text(
                      'Quantity',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: TextFormField(
                        controller: qty,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      height: 35.0,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: FlatButton(
                        child: Text('Rollback'),
                        onPressed: () {

                          if(t_barcode.text.contains('#')==true){
                            String result1 = t_barcode.text.substring(0,t_barcode.text.indexOf('#'));
                            var roll_url =
                                "http://spaapi.larch.in/home/OutwardRollback?Barcode=${result1}";
                            rollbackbarcode(roll_url);
                          }
                          else{
                            var roll_url =
                                "http://spaapi.larch.in/home/OutwardRollback?Barcode=${t_barcode.text}";
                            rollbackbarcode(roll_url);
                          }
                        },
                        color: Colors.green,
                        textColor: Colors.white,
                      ),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
