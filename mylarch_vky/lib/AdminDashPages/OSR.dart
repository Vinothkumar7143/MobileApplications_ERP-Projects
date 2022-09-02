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


var invoiceno;
var contributor;
var invoicedate;
var balanceamt;
var invoiceamt;
var receiveamt;
var tdsamt;
var subtotal;


class OSR extends StatefulWidget {
  const OSR({Key? key}) : super(key: key);

  @override
  _OSRState createState() => _OSRState();
}

class _OSRState extends State<OSR> {
  var items;

  var tablelength;
  final dataPagerHeight = 60.0;
  var rowsperpage = 7.0;
  late Map<String, double> columnWidths = {
    'Contributor': double.nan,
    'InvoiceNo': double.nan,
    'InvoiceDate': double.nan,
    'BalanceAmt': double.nan,
    'InvoiceAmount': double.nan,
    'ReceivedAmount': double.nan,
    'DueDays': double.nan,
  };

  List<GridColumn> getColumn() {
    return <GridColumn>[
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
          width: columnWidths['InvoiceNo']!,
          columnName: 'InvoiceNo',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'InvoiceNo',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['InvoiceDate']!,
          columnName: 'InvoiceDate',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'InvoiceDate',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['BalanceAmt']!,
          columnName: 'BalanceAmt',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'BalanceAmt',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['InvoiceAmount']!,
          columnName: 'InvoiceAmount',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'InvoiceAmount',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['ReceivedAmount']!,
          columnName: 'ReceivedAmount',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'ReceivedAmount',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['DueDays']!,
          columnName: 'DueDays',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'DueDays',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
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
    url = "http://m.demo.larchvms.com/Home/FetchSalesReceivableDetails";
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
                        'Outstanding Sales Receivable',
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
                          allowPullToRefresh: true,source: snapshot.data, columns: getColumn(),frozenColumnsCount: 2,
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
  late List<Employee> idlist;
  var items;
  var tablelength;
  final dataPagerHeight = 40.0;
  var rowsperpage = 1.0;
  var items1;
  var items2;
  List emptylist = ['No Data to Display'];

  late Map<String, double> columnWidths1 = {
    'RefNo': double.nan,
    'PartName': double.nan,
    'Description': double.nan,
    'sellingPrice': double.nan,
    'Qty': double.nan,
    'UnitPrice': double.nan,
    'SubTotal': double.nan,
  };

  late Map<String, double> columnWidths2 = {
    'Date': double.nan,
    'PaymentType': double.nan,
    'BankName': double.nan,
    'RefNo': double.nan,
    'RefDt': double.nan,
    'ReceivedAmount': double.nan,
  };

  List<GridColumn> getColumnPU() {
    return <GridColumn>[
      GridColumn(
          columnName: 'RefNo',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'RefNo',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['PartName']!,
          columnName: 'PartName',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'PartName',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'Description',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Description',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['sellingPrice']!,
          columnName: 'sellingPrice',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'sellingPrice',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['Qty']!,
          columnName: 'Qty',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Qty',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['UnitPrice']!,
          columnName: 'UnitPrice',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'UnitPrice',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['SubTotal']!,
          columnName: 'SubTotal',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'SubTotal',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
    ];
  }


  Future<List<Employee1>> fetchdataPU() async {
    List<Employee1> idlist = [];
    var url;
    url = "http://m.demo.larchvms.com/Home/FetchInvoiceNoPopUpDetails?InvoiceNo=$invoiceno";
    var response = await http.get(Uri.parse(url));
    items1 = json.decode(response.body).cast<Map<String , dynamic>>();
    for(int i=0;i<items1.length;i++){
      idlist = await items1.map<Employee1>((json) =>
          Employee1.fromJson(json)).toList();
    }
    return idlist;
  }

  List<GridColumn> getColumnRevPU() {
    return <GridColumn>[
      GridColumn(
          width: columnWidths2['Date']!,
          columnName: 'Date',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Date',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths2['PaymentType']!,
          columnName: 'PaymentType',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'PaymentType',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths2['BankName']!,
          columnName: 'BankName',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'BankName',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths2['RefNo']!,
          columnName: 'RefNo',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'RefNo',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths2['RefDt']!,
          columnName: 'RefDt',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'RefDt',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths2['ReceivedAmount']!,
          columnName: 'ReceivedAmount',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'ReceivedAmount',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
    ];
  }

  Future<List<Employee2>> fetchdataRevPU() async {
    List<Employee2> idlist = [];
    var url;
    url = "http://m.demo.larchvms.com/Home/FetchReceivedAmountPopUpDetails?InvoiceNo=$invoiceno";
    var response = await http.get(Uri.parse(url));
    items2 = json.decode(response.body).cast<Map<String , dynamic>>();
    tablelength = items2.length;
    for(int i=0;i<items2.length;i++){
      if(items2[i]['Id'] == ''){
        idlist = await emptylist.map<Employee2>((json) =>
            Employee2.fromJson(json)).toList();
      }
      else{
        idlist =await items2.map<Employee2>((json)=>Employee2.fromJson(json)).toList();
      }
    }
    return idlist;
  }



  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {

    Future<EmployeeDataGridSource1> getEmployeeidlistPU() async {
      var idlist = await fetchdataPU();
      return EmployeeDataGridSource1(idlist,context);
    }

    Future<EmployeeDataGridSource2> getEmployeeidlistRevPU() async {
      var idlist = await fetchdataRevPU();
      return EmployeeDataGridSource2(idlist,context);
    }

    return DataGridRowAdapter(cells: [
      Container(
        child: Text(row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: TextButton(child: Text(row.getCells()[1].value.toString(),overflow: TextOverflow.ellipsis),
          onPressed: (){
          contributor = row.getCells()[0].value.toString();
          invoiceno = row.getCells()[1].value.toString();
          invoicedate = row.getCells()[2].value.toString();
            showDialog(
                context: context,
                builder: (context) => BsModal(
                  context: context,
                  dialog: BsModalDialog(
                    size: BsModalSize.xxl,
                    child: BsModalContent(
                      children: [
                        BsModalContainer(
                            title: Text('Sales Item Details'),
                            closeButton: true),
                        BsModalContainer(
                          child:
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Contributor :  ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$contributor',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Invoice No :  ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$invoiceno',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Invoice Date :  ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$invoicedate',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 30.0,),
                                FutureBuilder(future: getEmployeeidlistPU(),builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
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
                                                columnWidths1[details.column.columnName] = details.width;
                                              return true;
                                            },
                                            allowPullToRefresh: true,source: snapshot.data, columns: getColumnPU(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ): Center(child: CircularProgressIndicator(strokeWidth: 3,),);
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
        child: TextButton(child: Text(row.getCells()[5].value.toString(),overflow: TextOverflow.ellipsis),
          onPressed: (){
            contributor = row.getCells()[0].value.toString();
            invoiceno = row.getCells()[1].value.toString();
            invoicedate = row.getCells()[2].value.toString();
            balanceamt = row.getCells()[3].value.toString();
            invoiceamt = row.getCells()[4].value.toString();
            receiveamt = row.getCells()[5].value.toString();
            tdsamt = row.getCells()[7].value.toString();
            showDialog(
                context: context,
                builder: (context) => BsModal(
                  context: context,
                  dialog: BsModalDialog(
                    size: BsModalSize.xxl,
                    child: BsModalContent(
                      children: [
                        BsModalContainer(
                            title: Text('Pending Details'),
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
                                    Text('Contributor:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$contributor',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                    Text('Invoice No:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$invoiceno',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Invoice Date:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$invoicedate,',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                    Text('Invoice Amt:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$invoiceamt',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Received Amt:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$receiveamt,',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                    Text('TDS Amt :  ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$tdsamt',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Balance Amt:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$balanceamt',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 30.0,),
                                FutureBuilder(future: getEmployeeidlistRevPU(),builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
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
                                                columnWidths1[details.column.columnName] = details.width;
                                                return true;
                                              },
                                              allowPullToRefresh: true,source: snapshot.data, columns: getColumnRevPU()
                                          ),
                                        ),
                                      ),
                                    ],
                                  ): Center(child: CircularProgressIndicator(strokeWidth: 3,),);
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
      Container(
        child: Text(row.getCells()[6].value.toString(),
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
        DataGridCell(columnName: 'Contributor', value: dataGridrows.Contributor),
        DataGridCell(columnName: 'InvoiceNo', value: dataGridrows.InvoiceNo),
        DataGridCell(columnName: 'InvoiceDate', value: dataGridrows.InvoiceDate),
        DataGridCell(columnName: 'BalanceAmt', value: dataGridrows.BalanceAmt),
        DataGridCell(columnName: 'InvoiceAmount', value: dataGridrows.InvoiceAmount),
        DataGridCell(columnName: 'ReceivedAmount', value: dataGridrows.ReceivedAmount),
        DataGridCell(columnName: 'DueDays', value: dataGridrows.DueDays),
        DataGridCell(columnName: 'TDSAmt', value: dataGridrows.TDSAmt),
      ]);
    }).toList(growable: false);
  }
}


class Employee {
  factory Employee.fromJson(Map<String , dynamic> json){
    return Employee(Contributor: json['Contributor'],InvoiceNo: json['InvoiceNo'],InvoiceDate: json['InvoiceDate'],BalanceAmt: json['BalanceAmt'],InvoiceAmount: json['InvoiceAmount'],ReceivedAmount: json['ReceivedAmount'],DueDays: json['DueDays'],TDSAmt: json['TDSAmt']);
  }
  Employee({this.Contributor , this.InvoiceNo , this.InvoiceDate , this.BalanceAmt , this.InvoiceAmount , this.ReceivedAmount , this.DueDays ,this.TDSAmt});
  final String? Contributor;
  final String? InvoiceNo;
  final String? InvoiceDate;
  final String? BalanceAmt;
  final String? InvoiceAmount;
  final String? ReceivedAmount;
  final String? DueDays;
  final String? TDSAmt;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'Contributor', value: '${e.Contributor}'),
      DataGridCell<String>(columnName: 'InvoiceNo', value: '${e.InvoiceNo}'),
      DataGridCell<String>(columnName: 'InvoiceDate', value: '${e.InvoiceDate}'),
      DataGridCell<String>(columnName: 'BalanceAmt', value: '${e.BalanceAmt}'),
      DataGridCell<String>(columnName: 'InvoiceAmount', value: '${e.InvoiceAmount}'),
      DataGridCell<String>(columnName: 'ReceivedAmount', value: '${e.ReceivedAmount}'),
      DataGridCell<String>(columnName: 'DueDays', value: '${e.DueDays}'),
      DataGridCell<String>(columnName: 'TDSAmt', value: '${e.TDSAmt}'),
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
    ]);
  }
  @override
  // TODO: implement rows
  List<DataGridRow> get rows => dataGridrows;

  void buildDataRows() {
    dataGridrows = idlist.map<DataGridRow>((dataGridrows){
      return DataGridRow(cells: [
        DataGridCell(columnName: 'RefNo', value: dataGridrows.RefNo),
        DataGridCell(columnName: 'PartName', value: dataGridrows.PartName),
        DataGridCell(columnName: 'Description', value: dataGridrows.Description),
        DataGridCell(columnName: 'sellingPrice', value: dataGridrows.sellingPrice),
        DataGridCell(columnName: 'Qty', value: dataGridrows.Qty),
        DataGridCell(columnName: 'UnitPrice', value: dataGridrows.UnitPrice),
        DataGridCell(columnName: 'SubTotal', value: dataGridrows.SubTotal),
      ]);
    }).toList(growable: false);
  }
}


class Employee1 {
  factory Employee1.fromJson(Map<String , dynamic> json){
    return Employee1(RefNo: json['RefNo'],PartName: json['PartName'],Description: json['Description'],sellingPrice: json['sellingPrice'],Qty: json['Qty'],UnitPrice: json['UnitPrice'],SubTotal: json['SubTotal']);
  }
  Employee1({this.RefNo , this.PartName , this.Description , this.sellingPrice , this.Qty , this.UnitPrice , this.SubTotal});
  final String? RefNo;
  final String? PartName;
  final String? Description;
  final String? sellingPrice;
  final String? Qty;
  final String? UnitPrice;
  final String? SubTotal;
}

class EmployeeDataSource1 extends DataGridSource {
  EmployeeDataSource1({required List employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'RefNo', value: '${e.RefNo}'),
      DataGridCell<String>(columnName: 'PartName', value: '${e.PartName}'),
      DataGridCell<String>(columnName: 'Description', value: '${e.Description}'),
      DataGridCell<String>(columnName: 'sellingPrice', value: '${e.sellingPrice}'),
      DataGridCell<String>(columnName: 'Description', value: '${e.Description}'),
      DataGridCell<String>(columnName: 'UnitPrice', value: '${e.UnitPrice}'),
      DataGridCell<String>(columnName: 'SubTotal', value: '${e.SubTotal}'),
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

// <----------------------------GRID REC POPUP--------------------------->


class EmployeeDataGridSource2 extends DataGridSource {
  EmployeeDataGridSource2(this.idlist,this.context){
    buildDataRows();
  }
  BuildContext context;


  late List<DataGridRow> dataGridrows;
  late List<Employee2> idlist;
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
    ]);
  }
  @override
  // TODO: implement rows
  List<DataGridRow> get rows => dataGridrows;

  void buildDataRows() {
    dataGridrows = idlist.map<DataGridRow>((dataGridrows){
      return DataGridRow(cells: [
        DataGridCell(columnName: 'Date', value: dataGridrows.Date),
        DataGridCell(columnName: 'PaymentType', value: dataGridrows.PaymentType),
        DataGridCell(columnName: 'BankName', value: dataGridrows.BankName),
        DataGridCell(columnName: 'RefNo', value: dataGridrows.RefNo),
        DataGridCell(columnName: 'RefDt', value: dataGridrows.RefDt),
        DataGridCell(columnName: 'ReceivedAmount', value: dataGridrows.ReceivedAmount),
      ]);
    }).toList(growable: false);
  }
}


class Employee2 {
  factory Employee2.fromJson(Map<String , dynamic> json){
    return Employee2(Date: json['Date'],PaymentType: json['PaymentType'],BankName: json['BankName'],RefNo: json['RefNo'],RefDt: json['RefDt'],ReceivedAmount: json['ReceivedAmount']);
  }
  Employee2({this.Date , this.PaymentType , this.BankName , this.RefNo , this.RefDt , this.ReceivedAmount});
  final String? Date;
  final String? PaymentType;
  final String? BankName;
  final String? RefNo;
  final String? RefDt;
  final String? ReceivedAmount;
}

class EmployeeDataSource2 extends DataGridSource {
  EmployeeDataSource2({required List employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'Date', value: '${e.Date}'),
      DataGridCell<String>(columnName: 'PaymentType', value: '${e.PaymentType}'),
      DataGridCell<String>(columnName: 'BankName', value: '${e.BankName}'),
      DataGridCell<String>(columnName: 'RefNo', value: '${e.RefNo}'),
      DataGridCell<String>(columnName: 'RefDt', value: '${e.RefDt}'),
      DataGridCell<String>(columnName: 'ReceivedAmount', value: '${e.ReceivedAmount}'),
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