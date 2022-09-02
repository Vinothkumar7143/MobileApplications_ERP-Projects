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


class OEP extends StatefulWidget {
  const OEP({Key? key}) : super(key: key);

  @override
  _OEPState createState() => _OEPState();
}

class _OEPState extends State<OEP> {
  var items;
  var list;
  var tablelength;
  final dataPagerHeight = 60.0;
  var rowsperpage = 7.0;
  late Map<String, double> columnWidths = {
    'EmpCode': double.nan,
    'EmpName': double.nan,
    'ExpAmt': double.nan,
  };

  List<GridColumn> getColumn() {
    return <GridColumn>[
      GridColumn(
          width: columnWidths['EmpCode']!,
          columnName: 'EmpCode',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'EmpCode',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['EmpName']!,
          columnName: 'EmpName',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'EmpName',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['ExpAmt']!,
          columnName: 'ExpAmt',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'ExpAmt',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
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
    url = "http://m.demo.larchvms.com/Home/FetchDashExpenseDetails";
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
                          'Outstanding Expense Payable',
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
    'ExpenseDate': double.nan,
    'ExpenseType': double.nan,
    'Description': double.nan,
    'ExpAmt': double.nan,
    'DueDate': double.nan,
  };


  List<GridColumn> getColumnPU() {
    return <GridColumn>[
      GridColumn(
          columnName: 'ExpenseDate',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'ExpenseDate',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['ExpenseType']!,
          columnName: 'ExpenseType',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'ExpenseType',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['Description']!,
          columnName: 'Description',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Description',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['ExpAmt']!,
          columnName: 'ExpAmt',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'ExpAmt',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['DueDate']!,
          columnName: 'DueDate',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'DueDate',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
    ];
  }


  Future<List<Employee1>> fetchdataPU() async {
    List<Employee1> idlist = [];
    var url;
    url = "http://m.demo.larchvms.com/Home/FetchExpenseAmountPopUpDetails?EmpId=$empid";
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
        child: TextButton(child: Text(row.getCells()[2].value.toString(),overflow: TextOverflow.ellipsis),
          onPressed: (){
          empcode = row.getCells()[0].value.toString();
          empname = row.getCells()[1].value.toString();
          dept = row.getCells()[3].value.toString();
          desi = row.getCells()[4].value.toString();
          branch = row.getCells()[5].value.toString();
          empid = row.getCells()[6].value.toString();
            showDialog(
                context: context,
                builder: (context) => BsModal(
                  context: context,
                  dialog: BsModalDialog(
                    size: BsModalSize.xxl,
                    child: BsModalContent(
                      children: [
                        BsModalContainer(
                            title: Text('Expense Employee Details'),
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
                                              allowPullToRefresh: true,source: snapshot.data, columns: getColumnPU()
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
        DataGridCell(columnName: 'EmpCode', value: dataGridrows.EmpCode),
        DataGridCell(columnName: 'EmpName', value: dataGridrows.EmpName),
        DataGridCell(columnName: 'ExpAmt', value: dataGridrows.ExpAmt),
        DataGridCell(columnName: 'DepName', value: dataGridrows.DepName),
        DataGridCell(columnName: 'Designation', value: dataGridrows.Designation),
        DataGridCell(columnName: 'Branch', value: dataGridrows.Branch),
        DataGridCell(columnName: 'EmpId', value: dataGridrows.EmpId),
      ]);
    }).toList(growable: false);
  }
}


class Employee {
  factory Employee.fromJson(Map<String , dynamic> json){
    return Employee(EmpCode: json['EmpCode'],EmpName: json['EmpName'],ExpAmt: json['ExpAmt'],DepName: json['DepName'],Designation: json['Designation'],Branch: json['Branch'],EmpId: json['EmpId']);
  }
  Employee({this.EmpCode , this.EmpName , this.ExpAmt , this.DepName , this.Designation , this.Branch , this.EmpId});
  final String? EmpCode;
  final String? EmpName;
  final String? ExpAmt;
  final String? DepName;
  final String? Designation;
  final String? Branch;
  final String? EmpId;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'EmpCode', value: '${e.EmpCode}'),
      DataGridCell<String>(columnName: 'EmpName', value: '${e.EmpName}'),
      DataGridCell<String>(columnName: 'ExpAmt', value: '${e.ExpAmt}'),
      DataGridCell<String>(columnName: 'DepName', value: '${e.DepName}'),
      DataGridCell<String>(columnName: 'Designation', value: '${e.Designation}'),
      DataGridCell<String>(columnName: 'Branch', value: '${e.Branch}'),
      DataGridCell<String>(columnName: 'EmpId', value: '${e.EmpId}'),
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
    ]);
  }
  @override
  // TODO: implement rows
  List<DataGridRow> get rows => dataGridrows;

  void buildDataRows() {
    dataGridrows = idlist.map<DataGridRow>((dataGridrows){
      return DataGridRow(cells: [
        DataGridCell(columnName: 'ExpenseDate', value: dataGridrows.ExpenseDate),
        DataGridCell(columnName: 'ExpenseType', value: dataGridrows.ExpenseType),
        DataGridCell(columnName: 'Description', value: dataGridrows.Description),
        DataGridCell(columnName: 'ExpAmt', value: dataGridrows.ExpAmt),
        DataGridCell(columnName: 'DueDate', value: dataGridrows.DueDate),
      ]);
    }).toList(growable: false);
  }
}


class Employee1 {
  factory Employee1.fromJson(Map<String , dynamic> json){
    return Employee1(ExpenseDate: json['ExpenseDate'],ExpenseType: json['ExpenseType'],Description: json['Description'],ExpAmt: json['ExpAmt'],DueDate: json['DueDate']);
  }
  Employee1({this.ExpenseDate , this.ExpenseType , this.Description , this.ExpAmt , this.DueDate});
  final String? ExpenseDate;
  final String? ExpenseType;
  final String? Description;
  final String? ExpAmt;
  final String? DueDate;
}

class EmployeeDataSource1 extends DataGridSource {
  EmployeeDataSource1({required List employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'ExpenseDate', value: '${e.ExpenseDate}'),
      DataGridCell<String>(columnName: 'ExpenseType', value: '${e.ExpenseType}'),
      DataGridCell<String>(columnName: 'Description', value: '${e.Description}'),
      DataGridCell<String>(columnName: 'ExpAmt', value: '${e.ExpAmt}'),
      DataGridCell<String>(columnName: 'DueDate', value: '${e.DueDate}'),
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
