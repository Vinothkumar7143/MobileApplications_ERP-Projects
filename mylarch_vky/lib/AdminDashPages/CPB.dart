import 'dart:convert';

import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;

import '../admindash.dart';
import '../dashboard.dart';
import '../loginpage.dart';


var empcode;
var empname;
var dept;
var desi;
var branch;
var empid;
var projectidbug;


class CPB extends StatefulWidget {
  const CPB({Key? key}) : super(key: key);

  @override
  _CPBState createState() => _CPBState();
}

class _CPBState extends State<CPB> {
  var items;
  var list;
  var tablelength;
  final dataPagerHeight = 60.0;
  var rowsperpage = 7.0;
  late Map<String, double> columnWidths = {
    'projectcode': double.nan,
    'Contributor': double.nan,
    'Project': double.nan,
    'Pending': double.nan,
  };

  List<GridColumn> getColumn() {
    return <GridColumn>[
      GridColumn(
          width: columnWidths['projectcode']!,
          columnName: 'projectcode',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'projectcode',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['Contributor']!,
          columnName: 'Contributor',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Contributor',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['Project']!,
          columnName: 'Project',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Project',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['Pending']!,
          columnName: 'Pending',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Pending',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
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
    url = "http://m.demo.larchvms.com/Home/FetchBugDetails?EmpId=0";
    var response = await http.get(Uri.parse(url));
    items = json.decode(response.body).cast<Map<String , dynamic>>();
    tablelength = items.length;
    List<Employee> idlist =await items.map<Employee>((json)=>Employee.fromJson(json)).toList();
    return idlist;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchdata();
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
                  if(management == true ){
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
                height: 50,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 0, 10, 50),
                child: Row(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Customer Pending Bug',
                          style: GoogleFonts.mcLaren(fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              FutureBuilder(future: getEmployeeidlist(),builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
                return snapshot.hasData ?
                Column(
                  children: [
                    SingleChildScrollView(
                      child: SfDataGridTheme(data: SfDataGridThemeData(headerColor: Color.fromRGBO(0, 0, 0, 0.5)),
                        child: SfDataGrid(
                          //   onQueryRowHeight: (details) {
                          //   // Set the row height as 70 to the column header row.
                          //   return details.rowIndex == 0 ? 50.0 : 60.0;
                          // },
                            selectionMode: SelectionMode.single,columnWidthMode: ColumnWidthMode.fill,allowColumnsResizing: true,
                            onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                              setState(() {
                                columnWidths[details.column.columnName] = details.width;
                              });
                              return true;
                            },
                            allowPullToRefresh: true,source: snapshot.data, columns: getColumn()
                        ),
                      ),
                    ),
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
                      ),)
                  ],
                ): Center(child: CircularProgressIndicator(strokeWidth: 3,),);
              }),
            ],
          )
      ),
    );
  }

}


class EmployeeDataGridSource extends DataGridSource {
  EmployeeDataGridSource(this.idlist,this.context){
    buildDataRows();
  }
  BuildContext context;
  late List<DataGridRow> dataGridrows;
  late List<Employee> idlist = [];
  var items;
  var tablelength;
  final dataPagerHeight = 40.0;
  var rowsperpage = 1.0;
  var items1;
  var items2;

  late Map<String, double> columnWidths1 = {
    'BugNo': double.nan,
    'BugDt': double.nan,
    'Contributor': double.nan,
    'Project': double.nan,
    'ContactPersonName': double.nan,
    'ContactNo': double.nan,
    'BugDetails': double.nan,
    'HoldReason': double.nan,
    'HoldDt': double.nan,
    'Status': double.nan,
  };


  List<GridColumn> getColumnPU() {
    return <GridColumn>[
      GridColumn(
          columnName: 'BugNo',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'BugNo',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['BugDt']!,
          columnName: 'BugDt',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'BugDt',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['Contributor']!,
          columnName: 'Contributor',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Contributor',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['Project']!,
          columnName: 'Project',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Project',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['ContactPersonName']!,
          columnName: 'ContactPersonName',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'ContactPersonName',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['ContactNo']!,
          columnName: 'ContactNo',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'ContactNo',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['BugDetails']!,
          columnName: 'BugDetails',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'BugDetails',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['HoldReason']!,
          columnName: 'HoldReason',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'HoldReason',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['HoldDt']!,
          columnName: 'HoldDt',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'HoldDt',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['Status']!,
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


  Future<List<Employee1>> fetchdataPU() async {
    List<Employee1> idlist = [];
    var url;
    url = "http://m.demo.larchvms.com/Home/FetchPendingPopUpDetails?ProjectId=$projectidbug";
    var response = await http.get(Uri.parse(url));
    items1 = json.decode(response.body).cast<Map<String , dynamic>>();
    for(int i=0;i<items1.length;i++){
      idlist = await items1.map<Employee1>((json) =>
          Employee1.fromJson(json)).toList();
    }
    return idlist;
  }


  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {

    Future<EmployeeDataGridSource1> getEmployeeidlistPU() async {
      var idlist = await fetchdataPU();
      return EmployeeDataGridSource1(idlist,context);
    }

    return DataGridRowAdapter(cells: [
      Container(
        child: Text(row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[1].value.toString(),
          overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: TextButton(child: Text(row.getCells()[3].value.toString(),overflow: TextOverflow.ellipsis),
          onPressed: (){
          empcode = row.getCells()[4].value.toString();
          empname = row.getCells()[5].value.toString();
          dept = row.getCells()[6].value.toString();
          desi = row.getCells()[7].value.toString();
          branch = row.getCells()[8].value.toString();
          projectidbug = row.getCells()[9].value.toString();
            showDialog(
                context: context,
                builder: (context) => BsModal(
                  context: context,
                  dialog: BsModalDialog(
                    size: BsModalSize.xxl,
                    child: BsModalContent(
                      children: [
                        BsModalContainer(
                            title: Text('Pending Bugs'),
                            closeButton: true),
                        BsModalContainer(
                          child:
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('EmpCode:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$empcode',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                    Text('EmpName:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$empname',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Dept:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$dept',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                    Text('Designation:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$desi',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Branch:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$branch',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 30.0,),
                                FutureBuilder(future: getEmployeeidlistPU(),builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
                                  return snapshot.hasData ?
                                  Column(
                                    children: [
                                      SingleChildScrollView(
                                        child: SfDataGridTheme(data: SfDataGridThemeData(headerColor: Color.fromRGBO(0, 0, 0, 0.5)),
                                          child: SfDataGrid(
                                              onQueryRowHeight: (details) {
                                                // Set the row height as 70 to the column header row.
                                                return details.rowIndex == 0 ? 50.0 : 60.0;
                                              },
                                              selectionMode: SelectionMode.single,columnWidthMode: ColumnWidthMode.auto,allowColumnsResizing: true,
                                              onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                                                columnWidths1[details.column.columnName] = details.width;
                                                return true;
                                              },
                                              allowPullToRefresh: true,source: snapshot.data, columns: getColumnPU(),frozenColumnsCount: 2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ): Center(child: Text('No data to display',style: GoogleFonts.mcLaren(textStyle: TextStyle(fontSize: 15.0)),));
                                }),
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ));
          },),
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
        DataGridCell(columnName: 'projectcode', value: dataGridrows.projectcode),
        DataGridCell(columnName: 'Contributor', value: dataGridrows.Contributor),
        DataGridCell(columnName: 'Project', value: dataGridrows.Project),
        DataGridCell(columnName: 'Pending', value: dataGridrows.Pending),
        DataGridCell(columnName: 'EmpCode', value: dataGridrows.projectcode),
        DataGridCell(columnName: 'EmpName', value: dataGridrows.EmpName),
        DataGridCell(columnName: 'DepName', value: dataGridrows.DepName),
        DataGridCell(columnName: 'Designation', value: dataGridrows.Designation),
        DataGridCell(columnName: 'Branch', value: dataGridrows.Branch),
        DataGridCell(columnName: 'ProjectId', value: dataGridrows.ProjectId),
      ]);
    }).toList(growable: false);
  }
}


class Employee {
  factory Employee.fromJson(Map<String , dynamic> json){
    return Employee(projectcode: json['projectcode'],Contributor: json['Contributor'],Project: json['Project'],Pending: json['Pending'],EmpCode: json['EmpCode'],EmpName: json['EmpName'],DepName: json['DepName'],Designation: json['Designation'],Branch: json['Branch'],ProjectId: json['ProjectId']);
  }
  Employee({this.projectcode , this.Contributor , this.Project , this.Pending,this.EmpCode , this.EmpName , this.DepName , this.Designation,this.Branch , this.ProjectId});
  final String? projectcode;
  final String? Contributor;
  final String? Project;
  final String? Pending;
  final String? EmpCode;
  final String? EmpName;
  final String? DepName;
  final String? Designation;
  final String? Branch;
  final String? ProjectId;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'projectcode', value: '${e.projectcode}'),
      DataGridCell<String>(columnName: 'Contributor', value: '${e.Contributor}'),
      DataGridCell<String>(columnName: 'Project', value: '${e.Project}'),
      DataGridCell<String>(columnName: 'Pending', value: '${e.Pending}'),
      DataGridCell<String>(columnName: 'EmpCode', value: '${e.projectcode}'),
      DataGridCell<String>(columnName: 'EmpName', value: '${e.EmpName}'),
      DataGridCell<String>(columnName: 'DepName', value: '${e.DepName}'),
      DataGridCell<String>(columnName: 'Designation', value: '${e.Designation}'),
      DataGridCell<String>(columnName: 'Branch', value: '${e.Branch}'),
      DataGridCell<String>(columnName: 'ProjectId', value: '${e.ProjectId}'),
    ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Text(summaryValue),
    );
  }

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

// <--------------------------GRID POPUP--------------------------------->


class EmployeeDataGridSource1 extends DataGridSource {
  EmployeeDataGridSource1(this.idlist,this.context){
    buildDataRows();
  }
  BuildContext context;


  late List<DataGridRow> dataGridrows;
  late List<Employee1> idlist;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        child: Text(row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[1].value.toString(),
          overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[2].value.toString(),
          overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[3].value.toString(),
          overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[4].value.toString(),
          overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[5].value.toString(),
          overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[6].value.toString(),
          overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[7].value.toString(),
          overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[8].value.toString(),
          overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[9].value.toString(),
          overflow: TextOverflow.ellipsis,),
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
        DataGridCell(columnName: 'BugNo', value: dataGridrows.BugNo),
        DataGridCell(columnName: 'BugDt', value: dataGridrows.BugDt),
        DataGridCell(columnName: 'Contributor', value: dataGridrows.Contributor),
        DataGridCell(columnName: 'Project', value: dataGridrows.Project),
        DataGridCell(columnName: 'ContactPersonName', value: dataGridrows.ContactPersonName),
        DataGridCell(columnName: 'ContactNo', value: dataGridrows.ContactNo),
        DataGridCell(columnName: 'BugDetails', value: dataGridrows.BugDetails),
        DataGridCell(columnName: 'HoldReason', value: dataGridrows.HoldReason),
        DataGridCell(columnName: 'HoldDt', value: dataGridrows.HoldDt),
        DataGridCell(columnName: 'Status', value: dataGridrows.Status),
      ]);
    }).toList(growable: false);
  }
}


class Employee1 {
  factory Employee1.fromJson(Map<String , dynamic> json){
    return Employee1(BugNo: json['BugNo'],
        BugDt: json['BugDt'],
        Contributor: json['Contributor'],
        Project: json['Project'],
        ContactPersonName: json['ContactPersonName'],
        ContactNo: json['ContactNo'],
        BugDetails: json['BugDetails'],
        HoldReason: json['HoldReason'],
        HoldDt: json['HoldDt'],
        Status: json['Status']);
  }
  Employee1({this.BugNo ,
    this.BugDt ,
    this.Contributor ,
    this.Project ,
    this.ContactPersonName,
    this.ContactNo ,
    this.BugDetails ,
    this.HoldReason ,
    this.HoldDt ,
    this.Status});

  final String? BugNo;
  final String? BugDt;
  final String? Contributor;
  final String? Project;
  final String? ContactPersonName;
  final String? ContactNo;
  final String? BugDetails;
  final String? HoldReason;
  final String? HoldDt;
  final String? Status;
}

class EmployeeDataSource1 extends DataGridSource {
  EmployeeDataSource1({required List employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'BugNo', value: '${e.BugNo}'),
      DataGridCell<String>(columnName: 'BugDt', value: '${e.BugDt}'),
      DataGridCell<String>(columnName: 'Contributor', value: '${e.Contributor}'),
      DataGridCell<String>(columnName: 'Project', value: '${e.Project}'),
      DataGridCell<String>(columnName: 'ContactPersonName', value: '${e.ContactPersonName}'),
      DataGridCell<String>(columnName: 'ContactNo', value: '${e.ContactNo}'),
      DataGridCell<String>(columnName: 'BugDetails', value: '${e.BugDetails}'),
      DataGridCell<String>(columnName: 'HoldReason', value: '${e.HoldReason}'),
      DataGridCell<String>(columnName: 'HoldDt', value: '${e.HoldDt}'),
      DataGridCell<String>(columnName: 'Status', value: '${e.Status}'),
    ]))
        .toList();
  }

  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  Widget? buildTableSummaryCellWidget(
      GridTableSummaryRow summaryRow,
      GridSummaryColumn? summaryColumn,
      RowColumnIndex rowColumnIndex,
      String summaryValue) {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Text(summaryValue),
    );
  }

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
