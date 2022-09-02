import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'loginpage.dart';

enum RadioSel { store, MFG }
enum RadioSel1 { receive, issue }

class ReceiveIssue extends StatefulWidget {
  const ReceiveIssue({Key? key}) : super(key: key);

  @override
  _ReceiveIssueState createState() => _ReceiveIssueState();
}

class _ReceiveIssueState extends State<ReceiveIssue> {
  // RadioSel? _sel = RadioSel.store;
  // RadioSel1? _sel1 = RadioSel1.receive;
  String? _sel1;
  String? _sel;
  var serialnocontroller = TextEditingController();
  var partnocontroller = TextEditingController();
  var result1;
  late FocusNode focusserialno;
  late FocusNode focuspartno;

  checkSerialNoWithcomma(url) async {
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    for(int i=0;i<data.length;i++){
      if (data[i]['Success'] == '') {
        Widget okbutton = FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
            serialnocontroller.text = '';
            focusserialno.requestFocus();
          },
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
        Widget okbutton = FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
            serialnocontroller.text = '';
            focusserialno.requestFocus();
          },
          color: Colors.green,
          textColor: Colors.white,
        );
        AlertDialog _dialog = AlertDialog(
          title: Text('Success'),
          content: Text('${data[i]['Success']}'),
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

  checkSerialNoWithoutcomma(url) async {
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    for (int i = 0; i < data.length; i++) {
      if (data[i]['Success'] == '') {
        Widget okbutton = FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
            serialnocontroller.text = '';
            focusserialno.requestFocus();
          },
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
      }
      else if (data[i]['Success'] == 'Success') {
        setState(() {
          serialnocontroller.text = data[i]['Barcode'];
        });
        focuspartno.requestFocus();
      }
      else {
        Widget okbutton = FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
            serialnocontroller.text = '';
            focusserialno.requestFocus();
          },
          color: Colors.green,
          textColor: Colors.white,
        );
        AlertDialog _dialog = AlertDialog(
          title: Text('Success'),
          content: Text('${data[i]['Success']}'),
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

  checkPartNo(url) async {
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    for(int i=0;i<data.length;i++){
      if (data[i]['Success'] == '') {
        Widget okbutton = FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
            partnocontroller.text = '';
            focuspartno.requestFocus();
          },
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
      }
      else{
        Widget okbutton = FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
            serialnocontroller.text = '';
            partnocontroller.text = '';
            focusserialno.requestFocus();
          },
          color: Colors.green,
          textColor: Colors.white,
        );
        AlertDialog _dialog = AlertDialog(
          title: Text('Success'),
          content: Text('${data[i]['Success']}'),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(lineid);
    print(lotnoreceissue);
    focuspartno = FocusNode();
    focusserialno = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Receive/Issue',
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  icon: Icon(Icons.logout)))
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.0,),
            Text('$prodname',style: TextStyle(fontSize: 20.0,color: Colors.green),),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Label : ',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Radio<String>(
                    value: "Store",
                    groupValue: _sel,
                    onChanged: (String? value) {
                      setState(() {
                        _sel = value;
                      });
                    }),
                Text('Store'),
                Radio<String>(
                    value: "Manufacturing",
                    groupValue: _sel,
                    onChanged: (String? value) {
                      setState(() {
                        _sel = value;
                      });
                    }),
                Text('MFG'),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Divider(
                height: 10,
                thickness: 1,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Process : ',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Radio<String>(
                    value: "Receive",
                    groupValue: _sel1,
                    onChanged: (String? val) {
                      setState(() {
                        _sel1 = val;
                      });
                    }),
                Text('Receive'),
                Radio<String>(
                    value: "Issue",
                    groupValue: _sel1,
                    onChanged: (String? val) {
                      setState(() {
                        _sel1 = val;
                      });
                    }),
                Text('Issue'),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: Divider(
                height: 10,
                thickness: 1,
              ),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aptiv Label/Serial No : ',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      autofocus: true,
                      focusNode: focusserialno,
                      controller: serialnocontroller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          prefixIcon: Icon(Icons.qr_code_scanner_sharp)),
                      textInputAction: TextInputAction.go,
                      onFieldSubmitted: (go){
                        if(_sel == null && _sel1 == null){
                          Widget okbutton = FlatButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.pop(context);
                              serialnocontroller.text = '';
                              partnocontroller.text = '';
                              focusserialno.requestFocus();
                            },
                            color: Colors.red,
                            textColor: Colors.white,
                          );
                          AlertDialog _dialog = AlertDialog(
                            title: Text('Error'),
                            content: Text('Choose Label and Process'),
                            actions: [okbutton],
                          );
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _dialog;
                              });
                        }
                        else{
                          if(serialnocontroller.text.contains(';')){
                            var url = "https://lvmsapi.larch.in/Home/ProcessVerifyLabelCheck?SerialNo=${serialnocontroller.text}&Process=$_sel1&Type=$_sel&LotNo=$lotnoreceissue&LineId=$lineid";
                            checkSerialNoWithcomma(url);
                          }
                          else{
                            var url = "https://lvmsapi.larch.in/Home/ProcessVerifyLabelCheck?SerialNo=${serialnocontroller.text}&Process=$_sel1&Type=$_sel&LotNo=$lotnoreceissue&LineId=$lineid";
                            checkSerialNoWithoutcomma(url);
                          }
                        }
                      },
                    ),
                  ],
                )),
            Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Part No : ',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      focusNode: focuspartno,
                      controller: partnocontroller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          prefixIcon: Icon(Icons.qr_code_scanner_sharp)),
                      textInputAction: TextInputAction.go,
                      onFieldSubmitted: (go){
                        var url = "https://lvmsapi.larch.in/Home/ProcessVerifyPartNoCheck?SerialNo=${serialnocontroller.text}&PartNo=${partnocontroller.text}&Process=$_sel1&Type=$_sel&LotNo=$lotnoreceissue&LineId=$lineid";
                        checkPartNo(url);
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
