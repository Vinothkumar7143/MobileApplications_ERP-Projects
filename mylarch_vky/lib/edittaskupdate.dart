import 'dart:convert';

import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:mylarch_vky/attendance.dart';
import 'package:mylarch_vky/taskupdate.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'dashboard.dart';
import 'loginpage.dart';



class EditTaskUpdate extends StatefulWidget {
  const EditTaskUpdate({Key? key}) : super(key: key);

  @override
  _EditTaskUpdateState createState() => _EditTaskUpdateState();
}

class _EditTaskUpdateState extends State<EditTaskUpdate> {
  BsSelectBoxController _select1 = BsSelectBoxController();
  BsSelectBoxController _select2 = BsSelectBoxController();
  BsSelectBoxController _select3 = BsSelectBoxController();
  BsSelectBoxController _select4 = BsSelectBoxController();
  BsSelectBoxController _select5 = BsSelectBoxController();
  BsSelectBoxController _select6 = BsSelectBoxController();

  var decpcontroller = TextEditingController();
  var _Employeename = TextEditingController();
  var datecontroller = TextEditingController();
  var myFormat = DateFormat('dd/MM/yyyy');

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2000),
        lastDate: new DateTime(2100)
    );
    String _pic = myFormat.format(picked!);
    // print(_pic);
    if(_pic != null) setState(() => datecontroller.text = _pic.toString());
  }

  selectContributor() async {
    var url;
    management == true?
    url = "http://m.demo.larchvms.com/Home/FetchContributorDrp?Id=0" :
    url = "http://m.demo.larchvms.com/Home/FetchContributorDrp?Id=$userid";
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    _select1.setOptions([
      for(int i=0;i<json.length;i++)
        BsSelectBoxOption(value: json[i]['Id'], text: Text('${json[i]['Name']}'))
    ]);
  }

  selectproject() async {
    var url;
    url = "http://m.demo.larchvms.com/Home/FetchProjectDrp?ContributorId=${_select1.getSelected()!.getValue()}&RoleId=$rightid";
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    _select2.setOptions([
      for(int i=0;i<json.length;i++)
        BsSelectBoxOption(value: json[i]['Id'], text: Text('${json[i]['Name']}'))
    ]);
    _select2.setSelected(BsSelectBoxOption(value: json[0]['Id'], text: Text('${json[0]['Name']}')));
  }

  selectEmployee() async {
    var url;
    management == true ?
    url = "http://m.demo.larchvms.com/Home/FetchEmployeeDrpHistory?ContributorId=${_select1.getSelected()!.getValue()}&ProjectId=${_select2.getSelected()!.getValue()}&Id=0":
    url = "http://m.demo.larchvms.com/Home/FetchEmployeeDrpHistory?ContributorId=${_select1.getSelected()!.getValue()}&ProjectId=${_select2.getSelected()!.getValue()}&Id=$userid";
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    _select5.setOptions([
      for(int i=0;i<json.length;i++)
        BsSelectBoxOption(value: json[i]['Id'], text: Text('${json[i]['Name']}'))
    ]);
  }

  selectHrs() async {
    var url = "http://m.demo.larchvms.com/Home/FetchHoursDrp";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    _select3.setOptions([
      for(int i=0;i<data.length;i++)
        BsSelectBoxOption(value: data[i]['Id'], text: Text('${data[i]['Id']}'))
    ]);
  }

  selectMins() async {
    var url = "http://m.demo.larchvms.com/Home/FetchMinutesDrp";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    _select4.setOptions([
      for(int i=0;i<data.length;i++)
        BsSelectBoxOption(value: data[i]['Id'], text: Text('${data[i]['Id']}'))
    ]);
  }

  editTU() async {
    var url = "http://m.demo.larchvms.com/Home/FetchProjectHistoryById?TransId=$taskupeditid";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    for(int i=0;i<data.length;i++){
      setState(() {
        _select1.setSelected(BsSelectBoxOption(value: data[i]['ClintId'], text: Text('${data[i]['ClintName']}')));
        _select2.setSelected(BsSelectBoxOption(value: data[i]['ProjectId'], text: Text('${data[i]['Project']}')));
        _select5.setSelected(BsSelectBoxOption(value: data[i]['EmployeeId'], text: Text('${data[i]['EmployeeName']}')));
        String whrs = data[i]['WorkHrs'];
        final whrsplit = whrs.split(".");
        _select3.setSelected(BsSelectBoxOption(value: whrsplit[0], text: Text(whrsplit[0])));
        _select4.setSelected(BsSelectBoxOption(value: whrsplit[1], text: Text(whrsplit[1])));
        datecontroller.text = data[i]['WorkDate'];
        decpcontroller.text = data[i]['Description'];
        _select6.setOptions([
            BsSelectBoxOption(value: data[i]['Status'], text: Text('${data[i]['Status']}'))
        ]);
        _select6.setSelected(BsSelectBoxOption(value: data[i]['Status'], text: Text('${data[i]['Status']}')));
      });
    }
  }

  updatetask() async {
    var url = "http://m.demo.larchvms.com/Home/UpdateTask?Id=$taskupeditid&ClientId=${_select1.getSelected()!.getValue()}&ProjectId=${_select2.getSelected()!.getValue()}&EmpId=${_select5.getSelected()!.getValue()}&WorkDate=${datecontroller.text}&WorkHrs=${_select3.getSelected()!.getValue()}" + "." + "${_select4.getSelected()!.getValue()}&Description=${decpcontroller.text}&Status=${_select6.getSelected()!.getValue()}&CreatedBy=$userid";
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
    selectContributor();
    selectproject();
    selectEmployee();
    selectHrs();
    selectMins();
    editTU();
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskUpdate()));
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
              child: FloatingActionButton(heroTag: "btn4",onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreeen()));
              },child:
              Icon(Icons.logout,size: 20,),backgroundColor: Colors.red,),
            )
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Edit Task Update',
                            style: GoogleFonts.mcLaren(fontSize: 25),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Text('Contributor : ',style: GoogleFonts.mcLaren(textStyle: TextStyle(fontWeight: FontWeight.bold)),),
                SizedBox(height: 5.0,),
                BsSelectBox(
                  disabled: true,
                  hintText: 'Select',
                  controller: _select1,
                  onClose: (){ selectproject(); },
                ),
                SizedBox(height: 5.0,),
                Text('Project : ',style: GoogleFonts.mcLaren(textStyle: TextStyle(fontWeight: FontWeight.bold)),),
                SizedBox(height: 5.0,),
                BsSelectBox(
                  disabled: true,
                  hintText: 'Select',
                  controller: _select2,
                  onClose: (){ selectEmployee(); },
                ),
                SizedBox(height: 5.0,),
                Text(
                  'Employee : ',
                  style: GoogleFonts.mcLaren(textStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 5.0,),
                BsSelectBox(
                  disabled: true,
                  hintText: 'Select',
                  controller: _select5,
                ),
                // Container(
                //     height: 55.0,
                //     padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                //     child: TextFormField(
                //         controller: _Employeename,
                //         decoration: InputDecoration(border: OutlineInputBorder(),
                //         ),
                //         keyboardType: TextInputType.number
                //     )
                // ),
                SizedBox(height: 5.0,),
                Text(
                  'Working Date : ',
                  style: GoogleFonts.mcLaren(textStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 5.0,),
                Container(
                    height: 55.0,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: TextFormField(
                      readOnly: true,
                      controller: datecontroller,
                      decoration: InputDecoration(border: OutlineInputBorder()
                      ),
                    )
                ),
                SizedBox(height: 5.0,),
                Text('Working Hrs : ',style: GoogleFonts.mcLaren(textStyle: TextStyle(fontWeight: FontWeight.bold)),),
                SizedBox(height: 5.0,),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      width: 150.0,
                      child: BsSelectBox(
                        hintText: 'Select',
                        controller: _select3,
                        size: BsSelectBoxSize(maxHeight: 200.0),
                      ),
                    ),
                    Text('Hrs'),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      width: 150.0,
                      child: BsSelectBox(
                        hintText: 'Select',
                        controller: _select4,
                      ),
                    ),
                    Text('Mins'),
                  ],
                ),
                SizedBox(height: 5.0,),
                Text(
                  'Description : ',
                  style: GoogleFonts.mcLaren(textStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 5.0,),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: TextFormField(
                      controller: decpcontroller,
                      minLines: 2,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    )
                ),
                SizedBox(height: 5.0,),
                Text(
                  'Status : ',
                  style: GoogleFonts.mcLaren(textStyle: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(height: 5.0,),
                BsSelectBox(
                  hintText: 'Select',
                  controller: _select6,
                ),
                SizedBox(height: 5.0,),
                // Container(
                //     padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                //     child: Row(
                //       children: [
                //         FlatButton(onPressed: (){ getFiles(); }, child: Text('Upload')),
                //         Flexible(child: Container(height: 30.0,child: TextFormField(readOnly: true,controller: fileupload,decoration: InputDecoration(border: OutlineInputBorder()),),)),
                //       ],
                //     )
                // ),

                Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Row(
                      children: [
                        FlatButton(onPressed: (){ updatetask(); }, child: Text('Update'),color: Colors.green,textColor: Colors.white,),
                      ],
                    )
                ),
              ]
          ),
        )
      ),
    );
  }
}
