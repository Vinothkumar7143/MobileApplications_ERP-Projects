import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


import 'contactus.dart';
import 'inward_rollback.dart';
import 'location_mapping.dart';
import 'loginpage.dart';
import 'mat_inward.dart';
import 'package:http/http.dart' as http;

import 'outward_rollback.dart';

enum RadioSel { lab, consumer }

class Outward extends StatefulWidget {
  const Outward({Key? key}) : super(key: key);

  @override
  _OutwardState createState() => _OutwardState();
}

class _OutwardState extends State<Outward> {
  RadioSel? _sel = RadioSel.lab;
  late FocusNode myFocusNode;
  String? _dropcustomer;
  String? _dropdelidate;
  List dropitem = [];
  bool enabled = false;
  List delidate = [];
  var barcode = TextEditingController();
  var custodigit = TextEditingController();
  var mat_code;
  var mat_id;
  var lotno;
  var case_boxes;
  var outqty;
  var cq = TextEditingController();
  var tq = TextEditingController();
  var rq = TextEditingController();
  var bq = TextEditingController();
  var tb = TextEditingController();
  var rb = TextEditingController();
  var bb = TextEditingController();

  fetchCustomerlistandDD() async {
    var url = "http://spaapi.larch.in/home/FetchCustomerList";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    setState(() {
      dropitem = data;
    });
  }

  fetchDD() async {
    print(_dropcustomer);
    var url =
        "http://spaapi.larch.in/home/FetchDeliveryDate?ID=$_dropcustomer";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    print(data);
    setState(() {
      delidate = data;
    });
    _dropdelidate = data[0]['iod_vDeliDate'];
  }

  fetchmatcode() async {
    if(_sel == RadioSel.lab){
      if(barcode.text.contains('#') == true){
        String result = barcode.text.substring(0,barcode.text.indexOf('#'));
        print(result);
        var url =
            "http://spaapi.larch.in/home/FetchOutwardBarcodeDetailsbyConsumer?TruckBarcode=${result}&ConsumerDigit=7";
        var response = await http.get(Uri.parse(url));
        var data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          setState(() {
            mat_code = data[i]['MaterialCode'];
          });
          print(mat_code);
        }
        var url1 =
            "http://spaapi.larch.in/home/FetchOutwardBarcodeDetailsByMaterialId?MaterialCode=$mat_code&CustomerId=$_dropcustomer&DeliDate=$_dropdelidate";
        var response1 = await http.get(Uri.parse(url1));
        var data1 = jsonDecode(response1.body);
        for (int i = 0; i < data1.length; i++) {
          setState(() {
            mat_id = data1[i]['MaterialId'];
            lotno = data1[i]['Unit'];
            case_boxes = data1[i]['Boxes'];
            outqty = data1[i]['Qty'];
          });
          print(mat_id);
          print(lotno);
          print(case_boxes);
          print(outqty);
        }
        var url3 =
            "http://spaapi.larch.in/home/BarcodeOutward?Barcode=${result}&BillDt=$_dropdelidate&Material=$mat_id&LotNo=$lotno&Case=$case_boxes&OutQty=$outqty&TruckNo=$_dropcustomer&Customer=$_dropcustomer";
        var response3 = await http.get(Uri.parse(url3));
        var data3 = jsonDecode(response3.body);
        for (int i = 0; i < data3.length; i++) {
          if (data3[i]['Success'] == '') {
            // ignore: deprecated_member_use
            Widget okbutton = FlatButton(
                onPressed: () {
                  barcode.text = '';
                  myFocusNode.requestFocus();
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
        // var url2 = "https://spaapi.larcherp.com/Home/FetchOutwardDetailsByCustomerIdBillDt?BillDt=256-310821A&CustomerId=667&MaterialId=30513";
        var url2 =
            "http://spaapi.larch.in/home/FetchOutwardDetailsByCustomerIdBillDt?BillDt=$_dropdelidate&CustomerId=$_dropcustomer&MaterialId=$mat_id";
        var response2 = await http.get(Uri.parse(url2));
        var data2 = jsonDecode(response2.body);
        print(data2);
        for (int i = 0; i < data2.length; i++) {
          cq.text = data2[i]['CoverQty'];
          tq.text = data2[i]['TotalQty'];
          rq.text = data2[i]['OutwardQty'];
          bq.text = data2[i]['BalanceQty'];
          tb.text = data2[i]['TotalBoxes'];
          rb.text = data2[i]['OutwardBoxes'];
          bb.text = data2[i]['BalanceBoxes'];
        }
        barcode.text = '';
        myFocusNode.requestFocus();
      }
      else{
        var url =
            "http://spaapi.larch.in/home/FetchOutwardBarcodeDetailsbyConsumer?TruckBarcode=${barcode.text}&ConsumerDigit=7";
        var response = await http.get(Uri.parse(url));
        var data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          setState(() {
            mat_code = data[i]['MaterialCode'];
          });
          print(mat_code);
        }
        var url1 =
            "http://spaapi.larch.in/home/FetchOutwardBarcodeDetailsByMaterialId?MaterialCode=$mat_code&CustomerId=$_dropcustomer&DeliDate=$_dropdelidate";
        var response1 = await http.get(Uri.parse(url1));
        var data1 = jsonDecode(response1.body);
        for (int i = 0; i < data1.length; i++) {
          setState(() {
            mat_id = data1[i]['MaterialId'];
            lotno = data1[i]['Unit'];
            case_boxes = data1[i]['Boxes'];
            outqty = data1[i]['Qty'];
          });
          print(mat_id);
          print(lotno);
          print(case_boxes);
          print(outqty);
        }
        var url3 =
            "http://spaapi.larch.in/home/BarcodeOutward?Barcode=${barcode.text}&BillDt=$_dropdelidate&Material=$mat_id&LotNo=$lotno&Case=$case_boxes&OutQty=$outqty&TruckNo=$_dropcustomer&Customer=$_dropcustomer";
        var response3 = await http.get(Uri.parse(url3));
        var data3 = jsonDecode(response3.body);
        for (int i = 0; i < data3.length; i++) {
          if (data3[i]['Success'] == '') {
            // ignore: deprecated_member_use
            Widget okbutton = FlatButton(
                onPressed: () {
                  barcode.text = '';
                  Navigator.pop(context);
                  myFocusNode.requestFocus();
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
        // var url2 = "https://spaapi.larcherp.com/Home/FetchOutwardDetailsByCustomerIdBillDt?BillDt=256-310821A&CustomerId=667&MaterialId=30513";
        var url2 =
            "http://spaapi.larch.in/home/FetchOutwardDetailsByCustomerIdBillDt?BillDt=$_dropdelidate&CustomerId=$_dropcustomer&MaterialId=$mat_id";
        var response2 = await http.get(Uri.parse(url2));
        var data2 = jsonDecode(response2.body);
        print(data2);
        for (int i = 0; i < data2.length; i++) {
          cq.text = data2[i]['CoverQty'];
          tq.text = data2[i]['TotalQty'];
          rq.text = data2[i]['OutwardQty'];
          bq.text = data2[i]['BalanceQty'];
          tb.text = data2[i]['TotalBoxes'];
          rb.text = data2[i]['OutwardBoxes'];
          bb.text = data2[i]['BalanceBoxes'];
        }
        barcode.text = '';
        myFocusNode.requestFocus();
      }
    }

    else if(_sel == RadioSel.consumer){
      if(barcode.text.contains('#') == true){
        String result = barcode.text.substring(0,barcode.text.indexOf('#'));
        print(result);
        var url =
            "http://spaapi.larch.in/home/FetchOutwardBarcodeDetailsbyConsumer?TruckBarcode=${result}&ConsumerDigit=${custodigit.text}";
        var response = await http.get(Uri.parse(url));
        var data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          setState(() {
            mat_code = data[i]['MaterialCode'];
          });
        }
        var url1 =
            "http://spaapi.larch.in/home/FetchOutwardBarcodeDetailsByMaterialId?MaterialCode=$mat_code&CustomerId=$_dropcustomer&DeliDate=$_dropdelidate";
        var response1 = await http.get(Uri.parse(url1));
        var data1 = jsonDecode(response1.body);
        for (int i = 0; i < data1.length; i++) {
          setState(() {
            mat_id = data1[i]['MaterialId'];
            lotno = data1[i]['Unit'];
            case_boxes = data1[i]['Boxes'];
            outqty = data1[i]['Qty'];
          });
          print(mat_id);
          print(lotno);
          print(case_boxes);
          print(outqty);
        }
        var url3 =
            "http://spaapi.larch.in/home/BarcodeOutward?Barcode=${result}&BillDt=$_dropdelidate&Material=$mat_id&LotNo=$lotno&Case=$case_boxes&OutQty=$outqty&TruckNo=$_dropcustomer&Customer=$_dropcustomer";
        var response3 = await http.get(Uri.parse(url3));
        var data3 = jsonDecode(response3.body);
        for (int i = 0; i < data3.length; i++) {
          if (data3[i]['Success'] == '') {
            // ignore: deprecated_member_use
            Widget okbutton = FlatButton(
                onPressed: () {
                  barcode.text = '';
                  Navigator.pop(context);
                  myFocusNode.requestFocus();
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
        var url2 =
            "http://spaapi.larch.in/home/FetchOutwardDetailsByCustomerIdBillDt?BillDt=$_dropdelidate&CustomerId=$_dropcustomer&MaterialId=$mat_id";
        var response2 = await http.get(Uri.parse(url2));
        var data2 = jsonDecode(response2.body);
        for (int i = 0; i < data2.length; i++) {
          cq.text = data2[i]['CoverQty'];
          tq.text = data2[i]['TotalQty'];
          rq.text = data2[i]['OutwardQty'];
          bq.text = data2[i]['BalanceQty'];
          tb.text = data2[i]['TotalBoxes'];
          rb.text = data2[i]['OutwardBoxes'];
          bb.text = data2[i]['BalanceBoxes'];
        }
        barcode.text = '';
        myFocusNode.requestFocus();
      }
      else{
        var url =
            "http://spaapi.larch.in/home/FetchOutwardBarcodeDetailsbyConsumer?TruckBarcode=${barcode.text}&ConsumerDigit=${custodigit.text}";
        var response = await http.get(Uri.parse(url));
        var data = jsonDecode(response.body);
        for (int i = 0; i < data.length; i++) {
          setState(() {
            mat_code = data[i]['MaterialCode'];
          });
        }
        var url1 =
            "http://spaapi.larch.in/home/FetchOutwardBarcodeDetailsByMaterialId?MaterialCode=$mat_code&CustomerId=$_dropcustomer&DeliDate=$_dropdelidate";
        var response1 = await http.get(Uri.parse(url1));
        var data1 = jsonDecode(response1.body);
        for (int i = 0; i < data1.length; i++) {
          setState(() {
            mat_id = data1[i]['MaterialId'];
            lotno = data1[i]['Unit'];
            case_boxes = data1[i]['Boxes'];
            outqty = data1[i]['Qty'];
          });
          print(mat_id);
          print(lotno);
          print(case_boxes);
          print(outqty);
        }
        var url3 =
            "http://spaapi.larch.in/home/BarcodeOutward?Barcode=${barcode.text}&BillDt=$_dropdelidate&Material=$mat_id&LotNo=$lotno&Case=$case_boxes&OutQty=$outqty&TruckNo=$_dropcustomer&Customer=$_dropcustomer";
        var response3 = await http.get(Uri.parse(url3));
        var data3 = jsonDecode(response3.body);
        for (int i = 0; i < data3.length; i++) {
          if (data3[i]['Success'] == '') {
            // ignore: deprecated_member_use
            Widget okbutton = FlatButton(
                onPressed: () {
                  barcode.text = '';
                  Navigator.pop(context);
                  myFocusNode.requestFocus();
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
        var url2 =
            "http://spaapi.larch.in/home/FetchOutwardDetailsByCustomerIdBillDt?BillDt=$_dropdelidate&CustomerId=$_dropcustomer&MaterialId=$mat_id";
        var response2 = await http.get(Uri.parse(url2));
        var data2 = jsonDecode(response2.body);
        for (int i = 0; i < data2.length; i++) {
          cq.text = data2[i]['CoverQty'];
          tq.text = data2[i]['TotalQty'];
          rq.text = data2[i]['OutwardQty'];
          bq.text = data2[i]['BalanceQty'];
          tb.text = data2[i]['TotalBoxes'];
          rb.text = data2[i]['OutwardBoxes'];
          bb.text = data2[i]['BalanceBoxes'];
        }
        barcode.text = '';
        myFocusNode.requestFocus();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    cq.text = "0";
    tq.text = "0";
    rq.text = "0";
    bq.text = "0";
    tb.text = "0";
    rb.text = "0";
    bb.text = "0";
    myFocusNode=FocusNode();
    fetchCustomerlistandDD();
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
                    'MATERIAL OUTWARD',
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
                              custodigit.text = "";
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
                            });
                          }),
                      Text('CONSUMER'),
                      SizedBox(
                        width: 20.0,
                      ),
                      Container(
                        height: 50.0,
                        width: 100.0,
                        child:
                        TextFormField(
                          enabled: enabled,
                          controller: custodigit,
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Customer:',
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: _dropcustomer,
                        items: dropitem.map((e) {
                          return DropdownMenuItem<String>(
                            child: Text('${e['Customer']}'),
                            value: e['cm_iId'].toString(),
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _dropcustomer = newVal;
                          });
                          fetchDD();
                        },
                      ),
                      // SearchableDropdown(
                      //   items: dropitem.map((e) {
                      //     return DropdownMenuItem<String>(
                      //       child: Text('${e['Customer']}'),
                      //       value: e['cm_iId'].toString(),
                      //     );
                      //   }).toList(),
                      //   value: _dropcustomer,
                      //   hint: "Select one",
                      //   isCaseSensitiveSearch: false,
                      //   searchHint: "Select one",
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _dropcustomer = value;
                      //     });
                      //   },
                      //   isExpanded: true,
                      // ),
                      // SearchChoices.single(
                      //   items: dropitem.map((e) {
                      //     return DropdownMenuItem<String>(
                      //       child: Text('${e['Customer']}'),
                      //       value: e['cm_iId'].toString(),
                      //     );
                      //   }).toList(),
                      //   value: _dropcustomer,
                      //   hint: "Select one",
                      //   searchHint: "Select one",
                      //   onChanged: (value) {
                      //     setState(() {
                      //       _dropcustomer = value;
                      //     });
                      //   },
                      //   isExpanded: true,
                      // )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Delivery Date:',
                        style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      DropdownButton<String>(
                        value: _dropdelidate,
                        items: delidate.map((e) {
                          return DropdownMenuItem<String>(
                            child: Text('${e['iod_vDeliDate']}'),
                            value: e['iod_vDeliDate'],
                          );
                        }).toList(),
                        onChanged: (newVal) {
                          setState(() {
                            _dropdelidate = newVal;
                          });
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Column(
                      children: [
                        TextFormField(
                          focusNode: myFocusNode,
                          controller: barcode,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.go,
                          onFieldSubmitted: (go) {
                            if(barcode.text.isNotEmpty){
                              fetchmatcode();
                            }
                            else{
                              // ignore: deprecated_member_use
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
                                    custodigit.text = '';
                                    Navigator.pop(context);
                                    myFocusNode.requestFocus();
                                  },
                                  child: Text('OK'));

                              AlertDialog alert = AlertDialog(
                                title: Text('Validation'),
                                content: Text('Barcode Field Should Not be Empty'),
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
                ],
              ),
            )));
  }
}
