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


class OAD extends StatefulWidget {
  const OAD({Key? key}) : super(key: key);

  @override
  _OADState createState() => _OADState();
}

class _OADState extends State<OAD> {
  var items;
  var list;
  var tablelength;
  final dataPagerHeight = 60.0;
  var rowsperpage = 7.0;
  late Map<String, double> columnWidths = {
    'ClintName': double.nan,
    'Amount': double.nan,
    'FrmDate': double.nan,
    'ToDate': double.nan,
    'Description': double.nan,
    'OverDueDays': double.nan,
  };

  List<GridColumn> getColumn() {
    return <GridColumn>[
      GridColumn(
          width: columnWidths['ClintName']!,
          columnName: 'ClintName',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'ClintName',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['Amount']!,
          columnName: 'Amount',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Amount',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['FrmDate']!,
          columnName: 'FrmDate',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'FrmDate',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['ToDate']!,
          columnName: 'ToDate',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'ToDate',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['Description']!,
          columnName: 'Description',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Description',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['OverDueDays']!,
          columnName: 'OverDueDays',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'OverDueDays',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
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
    url = "http://m.demo.larchvms.com/Home/FetchAMCDetails";
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
                          'OverDue AMC Details',
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
          overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.red),),
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
        DataGridCell(columnName: 'ClintName', value: dataGridrows.ClintName),
        DataGridCell(columnName: 'Amount', value: dataGridrows.Amount),
        DataGridCell(columnName: 'FrmDate', value: dataGridrows.FrmDate),
        DataGridCell(columnName: 'ToDate', value: dataGridrows.ToDate),
        DataGridCell(columnName: 'Description', value: dataGridrows.Description),
        DataGridCell(columnName: 'OverDueDays', value: dataGridrows.OverDueDays),
      ]);
    }).toList(growable: false);
  }
}


class Employee {
  factory Employee.fromJson(Map<String , dynamic> json){
    return Employee(ClintName: json['ClintName'],Amount: json['Amount'],FrmDate: json['FrmDate'],ToDate: json['ToDate'],Description: json['Description'],OverDueDays: json['OverDueDays']);
  }
  Employee({this.ClintName , this.Amount , this.FrmDate , this.ToDate , this.Description , this.OverDueDays});
  final String? ClintName;
  final String? Amount;
  final String? FrmDate;
  final String? ToDate;
  final String? Description;
  final String? OverDueDays;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'ClintName', value: '${e.ClintName}'),
      DataGridCell<String>(columnName: 'Amount', value: '${e.Amount}'),
      DataGridCell<String>(columnName: 'FrmDate', value: '${e.FrmDate}'),
      DataGridCell<String>(columnName: 'ToDate', value: '${e.ToDate}'),
      DataGridCell<String>(columnName: 'Description', value: '${e.Description}'),
      DataGridCell<String>(columnName: 'OverDueDays', value: '${e.OverDueDays}'),
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
