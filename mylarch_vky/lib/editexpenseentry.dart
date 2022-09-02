import 'dart:convert';

import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import 'attendance.dart';
import 'dashboard.dart';
import 'expenseentry.dart';
import 'loginpage.dart';

class EditExpense extends StatefulWidget {
  const EditExpense({Key? key}) : super(key: key);

  @override
  _EditExpenseState createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  BsSelectBoxController _select4 = BsSelectBoxController();
  BsSelectBoxController _select1 = BsSelectBoxController();
  var datecontroller = TextEditingController();
  var decpcontroller = TextEditingController();
  var expamtcontroller = TextEditingController();
  var _EmployeeName = TextEditingController();
  var myFormat = DateFormat('dd/MM/yyyy');
  String? _dropexpensetype;
  List dropitem1 = [];
  var edituserid;

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2000),
        lastDate: new DateTime.now()
    );
    String _pic = myFormat.format(picked!);
    print(_pic);
    if(_pic != null) setState(() => datecontroller.text = _pic.toString());
  }

  selectApi() async {
    var url = "http://m.demo.larchvms.com/Home/FetchExpenseTypeDrp";
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    // setState(() {
    //   dropitem1 = json;
    // });
    _select4.setOptions([
      for(int i=0;i<json.length;i++)
        BsSelectBoxOption(value: json[i]['Id'], text: Text('${json[i]['Type']}'))
    ]);
  }

  selectEmp() async {
    var url = "http://m.demo.larchvms.com/Home/FetchEmployeeDrp?EmpId=0";
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    _select1.setOptions([
      for(int i=0;i<json.length;i++)
        BsSelectBoxOption(value: json[i]['Id'], text: Text('${json[i]['Name']}'))
    ]);
  }

  editExpenseEntry() async {
    var url = "http://m.demo.larchvms.com/Home/FetchExpenseDetailsById?Id=$expeditid";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    for(int i=0;i<data.length;i++){
      setState(() {
        _EmployeeName.text = data[i]['EmpName'];
        datecontroller.text = data[i]['ExpenseDate'];
        _select4.setSelected(BsSelectBoxOption(value: data[i]['ExpenseId'], text: Text('${data[i]['ExpenseType']}')));
        expamtcontroller.text = data[i]['ExpAmt'];
        decpcontroller.text = data[i]['Description'];
        edituserid = data[i]['EmpId'];
      });
    }
  }


  updateExpenseEntry() async {
    print(expeditid);
    print(edituserid);
    print(datecontroller.text);
    print(_select4.getSelected()!.getValue());
    print(decpcontroller.text);
    print(expamtcontroller.text);
    print(userid);
    var url = "http://m.demo.larchvms.com/Home/UpdateExpense?Id=$expeditid&EmpId=$edituserid&ExpenseDate=${datecontroller.text}&ExpenseTypeId=${_select4.getSelected()!.getValue()}&Description=${decpcontroller.text}&ExpenseAmount=${expamtcontroller.text}&Attachment=''&UpdatedBy=$userid";
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
    selectEmp();
    selectApi();
    editExpenseEntry();
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ExpenseEntry()));
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
        child: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                              'Edit Expense Entry',
                              style: GoogleFonts.mcLaren(fontSize: 25),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Text('Employee : ',style: GoogleFonts.mcLaren(textStyle: TextStyle(fontWeight: FontWeight.bold)),),
                  SizedBox(height: 5.0,),
                  Container(
                      height: 55.0,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: TextFormField(
                        controller: _EmployeeName,
                        readOnly: true,
                        decoration: InputDecoration(border: OutlineInputBorder()
                        ),
                      )
                  ),
                  SizedBox(height: 5.0,),
                  Text(
                    'Date : ',
                    style: GoogleFonts.mcLaren(textStyle: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 5.0,),
                  Container(
                      height: 55.0,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: TextFormField(
                        readOnly: true,
                        controller: datecontroller,
                        decoration: InputDecoration(suffixIcon: IconButton(onPressed: () { _selectDate(); },icon: Icon(Icons.calendar_today),),border: OutlineInputBorder()
                        ),
                      )
                  ),
                  SizedBox(height: 5.0,),
                  Text(
                    'Expense Type : ',
                    style: GoogleFonts.mcLaren(textStyle: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 5.0,),
                  BsSelectBox(
                    hintText: 'Select',
                    controller: _select4,
                  ),
                  // DropdownButton<String>(
                  //   items:  dropitem1.map((e) {
                  //     return DropdownMenuItem<String>(
                  //       child: Text('${e['Type']}'),
                  //       value: e['Id'],
                  //     );
                  //   }).toList(),
                  //   value: _dropexpensetype,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _dropexpensetype = value;
                  //     });
                  //   },
                  //   isExpanded: true,
                  // ),
                  SizedBox(height: 5.0,),
                  Text(
                    'Expense Amount(Rs) : ',
                    style: GoogleFonts.mcLaren(textStyle: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 5.0,),
                  Container(
                      height: 55.0,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: TextFormField(
                          controller: expamtcontroller,
                          decoration: InputDecoration(border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number
                      )
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
                  // SizedBox(height: 5.0,),
                  // Container(
                  //     padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  //     child: Row(
                  //       children: [
                  //         FlatButton(onPressed: (){ getFiles(); }, child: Text('Upload')),
                  //         Flexible(child: Container(height: 30.0,child: TextFormField(readOnly: true,controller: fileupload,decoration: InputDecoration(border: OutlineInputBorder()),),)),
                  //       ],
                  //     )
                  // ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FlatButton(onPressed: () async {
                        updateExpenseEntry();
                      },
                        child: Text('Update'),color: Colors.green,textColor: Colors.white,),
                    ],
                  )
                ]
            ),
          ),
        )
      ),
    );
  }
}
