import 'dart:convert';
import 'dart:async';

import 'package:aptiv_track/receive-issue.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'lotnomapping.dart';

var lotno;
var lotnoreceissue;
var lineid;
var prodname;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var pinno = TextEditingController();
  DateTime timeBackPressed = DateTime.now();
  late FocusNode pinnofocus;

  checkPinNo() async {
    if (pinno.text.isNotEmpty) {
      if (pinno.text == '100100') {
        var url =
            "https://lvmsapi.larch.in/Home/PinVerification?PinNo=${pinno.text}";
        var response = await http.get(Uri.parse(url));
        var data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          if (data[i]['Success'] == '') {
            // ignore: deprecated_member_use
            Widget okbutton = FlatButton(
              onPressed: () {

              },
              child: Text('OK'),
              color: Colors.red,
              textColor: Colors.white,
            );
            AlertDialog _dialog = AlertDialog(
              title: Text('Error'),
              content: Text('${data[i]['Error']}'),
              actions: [okbutton],
            );
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _dialog;
                });
          } else {
            lotno = data[i]['LotNo'];
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LotNoMapping()));
          }
        }
      } else {
        var url1 =
            "https://lvmsapi.larch.in/Home/PinVerification?PinNo=${pinno.text}";
        var response1 = await http.get(Uri.parse(url1));
        var data1 = jsonDecode(response1.body);
        for (int i = 0; i < data1.length; i++) {
          if (data1[i]['Success'] == 'Success') {
            lotnoreceissue = data1[i]['LotNo'];
            lineid = data1[i]['Id'];
            prodname = data1[i]['ProdName'];
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ReceiveIssue()));
          } else {
            // ignore: deprecated_member_use
            Widget okbutton = FlatButton(
              onPressed: () {
                Navigator.pop(context);
                pinno.text = '';
                pinnofocus.requestFocus();
              },
              child: Text('OK'),
              color: Colors.red,
              textColor: Colors.white,
            );
            AlertDialog _dialog = AlertDialog(
              title: Text('Error'),
              content: Text('${data1[i]['Error']}'),
              actions: [okbutton],
            );
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return _dialog;
                });
          }
        }
      }
    } else {
      // ignore: deprecated_member_use
      Widget okbutton = FlatButton(
        child: Text('OK'),
        onPressed: () {
          Navigator.pop(context);
        },
        color: Colors.red,
        textColor: Colors.white,
      );
      AlertDialog _dialog = AlertDialog(
        title: Text('Error'),
        content: Text('Enter PinNo'),
        actions: [okbutton],
      );
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return _dialog;
          });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pinnofocus = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 10.0,
                  ),
                  Image.asset('assets/images/aptiv_logo.png'),
                  SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(30, 0, 40, 20),
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Enter Pin No :',
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(30, 0, 30, 20),
                      child: TextFormField(
                          autofocus: true,
                          focusNode: pinnofocus,
                          controller: pinno,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.pin),
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)))),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ])),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            onPressed: () {
                              checkPinNo();
                            },
                            child: Text('LOGIN'),
                            color: Colors.blue,
                            textColor: Colors.white,
                          )),
                      Container(
                          padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                          // ignore: deprecated_member_use
                          child: FlatButton(
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                            child: Text('Exit'),
                            color: Colors.red,
                            textColor: Colors.white,
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }
}

