import 'dart:convert';

import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'package:http/http.dart' as http;

enum RadioSel { store, MFG }

class LotNoMapping extends StatefulWidget {
  const LotNoMapping({Key? key}) : super(key: key);

  @override
  _LotNoMappingState createState() => _LotNoMappingState();
}

class _LotNoMappingState extends State<LotNoMapping> {
  RadioSel? _sel = RadioSel.store;
  var lotnocontroller = TextEditingController();
  var serialno = TextEditingController();
  var partno = TextEditingController();
  var sernobarcode;
  var partnobarocde;
  var qty;
  var someother;
  late FocusNode focuslotno;
  late FocusNode focusserialno;
  late FocusNode focuspartno;

  checkSerialNowithcomma(api_url) async {
    var response = await http.get(Uri.parse(api_url));
    var data = jsonDecode(response.body);
    for (int i = 0; i < data.length; i++) {
      if (data[i]['Success'] == '') {
        Widget okbutton = FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
            serialno.text = '';
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
            serialno.text = '';
            focusserialno.requestFocus();
          },
          color: Colors.red,
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

  checkSerialNowithoutcomma(api_url) async {
    var response = await http.get(Uri.parse(api_url));
    var data = jsonDecode(response.body);
    for (int i = 0; i < data.length; i++) {
      if (data[i]['Success'] == '') {
        Widget okbutton = FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
            serialno.text = '';
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
        setState(() {
          serialno.text = data[i]['Barcode'];
        });
        focuspartno.requestFocus();
      }
    }
  }

  checkPartNo(api_url) async {
    var response = await http.get(Uri.parse(api_url));
    var data = jsonDecode(response.body);
    for (int i = 0; i < data.length; i++) {
      if (data[i]['Success'] == '') {
        Widget okbutton = FlatButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.pop(context);
            serialno.text = '';
            partno.text = '';
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
            serialno.text = '';
            partno.text = '';
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
    print(lotno);
    focuslotno = FocusNode();
    focuspartno = FocusNode();
    focusserialno = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lot No Mapping'),
        centerTitle: true,
        actions: [
          Padding(
              padding: EdgeInsets.only(),
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  icon: Icon(Icons.logout))),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Label : ',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                Radio(
                    value: RadioSel.store,
                    groupValue: _sel,
                    onChanged: (RadioSel? value) {
                      setState(() {
                        _sel = value;
                        lotnocontroller.text = '';
                      });
                    }),
                Text('Store'),
                Radio(
                    value: RadioSel.MFG,
                    groupValue: _sel,
                    onChanged: (RadioSel? value) {
                      setState(() {
                        _sel = value;
                        lotnocontroller.text = lotno;
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
            Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lot No : ',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      autofocus: true,
                      focusNode: focuslotno,
                      controller: lotnocontroller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          prefixIcon: Icon(Icons.qr_code_scanner_sharp)),
                      textInputAction: TextInputAction.go,
                      onFieldSubmitted: (go){
                        focusserialno.requestFocus();
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
                      'Serial No : ',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextFormField(
                      focusNode: focusserialno,
                      controller: serialno,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          prefixIcon: Icon(Icons.qr_code_scanner_sharp)),
                      textInputAction: TextInputAction.go,
                      onFieldSubmitted: (go) {
                        if(serialno.text.contains(';')){
                          final split = serialno.text.split(';');
                          final Map<int, String> values = {
                            for (int i = 0; i < split.length; i++) i: split[i]
                          };
                          sernobarcode = values[0];
                          partnobarocde = values[1];
                          qty = values[2];
                          someother = values[3];
                          var url =
                              "https://lvmsapi.larch.in/Home/SerialNoCheck?SerialNo=${serialno.text}&LotNo=${lotnocontroller.text}";
                          checkSerialNowithcomma(url);
                        }
                        else{
                          var url =
                              "https://lvmsapi.larch.in/Home/SerialNoCheck?SerialNo=${serialno.text}&LotNo=${lotnocontroller.text}";
                          checkSerialNowithoutcomma(url);
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
                      controller: partno,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          prefixIcon: Icon(Icons.qr_code_scanner_sharp)),
                      textInputAction: TextInputAction.go,
                      onFieldSubmitted: (go) {
                        var url =
                            "https://lvmsapi.larch.in/Home/PartNoCheck?SerialNo=${serialno.text}&LotNo=${lotnocontroller.text}&PartNo=${partno.text}";
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
