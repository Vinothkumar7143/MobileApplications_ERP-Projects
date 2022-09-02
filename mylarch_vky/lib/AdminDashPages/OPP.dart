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
var grnno;
var grndate;
var grnamt;
var paidamt;


class OPP extends StatefulWidget {
  const OPP({Key? key}) : super(key: key);

  @override
  _OPPState createState() => _OPPState();
}

class _OPPState extends State<OPP> {
  var items;
  var list;
  var tablelength;
  final dataPagerHeight = 60.0;
  var rowsperpage = 7.0;
  late Map<String, double> columnWidths = {
    'Contributor': double.nan,
    'SuplInvNo': double.nan,
    'SuplInvDt': double.nan,
    'BalanceAmount': double.nan,
    'GrandTotal': double.nan,
    'PaidAmount': double.nan,
    'Duedays': double.nan,
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
          width: columnWidths['SuplInvNo']!,
          columnName: 'SuplInvNo',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'SuplInvNo',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['SuplInvDt']!,
          columnName: 'SuplInvDt',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'SuplInvDt',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['BalanceAmount']!,
          columnName: 'BalanceAmount',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'BalanceAmount',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['GrandTotal']!,
          columnName: 'GrandTotal',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'GrandTotal',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['PaidAmount']!,
          columnName: 'PaidAmount',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'PaidAmount',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['Duedays']!,
          columnName: 'Duedays',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Duedays',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
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
    url = "http://m.demo.larchvms.com/Home/FetchPurchasePayableDetails";
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
                          'Outstanding Purchase Payable',
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
                              selectionMode: SelectionMode.single,columnWidthMode: ColumnWidthMode.auto,allowColumnsResizing: true,
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

  late Map<String, double> columnWidths1 = {
    'RefNo': double.nan,
    'PartName': double.nan,
    'PurchasePrice': double.nan,
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
    'PaidAmount': double.nan,
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
          width: columnWidths1['PurchasePrice']!,
          columnName: 'PurchasePrice',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'PurchasePrice',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
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
    url = "http://m.demo.larchvms.com/Home/FetchSuplInvoiceNoPopUpDetails?InvoiceNo=$invoiceno";
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
          width: columnWidths2['PaidAmount']!,
          columnName: 'PaidAmount',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'PaidAmount',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
    ];
  }

  Future<List<Employee2>> fetchdataRevPU() async {
    var url;
    List<Employee2> idlist= [];
    List emptylist = ['No data to display'];
    url = "http://m.demo.larchvms.com/Home/FetchPaidAmountPopUpDetails?InvoiceNo=$invoiceno";
    var response = await http.get(Uri.parse(url));
    items2 = json.decode(response.body).cast<Map<String , dynamic>>();
    tablelength = items2.length;
    for(int i=0;i<items2.length;i++){
      if(items2[i]['Id'] == ''){
        idlist = await emptylist.map<Employee2>((json) =>
            Employee2.fromJson(json)).toList();
      }
      else{
        idlist = await items2.map<Employee2>((json)=>Employee2.fromJson(json)).toList();
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
            grnno = row.getCells()[7].value.toString();
            grndate = row.getCells()[8].value.toString();
            grnamt = row.getCells()[4].value.toString();
            showDialog(
                context: context,
                builder: (context) => BsModal(
                  context: context,
                  dialog: BsModalDialog(
                    size: BsModalSize.xxl,
                    child: BsModalContent(
                      children: [
                        BsModalContainer(
                            title: Text('Purchase Item Details'),
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
                                    Text('SupplierInvoiceNo :  ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$invoiceno',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('SupplierInvoiceDate :  ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$invoicedate',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('GRNNo :  ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$grnno',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('GRNDate :  ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$grndate',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('GRNAmt :  ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$grnamt',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
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
            grnno = row.getCells()[7].value.toString();
            grndate = row.getCells()[8].value.toString();
            grnamt = row.getCells()[4].value.toString();
            balanceamt = row.getCells()[4].value.toString();
            paidamt = row.getCells()[5].value.toString();
            showDialog(
                context: context,
                builder: (context) => BsModal(
                  context: context,
                  dialog: BsModalDialog(
                    size: BsModalSize.xxl,
                    child: BsModalContent(
                      children: [
                        BsModalContainer(
                            title: Text('Payment Payable Details'),
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
                                    Text('GRNNo:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$grnno',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('GRNDate:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$grndate',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                    Text('GRNAmt:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$grnamt',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('SuppInvNo:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$invoiceno',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                    Text('SuppInvDate :  ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$invoicedate',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('PaidAmt:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$paidamt',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                    Text('BalanceAmt:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
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
                                              allowPullToRefresh: true,source: snapshot.data, columns: getColumnRevPU()
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
        DataGridCell(columnName: 'SuplInvNo', value: dataGridrows.SuplInvNo),
        DataGridCell(columnName: 'SuplInvDt', value: dataGridrows.SuplInvDt),
        DataGridCell(columnName: 'BalanceAmount', value: dataGridrows.BalanceAmount),
        DataGridCell(columnName: 'GrandTotal', value: dataGridrows.GrandTotal),
        DataGridCell(columnName: 'PaidAmount', value: dataGridrows.PaidAmount),
        DataGridCell(columnName: 'Duedays', value: dataGridrows.Duedays),
        DataGridCell(columnName: 'GRNNO', value: dataGridrows.GRNNO),
        DataGridCell(columnName: 'GRNDt', value: dataGridrows.GRNDt),
      ]);
    }).toList(growable: false);
  }
}


class Employee {
  factory Employee.fromJson(Map<String , dynamic> json){
    return Employee(Contributor: json['Contributor'],SuplInvNo: json['SuplInvNo'],SuplInvDt: json['SuplInvDt'],BalanceAmount: json['BalanceAmount'],GrandTotal: json['GrandTotal'],PaidAmount: json['PaidAmount'],Duedays: json['Duedays'],GRNNO: json['GRNNO'],GRNDt: json['GRNDt']);
  }
  Employee({this.Contributor , this.SuplInvNo , this.SuplInvDt , this.BalanceAmount , this.GrandTotal , this.PaidAmount , this.Duedays , this.GRNNO , this.GRNDt});
  final String? Contributor;
  final String? SuplInvNo;
  final String? SuplInvDt;
  final String? BalanceAmount;
  final String? GrandTotal;
  final String? PaidAmount;
  final String? Duedays;
  final String? GRNNO;
  final String? GRNDt;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'Contributor', value: '${e.Contributor}'),
      DataGridCell<String>(columnName: 'SuplInvNo', value: '${e.SuplInvNo}'),
      DataGridCell<String>(columnName: 'SuplInvDt', value: '${e.SuplInvDt}'),
      DataGridCell<String>(columnName: 'BalanceAmount', value: '${e.BalanceAmount}'),
      DataGridCell<String>(columnName: 'GrandTotal', value: '${e.GrandTotal}'),
      DataGridCell<String>(columnName: 'PaidAmount', value: '${e.PaidAmount}'),
      DataGridCell<String>(columnName: 'Duedays', value: '${e.Duedays}'),
      DataGridCell<String>(columnName: 'GRNNO', value: '${e.GRNNO}'),
      DataGridCell<String>(columnName: 'GRNDt', value: '${e.GRNDt}'),
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
        DataGridCell(columnName: 'PurchasePrice', value: dataGridrows.PurchasePrice),
        DataGridCell(columnName: 'Qty', value: dataGridrows.Qty),
        DataGridCell(columnName: 'UnitPrice', value: dataGridrows.UnitPrice),
        DataGridCell(columnName: 'SubTotal', value: dataGridrows.SubTotal),
      ]);
    }).toList(growable: false);
  }
}


class Employee1 {
  factory Employee1.fromJson(Map<String , dynamic> json){
    return Employee1(RefNo: json['RefNo'],PartName: json['PartName'],PurchasePrice: json['PurchasePrice'],Qty: json['Qty'],UnitPrice: json['UnitPrice'],SubTotal: json['SubTotal']);
  }
  Employee1({this.RefNo , this.PartName , this.PurchasePrice , this.Qty , this.UnitPrice , this.SubTotal});
  final String? RefNo;
  final String? PartName;
  final String? PurchasePrice;
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
      DataGridCell<String>(columnName: 'PurchasePrice', value: '${e.PurchasePrice}'),
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
        DataGridCell(columnName: 'PaidAmount', value: dataGridrows.PaidAmount),
      ]);
    }).toList(growable: false);
  }
}


class Employee2 {
  factory Employee2.fromJson(Map<String , dynamic> json){
    return Employee2(Date: json['Date'],PaymentType: json['PaymentType'],BankName: json['BankName'],RefNo: json['RefNo'],RefDt: json['RefDt'],PaidAmount: json['PaidAmount']);
  }
  Employee2({this.Date , this.PaymentType , this.BankName , this.RefNo , this.RefDt , this.PaidAmount});
  final String? Date;
  final String? PaymentType;
  final String? BankName;
  final String? RefNo;
  final String? RefDt;
  final String? PaidAmount;
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
      DataGridCell<String>(columnName: 'PaidAmount', value: '${e.PaidAmount}'),
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