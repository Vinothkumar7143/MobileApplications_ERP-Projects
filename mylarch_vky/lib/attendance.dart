import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid_export/export.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart'
    hide Alignment, Column, Row;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:line_icons/line_icon.dart';


import 'admindash.dart';
import 'dashboard.dart';
import 'editattendance.dart';
import 'loginpage.dart';

showSuccessDialog(BuildContext context) {
  AwesomeDialog(
    context: context,
    dialogType: DialogType.SUCCES,
    animType: AnimType.BOTTOMSLIDE,
    title: 'Record Saved Successfully',
    btnOkOnPress: () {},
  )..show();
}

showErrorDialog(BuildContext context , data){
  AwesomeDialog(
    context: context,
    dialogType: DialogType.ERROR,
    animType: AnimType.BOTTOMSLIDE,
    title: '$data',
    btnOkOnPress: () {},
  )..show();
}


String? _dropEmpName;
var _Employeename = TextEditingController();
var datecontroller = TextEditingController();
String? _sel;
bool managementedit = false;
var attendId;


class OutSalesReceivable extends StatefulWidget {
  const OutSalesReceivable();

  @override
  _OutSalesReceivableState createState() => _OutSalesReceivableState();
}

class _OutSalesReceivableState extends State<OutSalesReceivable> {
  List dropitem = [];
  var myFormat = DateFormat('dd/MM/yyyy');
  final GlobalKey<SfDataGridState> _key = GlobalKey<SfDataGridState>();
  late DateTime date = DateTime.now();
  var rowsperpage = 4.0;
  var items;
  String? value;
  List data = [];
  final dataPagerHeight = 60.0;
  List<Employee> employees = <Employee>[];
  late EmployeeDataSource employeeDataSource;
  var tablelength;
  var var_ble;

  late Map<String, double> columnWidths = {
    'Date': double.nan,
    'Empcode': double.nan,
    'EmpName': double.nan,
    'Desig': double.nan,
    'Dept': double.nan,
    'Category': double.nan,
    'Status': double.nan,
  };


  void editAttendance(url) async {
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    for(int i=0;i<data.length;i++){
      datecontroller.text = data[i]['Date'];
      var trimsel = data[i]['Status'].trim();
      _sel = trimsel;
    }
  }

  void exportDataGridToExcel() async {
    final Workbook workbook = _key.currentState!.exportToExcelWorkbook();
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    // final Workbook workbook = Workbook();
    // final List<int> bytes = workbook.saveAsStream();
    // workbook.dispose();

    final String path = (await getApplicationSupportDirectory()).path;
    final String filename = '$path/Output.xlsx';
    final File file = File(filename);
    await file.writeAsBytes(bytes,flush: true);
    OpenFile.open(filename);
  }



  regiterattendance(url) async {
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

  List<GridColumn> getColumn() {
    return <GridColumn>[
      management == true ? GridColumn(
          columnName: 'action',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Action',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))):
      GridColumn(
          columnName: '',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                ' ',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: 100,
          columnName: 'Date',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Date',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'EmpCode',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Code',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['EmpName']!,
          columnName: 'EmpName',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Name',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['Desig']!,
          columnName: 'Desig',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Designation',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['Dept']!,
          columnName: 'Dept',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Department',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['Category']!,
          columnName: 'Category',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Category',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['Status']!,
          columnName: 'Status',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Status',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),

    ];
  }

  Future<EmployeeDataGridSource> getEmployeeidlist() async {
    var idlist = await fetchdata();
    var url;
    return EmployeeDataGridSource(idlist,context);
  }


  Future<List<Employee>> fetchdata() async {
    var url;
    management == true ?
    url = "http://m.demo.larchvms.com/Home/FetchAttendanceDetails?EmpId=0" :
    url = "http://m.demo.larchvms.com/Home/FetchAttendanceDetails?EmpId=$userid";
    var response = await http.get(Uri.parse(url));
    items = json.decode(response.body).cast<Map<String , dynamic>>();
    tablelength = items.length;
    List<Employee> idlist =await items.map<Employee>((json)=>Employee.fromJson(json)).toList();
      return idlist;
  }

  fetchemployeedropdown() async {
    var url = "http://m.demo.larchvms.com/Home/FetchEmployeeDrp?EmpId=$userid";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    for(int i=0;i<data.length;i++){
      setState(() {
        _Employeename.text = data[i]['Name'];
      });
    }
  }

  fetchmanagementdropdown() async {
    var url = "http://m.demo.larchvms.com/Home/FetchEmployeeDrp?EmpId=0";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
      setState(() {
       dropitem = data;
      });
  }

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchemployeedropdown();
    fetchmanagementdropdown();
    datecontroller.text = myFormat.format(date).toString();
    fetchdata();
    employeeDataSource = EmployeeDataSource(employeeData: employees);
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
                  if(management == true){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminDash()));
                  }
                  else {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));
                  }
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
              child: FloatingActionButton(heroTag: "btn2",onPressed: (){
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
              // height: 70,
              // decoration: BoxDecoration(
              //       gradient: LinearGradient(
              //         begin: Alignment.topRight,
              //         end: Alignment.bottomLeft,
              //         colors: [
              //           Colors.blue,
              //           Colors.red,
              //         ],
              //       )
              //   ),
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Row(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Attendance',
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
                  management == true ? managementedit == true ?
                  Container(
                      height: 55.0,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: TextFormField(
                        controller: _Employeename,
                        readOnly: true,
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                      )
                  ):
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButton<String>(
                          value: _dropEmpName,
                          items:  dropitem.map((e) {
                            return DropdownMenuItem<String>(
                              child: Text(
                                  '${e['Name']}'),
                              value: e['Id'],
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _dropEmpName = value;
                            });
                          },
                          isExpanded: true,
                        ),
                      ],
                    ),
                  ):
                  Container(
                    height: 55.0,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: TextFormField(
                        controller: _Employeename,
                        readOnly: true,
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
                      )
                  ),
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
                  management == true ?
                  Container(
                      height: 55.0,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: TextFormField(
                        controller: datecontroller,
                        decoration: InputDecoration(suffixIcon: IconButton(onPressed: () { _selectDate(); },icon: Icon(Icons.calendar_today),),border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                        ),
                      )
                  ):
                  Container(
                      height: 55.0,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: TextFormField(
                        controller: datecontroller,
                        readOnly: true,
                        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                        ),
                      )
                  ),
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
              if(management == true){
                var url = "http://m.demo.larchvms.com/Home/InsertAttendance?EmpId=$_dropEmpName&Date=${datecontroller.text}&Status=$_sel&CreatedBy=$userid";
                regiterattendance(url);
              }
              else{
                var url = "http://m.demo.larchvms.com/Home/InsertAttendance?EmpId=$userid&Date=${datecontroller.text}&Status=$_sel&CreatedBy=$userid";
                regiterattendance(url);
              }
            },
              child: Text('Save'),color: Colors.green,textColor: Colors.white,),
            SizedBox(height: 30.0,),
            // ElevatedButton(
            //     child: Text('Export To Pdf'),
            //     onPressed: () {
            //       PdfDocument document = _key.currentState!.exportToPdfDocument();
            //       final List<int> bytes = document.save();
            //     }),
            //  Row(
            //    mainAxisAlignment: MainAxisAlignment.end,
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //       Container(
            //         color: Colors.white,
            //         child: IconButton(onPressed: (){},icon: LineIcon.excelFile(),),
            //       ),
            //       Container(
            //         color: Colors.white,
            //         child: IconButton(onPressed: (){},icon: LineIcon.pdfFile(),)
            //       ),
            //     ],
            //   ),
            FutureBuilder(future: getEmployeeidlist(),builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
              return snapshot.hasData ?
                  Column(
                    children: [
                      SingleChildScrollView(
                        child: SfDataGridTheme(data: SfDataGridThemeData(headerColor: Color.fromRGBO(0, 0, 0, 0.5)),
                          child: SfDataGrid(onQueryRowHeight: (details) {
                            // Set the row height as 70 to the column header row.
                            return details.rowIndex == 0 ? 50.0 : 60.0;
                          },selectionMode: SelectionMode.single,columnWidthMode: ColumnWidthMode.auto,allowColumnsResizing: true,
                              onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                                setState(() {
                                  columnWidths[details.column.columnName] = details.width;
                                });
                                return true;
                              },
                              allowPullToRefresh: true,
                              key: _key,source: snapshot.data, columns: getColumn()
                          ),
                        ),
                      ),
                      tablelength > 4 ?
                      Container(
                        height: dataPagerHeight,
                        child: SfDataPagerTheme(
                              data: SfDataPagerThemeData(
                              itemColor: Colors.white,
                              selectedItemColor: Colors.green,
                              itemBorderRadius: BorderRadius.circular(5),
                              backgroundColor: Color.fromRGBO(0, 0, 0, 0.5),
                              ),
                              child: SfDataPager(
                                  delegate: snapshot.data,
                                  direction: Axis.horizontal,
                                  pageCount: tablelength/rowsperpage,
                                  ),
                              ),):SizedBox(),
                  ],
                  ): Center(child: CircularProgressIndicator(strokeWidth: 3,),);
            })
          ],
        ),
      ),
    );
  }
}

class EmployeeDataGridSource extends DataGridSource {
  EmployeeDataGridSource(this.idlist,this.context){
    buildDataRows();
  }
  BuildContext context;

  final _OutSalesReceivableState attendance = _OutSalesReceivableState();

  late List<DataGridRow> dataGridrows;
  late List<Employee> idlist;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return management == true ? DataGridRowAdapter(cells: [
      Container(
        child: IconButton(onPressed: (){
          String attId = row.getCells()[1].value.toString();
          print(attId);
          attendId = attId;
          Navigator.push(context, MaterialPageRoute(builder: (context)=> new EditAttendance()));
          },icon: Icon(Icons.edit),),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[2].value.toString(),overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[3].value.toString(),overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[4].value.toString(),overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[5].value.toString(),overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[6].value.toString(),overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[7].value.toString(),overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[8].value.toString(),overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
    ]):
    DataGridRowAdapter(cells: [
      Container(
        child: Text(''),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[2].value.toString(),overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[3].value.toString(),overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[4].value.toString(),overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[5].value.toString(),overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[6].value.toString(),overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[7].value.toString(),overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[8].value.toString(),overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),

    ]);
  }
  @override
  // TODO: implement rows
  List<DataGridRow> get rows => dataGridrows;

  void buildDataRows() {
    dataGridrows = idlist.map<DataGridRow>((dataGridrows){
      return DataGridRow(cells: [
        management == true ? DataGridCell(columnName: 'action' , value: null) :
        DataGridCell(columnName: ' ' , value: null),
        DataGridCell(columnName: 'id', value: dataGridrows.Id),
        DataGridCell(columnName: 'date', value: dataGridrows.date),
        DataGridCell(columnName: 'EmpCode', value: dataGridrows.EmpCode),
        DataGridCell(columnName: 'EmpName', value: dataGridrows.EmpName),
        DataGridCell(columnName: 'Desig', value: dataGridrows.Desig),
        DataGridCell(columnName: 'Dept', value: dataGridrows.Dept),
        DataGridCell(columnName: 'Category', value: dataGridrows.Category),
        DataGridCell(columnName: 'Status', value: dataGridrows.Status),
      ]);
    }).toList(growable: false);
  }
}


class Employee {
  factory Employee.fromJson(Map<String , dynamic> json){
    return Employee(Id: json['Id'],date: json['Date'],EmpCode: json['EmpCode'],EmpName: json['EmpName'],Desig: json['Desig'],Dept: json['Dept'],Category: json['Category'],Status: json['Status']);
  }
  Employee({this.Id , this.date , this.EmpCode , this.EmpName , this.Desig , this.Dept , this.Category , this.Status});
  final String? Id;
  final String? date;
  final String? EmpCode;
  final String? EmpName;
  final String? Desig;
  final String? Dept;
  final String? Category;
  final String? Status;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'date', value: '${e.date}'),
      DataGridCell<String>(columnName: 'EmpCode', value: '${e.EmpCode}'),
      DataGridCell<String>(columnName: 'EmpName', value: '${e.EmpName}'),
      DataGridCell<String>(columnName: 'Desig', value: '${e.Desig}'),
      DataGridCell<String>(columnName: 'Dept', value: '${e.Dept}'),
      DataGridCell<String>(columnName: 'Category', value: '${e.Category}'),
      DataGridCell<String>(columnName: 'Status', value: '${e.Status}'),
    ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }
}
