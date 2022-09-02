import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import 'attendance.dart';
import 'loginpage.dart';

class EditAttendance extends StatefulWidget {

  @override
  _EditAttendanceState createState() => _EditAttendanceState();
}

class _EditAttendanceState extends State<EditAttendance> {
  var editemployeeid;
  var myFormat = DateFormat('dd/MM/yyyy');
  bool management = false;
  String? _dropEmpName;
  var _Employeename = TextEditingController();
  var datecontroller = TextEditingController();
  String? _sel;
  bool managementedit = false;

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2000),
        lastDate: new DateTime(2100)
    );
    String _pic = myFormat.format(picked!);
    print(_pic);
    if(_pic != null) setState(() => datecontroller.text = _pic.toString());
  }

  void editAttendance() async {
    print(attendId);
    var url = "http://m.demo.larchvms.com/Home/FetchAttendanceDetailsById?Id=$attendId";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    for(int i=0;i<data.length;i++){
      setState(() {
        _Employeename.text = data[i]['EmpName'];
        datecontroller.text = data[i]['Date'];
        var trimsel = data[i]['Status'].trim();
        _sel = trimsel;
        editemployeeid = data[i]['EmpId'];
      });
    }
  }

  updateAttendance(url) async {
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    for(int i=0;i<data.length;i++){
      if(data[i]['Success'] == ''){
        showErrorDialog(context, data[i]['Error']);
      }
      else{
        showSuccessDialog(context);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    editAttendance();
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
                IconButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>OutSalesReceivable()));
                }, icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
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
              child: FloatingActionButton(heroTag: "btn6",onPressed: (){
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
          children: [
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Edit Attendance',
                        style: GoogleFonts.mcLaren(fontSize: 25),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Employee : ',
                    style: GoogleFonts.mcLaren(fontSize: 20),
                  ),
                  SizedBox(height: 5.0,),
                  Container(
                      height: 55.0,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: TextFormField(
                        controller: _Employeename,
                        readOnly: true,
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                      )
                  )
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date : ',
                    style: GoogleFonts.mcLaren(fontSize: 20),
                  ),
                  SizedBox(height: 5.0,),
                  Container(
                      height: 55.0,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: TextFormField(
                        readOnly: true,
                        controller: datecontroller,
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                        ),
                      )
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<String>(
                      value: "Present",
                      groupValue: _sel,
                      onChanged: (String? value) {
                        setState(() {
                          _sel = value;
                        });
                      }),
                  Text('Present'),
                  Radio<String>(
                      value: "Absent",
                      groupValue: _sel,
                      onChanged: (String? value) {
                        setState(() {
                          _sel = value;
                        });
                      }),
                  Text('Absent'),
                  Radio<String>(
                      value: "Leave",
                      groupValue: _sel,
                      onChanged: (String? value) {
                        setState(() {
                          _sel = value;
                        });
                      }),
                  Text('Leave'),
                ],
              ),
            ),
            FlatButton(onPressed: () async {
              var url = "http://m.demo.larchvms.com/Home/UpdateAttendance?Id=$attendId&EmpId=$editemployeeid&Date=${datecontroller.text}&Status=$_sel&UpdatedBy=$userid";
              updateAttendance(url);
            },
              child: Text('Update'),color: Colors.green,textColor: Colors.white,),
            SizedBox(height: 30.0,),
            // ElevatedButton(
            //     child: Text('Export To Pdf'),
            //     onPressed: () {
            //       PdfDocument document = _key.currentState!.exportToPdfDocument();
            //       final List<int> bytes = document.save();
            //     }),
          ],
        ),
      ),
    );
  }
}
