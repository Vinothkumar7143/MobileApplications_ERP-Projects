import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'contactus.dart';
import 'inward_rollback.dart';
import 'location_mapping.dart';
import 'loginpage.dart';
import 'mat_outward.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'outward_rollback.dart';

enum RadioSel { lab, consumer }

class Inward extends StatefulWidget {
  const Inward({Key? key}) : super(key: key);

  @override
  _InwardState createState() => _InwardState();
}

class _InwardState extends State<Inward> {
  var start = "#";
  late FocusNode myFocusNode;
  late FocusNode barcodeFocus;
  String? mySelection;
  RadioSel? _sel = RadioSel.lab;
  var _dropdate;
  var _droptrack;
  var datecontroller = TextEditingController();
  var consumerdigit = TextEditingController();
  var barcode = TextEditingController();
  var picked;
  var materialcode;
  var materialid;
  var icase;
  var inqty;
  List dropitem = [];
  bool enabled = false;
  var cq = TextEditingController();
  var tq = TextEditingController();
  var rq = TextEditingController();
  var bq = TextEditingController();
  var tb = TextEditingController();
  var rb = TextEditingController();
  var bb = TextEditingController();
  DateTime _selecteddate = DateTime.now();
  _selectDate(BuildContext context) async {
    picked = await showDatePicker(
        context: context,
        initialDate: _selecteddate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        _selecteddate = picked;
        datecontroller.text = DateFormat('dd.MM.y').format(_selecteddate);
      });
    fetchtruckdetail();
  }

  fetchtruckdetail() async {
    var url =
        "http://spaapi.larch.in/home/FetchTruckNo?Dt=${datecontroller.text}";
    print(datecontroller.text);
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    setState(() {
      dropitem = data;
    });
    mySelection = data[0]['TruckNo'];
    print(mySelection);
    // var url =
    //     "http://api.larchvms.com/Home/VisitorDetailsByMPINNumber?Mpin=1234";
    // var response = await http.get(Uri.parse(url));
    // var data = jsonDecode(response.body);
    // setState(() {
    //   dropitem = data;
    // });
    // mySelection = data[1]['PersonName'];
    // print(mySelection);
  }

  fetchmatcode() async {
    if(_sel == RadioSel.lab){
      if(barcode.text.contains('#') == true){
        String result = barcode.text.substring(0,barcode.text.indexOf('#'));
        print(result);
        var url =
            "http://spaapi.larch.in/home/FetchInwardBarcodeDetailsbyConsumer?TruckBarcode=${result}&ConsumerDigit=7";
        var response = await http.get(Uri.parse(url));
        var data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          setState(() {
            materialcode = data[i]['MaterialCode'];
          });
          print(materialcode);
        }
        var url1 =
            "http://spaapi.larch.in/home/FetchInwardBarcodeDetailsbyMaterialCode?MaterialCode=$materialcode&TruckBarcode=${mySelection}&BillDt=${datecontroller.text}";
        var response1 = await http.get(Uri.parse(url1));
        var data1 = jsonDecode(response1.body);
        for (int i = 0; i < data1.length; i++) {
          setState(() {
            materialid = data1[i]['MaterialId'];
            icase = data1[i]['iCase'];
            inqty = data1[i]['Qty'];
          });
          print(materialid);
          print(icase);
          print(inqty);
        }
        var url3 =
            "http://spaapi.larch.in/home/BarcodeInward?Barcode=${result}&BillDt=${datecontroller.text}&Material=$materialid&LotNo=1&Case=$icase&InQty=$inqty&TruckNo=$mySelection";
        // var url3 =
        //     "https://spaapi.larcherp.com/Home/BarcodeInward?Barcode=00924423821008931741BT1B1501038&BillDt=27.08.2021&Material=30503&LotNo=1&Case=1&InQty=1&TruckNo=TN12R7636";
        var response3 = await http.get(Uri.parse(url3));
        var data3 = jsonDecode(response3.body);
        for (int i = 0; i < data3.length; i++) {
          if (data3[i]['Success'] == '') {
            Widget okbutton = FlatButton(
                onPressed: () {
                  barcode.text = '';
                  barcodeFocus.requestFocus();
                  Navigator.pop(context);
                },
                child: Text('OK'));

            AlertDialog alert = AlertDialog(
              title: Text('Validation'),
              content: Text('${data3[i]['Error']}'),
              actions: [okbutton],
            );
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                });
          }
        }
        print(mySelection);
        print(datecontroller.text);
        var url2 =
            "http://spaapi.larch.in/home/FetchInwardDetailsByCustomerIdBillDt?TruckNo=$mySelection&BillDt=${datecontroller.text}&MaterialId=$materialid";
        var response2 = await http.get(Uri.parse(url2));
        var data2 = jsonDecode(response2.body);
        print(data2);
        for (int i = 0; i < data2.length; i++) {
          cq.text = data2[i]['CoverQty'];
          tq.text = data2[i]['TotalQty'];
          rq.text = data2[i]['ReceivedQty'];
          bq.text = data2[i]['BalanceQty'];
          tb.text = data2[i]['TotalBoxes'];
          rb.text = data2[i]['ReceivedBoxes'];
          bb.text = data2[i]['BalanceBoxes'];
        }
        barcode.text = '';
        barcodeFocus.requestFocus();
      }
      else{
        var url =
            "http://spaapi.larch.in/home/FetchInwardBarcodeDetailsbyConsumer?TruckBarcode=${barcode.text}&ConsumerDigit=7";
        var response = await http.get(Uri.parse(url));
        var data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          setState(() {
            materialcode = data[i]['MaterialCode'];
          });
          print(materialcode);
        }
        var url1 =
            "http://spaapi.larch.in/home/FetchInwardBarcodeDetailsbyMaterialCode?MaterialCode=$materialcode&TruckBarcode=${mySelection}&BillDt=${datecontroller.text}";
        var response1 = await http.get(Uri.parse(url1));
        var data1 = jsonDecode(response1.body);
        for (int i = 0; i < data1.length; i++) {
          setState(() {
            materialid = data1[i]['MaterialId'];
            icase = data1[i]['iCase'];
            inqty = data1[i]['Qty'];
          });
          print(materialid);
          print(icase);
          print(inqty);
        }
        var url3 =
            "http://spaapi.larch.in/home/BarcodeInward?Barcode=${barcode.text}&BillDt=${datecontroller.text}&Material=$materialid&LotNo=1&Case=$icase&InQty=$inqty&TruckNo=$mySelection";
        // var url3 =
        //     "https://spaapi.larcherp.com/Home/BarcodeInward?Barcode=00924423821008931741BT1B1501038&BillDt=27.08.2021&Material=30503&LotNo=1&Case=1&InQty=1&TruckNo=TN12R7636";
        var response3 = await http.get(Uri.parse(url3));
        var data3 = jsonDecode(response3.body);
        for (int i = 0; i < data3.length; i++) {
          if (data3[i]['Success'] == '') {
            Widget okbutton = FlatButton(
                onPressed: () {
                  barcode.text = '';
                  barcodeFocus.requestFocus();
                  Navigator.pop(context);
                },
                child: Text('OK'));

            AlertDialog alert = AlertDialog(
              title: Text('Validation'),
              content: Text('${data3[i]['Error']}'),
              actions: [okbutton],
            );
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                });
          }
        }
        print(mySelection);
        print(datecontroller.text);
        var url2 =
            "http://spaapi.larch.in/home/FetchInwardDetailsByCustomerIdBillDt?TruckNo=$mySelection&BillDt=${datecontroller.text}&MaterialId=$materialid";
        var response2 = await http.get(Uri.parse(url2));
        var data2 = jsonDecode(response2.body);
        print(data2);
        for (int i = 0; i < data2.length; i++) {
          cq.text = data2[i]['CoverQty'];
          tq.text = data2[i]['TotalQty'];
          rq.text = data2[i]['ReceivedQty'];
          bq.text = data2[i]['BalanceQty'];
          tb.text = data2[i]['TotalBoxes'];
          rb.text = data2[i]['ReceivedBoxes'];
          bb.text = data2[i]['BalanceBoxes'];
        }
        barcode.text = '';
        barcodeFocus.requestFocus();
      }
    }

    else if(_sel == RadioSel.consumer){
      if(barcode.text.contains('#') == true){
        String result = barcode.text.substring(0,barcode.text.indexOf('#'));
        print(result);
        var url =
            "http://spaapi.larch.in/home/FetchInwardBarcodeDetailsbyConsumer?TruckBarcode=${result}&ConsumerDigit=${consumerdigit.text}";
        var response = await http.get(Uri.parse(url));
        var data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          setState(() {
            materialcode = data[i]['MaterialCode'];
          });
          print(materialcode);
        }
        var url1 =
            "http://spaapi.larch.in/home/FetchInwardBarcodeDetailsbyMaterialCode?MaterialCode=$materialcode&TruckBarcode=${mySelection}&BillDt=${datecontroller.text}";
        var response1 = await http.get(Uri.parse(url1));
        var data1 = jsonDecode(response1.body);
        for (int i = 0; i < data1.length; i++) {
          setState(() {
            materialid = data1[i]['MaterialId'];
            icase = data1[i]['iCase'];
            inqty = data1[i]['Qty'];
          });
          print(materialid);
          print(icase);
          print(inqty);
        }
        var url3 =
            "http://spaapi.larch.in/home/BarcodeInward?Barcode=${result}&BillDt=${datecontroller.text}&Material=$materialid&LotNo=1&Case=$icase&InQty=$inqty&TruckNo=$mySelection";
        // var url3 =
        //     "https://spaapi.larcherp.com/Home/BarcodeInward?Barcode=00924423821008931741BT1B1501038&BillDt=27.08.2021&Material=30503&LotNo=1&Case=1&InQty=1&TruckNo=TN12R7636";
        var response3 = await http.get(Uri.parse(url3));
        var data3 = jsonDecode(response3.body);
        for (int i = 0; i < data3.length; i++) {
          if (data3[i]['Success'] == '') {
            Widget okbutton = FlatButton(
                onPressed: () {
                  barcode.text = '';
                  barcodeFocus.requestFocus();
                  Navigator.pop(context);
                },
                child: Text('OK'));

            AlertDialog alert = AlertDialog(
              title: Text('Validation'),
              content: Text('${data3[i]['Error']}'),
              actions: [okbutton],
            );
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                });
          }
        }
        print(mySelection);
        print(datecontroller.text);
        var url2 =
            "http://spaapi.larch.in/home/FetchInwardDetailsByCustomerIdBillDt?TruckNo=$mySelection&BillDt=${datecontroller.text}&MaterialId=$materialid";
        var response2 = await http.get(Uri.parse(url2));
        var data2 = jsonDecode(response2.body);
        print(data2);
        for (int i = 0; i < data2.length; i++) {
          cq.text = data2[i]['CoverQty'];
          tq.text = data2[i]['TotalQty'];
          rq.text = data2[i]['ReceivedQty'];
          bq.text = data2[i]['BalanceQty'];
          tb.text = data2[i]['TotalBoxes'];
          rb.text = data2[i]['ReceivedBoxes'];
          bb.text = data2[i]['BalanceBoxes'];
        }
        barcode.text = '';
        barcodeFocus.requestFocus();
      }
      else{
        var url =
            "http://spaapi.larch.in/home/FetchInwardBarcodeDetailsbyConsumer?TruckBarcode=${barcode.text}&ConsumerDigit=${consumerdigit.text}";
        var response = await http.get(Uri.parse(url));
        var data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          setState(() {
            materialcode = data[i]['MaterialCode'];
          });
          print(materialcode);
        }
        var url1 =
            "http://spaapi.larch.in/home/FetchInwardBarcodeDetailsbyMaterialCode?MaterialCode=$materialcode&TruckBarcode=${mySelection}&BillDt=${datecontroller.text}";
        var response1 = await http.get(Uri.parse(url1));
        var data1 = jsonDecode(response1.body);
        for (int i = 0; i < data1.length; i++) {
          setState(() {
            materialid = data1[i]['MaterialId'];
            icase = data1[i]['iCase'];
            inqty = data1[i]['Qty'];
          });
          print(materialid);
          print(icase);
          print(inqty);
        }
        var url3 =
            "http://spaapi.larch.in/home/BarcodeInward?Barcode=${barcode.text}&BillDt=${datecontroller.text}&Material=$materialid&LotNo=1&Case=$icase&InQty=$inqty&TruckNo=$mySelection";
        // var url3 =
        //     "https://spaapi.larcherp.com/Home/BarcodeInward?Barcode=00924423821008931741BT1B1501038&BillDt=27.08.2021&Material=30503&LotNo=1&Case=1&InQty=1&TruckNo=TN12R7636";
        var response3 = await http.get(Uri.parse(url3));
        var data3 = jsonDecode(response3.body);
        for (int i = 0; i < data3.length; i++) {
          if (data3[i]['Success'] == '') {
            Widget okbutton = FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'));

            AlertDialog alert = AlertDialog(
              title: Text('Validation'),
              content: Text('${data3[i]['Error']}'),
              actions: [okbutton],
            );
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                });
            barcode.text = '';
            barcodeFocus.requestFocus();
          }
        }
        print(mySelection);
        print(datecontroller.text);
        var url2 =
            "http://spaapi.larch.in/home/FetchInwardDetailsByCustomerIdBillDt?TruckNo=$mySelection&BillDt=${datecontroller.text}&MaterialId=$materialid";
        var response2 = await http.get(Uri.parse(url2));
        var data2 = jsonDecode(response2.body);
        print(data2);
        for (int i = 0; i < data2.length; i++) {
          cq.text = data2[i]['CoverQty'];
          tq.text = data2[i]['TotalQty'];
          rq.text = data2[i]['ReceivedQty'];
          bq.text = data2[i]['BalanceQty'];
          tb.text = data2[i]['TotalBoxes'];
          rb.text = data2[i]['ReceivedBoxes'];
          bb.text = data2[i]['BalanceBoxes'];
        }
        barcode.text = '';
        barcodeFocus.requestFocus();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cq.text = "0";
    tq.text = "0";
    rq.text = "0";
    bq.text = "0";
    tb.text = "0";
    rb.text = "0";
    bb.text = "0";
    fetchtruckdetail();
    myFocusNode = FocusNode();
    barcodeFocus = FocusNode();
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'MATERIAL INWARD',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 25.0),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                          value: RadioSel.lab,
                          groupValue: _sel,
                          onChanged: (RadioSel? value) {
                            setState(() {
                              _sel = value;
                              enabled = false;
                              consumerdigit.text = "";
                            });
                          }),
                      Text('LAB'),
                      Radio(
                          value: RadioSel.consumer,
                          groupValue: _sel,
                          onChanged: (RadioSel? value) {
                            setState(() {
                              _sel = value;
                              enabled = true;
                              myFocusNode.requestFocus();
                            });
                          }),
                      Text('CONSUMER'),
                      SizedBox(
                        width: 20.0,
                      ),
                      Container(
                        height: 50.0,
                        width: 100.0,
                        child: TextFormField(
                          enabled: enabled,
                          focusNode: myFocusNode,
                          controller: consumerdigit,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Billing Date:',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    // width: 270.0,
                    // height: 50.0,
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextFormField(
                        controller: datecontroller,
                        decoration: InputDecoration(
                          hintText: 'Choose Date',
                          border: OutlineInputBorder(),
                          suffixIcon: FlatButton(
                            child: Icon(Icons.calendar_today),
                            onPressed: () {
                              _selectDate(context);
                            },
                          ),
                        )),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Truck No:',
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      DropdownButton<String>(
                        value: mySelection,
                        items: dropitem.map((e) {
                          print(mySelection);
                          return DropdownMenuItem<String>(
                            child: Text(e['TruckNo']),
                            value: e['TruckNo'],
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            mySelection = newVal;
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Text(
                  //       'Location:',
                  //       style:
                  //           TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  //     ),
                  //     SizedBox(
                  //       width: 10.0,
                  //     ),
                  //     Container(
                  //       width: 270.0,
                  //       height: 50.0,
                  //       child: TextFormField(
                  //         decoration: InputDecoration(
                  //           hintText: 'Enter Location',
                  //           border: OutlineInputBorder(),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: barcode,
                          focusNode: barcodeFocus,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.go,
                          onFieldSubmitted: (go) {
                            if (barcode.text.isNotEmpty) {
                              fetchmatcode();
                            }
                            else{
                              Widget okbutton = FlatButton(
                                  onPressed: () {
                                    barcode.text = '';
                                    cq.text = '';
                                    tq.text = '';
                                    rq.text = '';
                                    bq.text = '';
                                    tb.text = '';
                                    rb.text = '';
                                    bb.text = '';
                                    consumerdigit.text = '';
                                    Navigator.pop(context);
                                    barcodeFocus.requestFocus();
                                  },
                                  child: Text('OK'));

                              AlertDialog alert = AlertDialog(
                                title: Text('Validation'),
                                content: Text('Barcode Field Should be Empty'),
                                actions: [okbutton],
                              );
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
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
                  Text('Material',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                  SizedBox(
                    height: 20.0,
                  ),
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(5),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(4),
                    },
                    // border: TableBorder.all(),
                    children: [
                      TableRow(children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Cover Quantity',
                                  style: TextStyle(fontSize: 20.0))
                            ]),
                        Column(children: [
                          Text(':', style: TextStyle(fontSize: 20.0))
                        ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text('$cq Nos',
                              //     style: TextStyle(
                              //         fontSize: 20.0, color: Colors.green)),
                              Container(
                                height: 30.0,
                                width: 100.0,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: TextFormField(
                                        enabled: enabled,
                                        controller: cq,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    Text('Nos',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
                                  ],
                                ),
                              ),
                            ]),
                      ]),
                      TableRow(children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Total Quantity',
                                  style: TextStyle(fontSize: 20.0))
                            ]),
                        Column(children: [
                          Text(':', style: TextStyle(fontSize: 20.0))
                        ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text('$tq Nos',
                              //     style: TextStyle(
                              //         fontSize: 20.0, color: Colors.green))
                              Container(
                                height: 30.0,
                                width: 100.0,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: TextFormField(
                                        enabled: enabled,
                                        controller: tq,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    Text('Nos',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
                                  ],
                                ),
                              ),
                            ]),
                      ]),
                      TableRow(children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Received Quantity',
                                  style: TextStyle(fontSize: 20.0))
                            ]),
                        Column(children: [
                          Text(':', style: TextStyle(fontSize: 20.0))
                        ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text('$rq Nos',
                              //     style: TextStyle(
                              //         fontSize: 20.0, color: Colors.green))
                              Container(
                                height: 30.0,
                                width: 100.0,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: TextFormField(
                                        enabled: enabled,
                                        controller: rq,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    Text('Nos',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
                                  ],
                                ),
                              ),
                            ]),
                      ]),
                      TableRow(children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Balance Quantity',
                                  style: TextStyle(fontSize: 20.0))
                            ]),
                        Column(children: [
                          Text(':', style: TextStyle(fontSize: 20.0))
                        ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text('$bq Nos',
                              //     style: TextStyle(
                              //         fontSize: 20.0, color: Colors.green))
                              Container(
                                height: 30.0,
                                width: 100.0,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: TextFormField(
                                        enabled: enabled,
                                        controller: bq,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    Text('Nos',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
                                  ],
                                ),
                              ),
                            ]),
                      ]),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text('Truck',
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                  SizedBox(
                    height: 20.0,
                  ),
                  Table(
                    columnWidths: {
                      0: FlexColumnWidth(5),
                      1: FlexColumnWidth(2),
                      2: FlexColumnWidth(4),
                    },
                    children: [
                      TableRow(children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Total Boxes', style: TextStyle(fontSize: 20.0))
                            ]),
                        Column(children: [
                          Text(':', style: TextStyle(fontSize: 20.0))
                        ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text('$tb Nos',
                              //     style: TextStyle(
                              //         fontSize: 20.0, color: Colors.green))
                              Container(
                                height: 30.0,
                                width: 100.0,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: TextFormField(
                                        enabled: enabled,
                                        controller: tb,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    Text('Nos',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
                                  ],
                                ),
                              ),
                            ]),
                      ]),
                      TableRow(children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Received Boxes',
                                  style: TextStyle(fontSize: 20.0))
                            ]),
                        Column(children: [
                          Text(':', style: TextStyle(fontSize: 20.0))
                        ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text('$tb Nos',
                              //     style: TextStyle(
                              //         fontSize: 20.0, color: Colors.green))
                              Container(
                                height: 30.0,
                                width: 100.0,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: TextFormField(
                                        enabled: enabled,
                                        controller: rb,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    Text('Nos',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
                                  ],
                                ),
                              ),
                            ]),
                      ]),
                      TableRow(children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Balance Boxes',
                                  style: TextStyle(fontSize: 20.0))
                            ]),
                        Column(children: [
                          Text(':', style: TextStyle(fontSize: 20.0))
                        ]),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text('$bb Nos',
                              //      style: TextStyle(
                              //          fontSize: 20.0, color: Colors.green))
                              Container(
                                height: 30.0,
                                width: 100.0,
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: TextFormField(
                                        enabled: enabled,
                                        controller: bb,
                                        textAlign: TextAlign.right,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    Text('Nos',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 15.0),),
                                  ],
                                ),
                              ),
                            ]),
                      ]),
                    ],
                  ),
                  SizedBox(
                    height: 30.0,
                  )
                ],
              ),
            )));
  }
}
