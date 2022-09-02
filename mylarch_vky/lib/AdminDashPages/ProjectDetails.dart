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

var id;
var projectid;
var procode;
var projname;
var contributor;
var contpers;
var contno;
var sdate;
var edate;
var pono;
var podate;
var localip;
var staticip;
var value;
var totalworkinghrs;



class ProjectDetails extends StatefulWidget {
  const ProjectDetails({Key? key}) : super(key: key);

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  var items;
  var list;
  var tablelength;
  final dataPagerHeight = 60.0;
  var rowsperpage = 7.0;
  late Map<String, double> columnWidths = {
    'Contributor': double.nan,
    'ProjectCode': double.nan,
    'Project': double.nan,
    'WorkHrs': double.nan,
    'StartDt': double.nan,
    'EndDt': double.nan,
    'ProjectAmt': double.nan,
    'Value': double.nan,
    'Profit': double.nan,
    'Status': double.nan,
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
          width: columnWidths['ProjectCode']!,
          columnName: 'ProjectCode',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'ProjectCode',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
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
          width: 100,
          columnName: 'WorkHrs',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'WorkHrs',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['StartDt']!,
          columnName: 'StartDt',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'StartDt',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['EndDt']!,
          columnName: 'EndDt',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'EndDt',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['ProjectAmt']!,
          columnName: 'ProjectAmt',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'ProjectAmt',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['Value']!,
          columnName: 'Value',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Value',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['Profit']!,
          columnName: 'Profit',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Profit',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
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
    url = "http://m.demo.larchvms.com/Home/FetchProjectDetails";
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
        backgroundColor: Colors.white,
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
                          'Project Details',
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
  late List<Employee> idlist = [];
  var items;
  var tablelength;
  final dataPagerHeight = 40.0;
  var rowsperpage = 1.0;
  var items1;
  var items2;

  late Map<String, double> columnWidths1 = {
    'Date': double.nan,
    'EmpName': double.nan,
    'Description': double.nan,
    'Cost': double.nan,
    'WorkHrs': double.nan,
    'Value': double.nan,
  };


  List<GridColumn> getColumnPU() {
    return <GridColumn>[
      GridColumn(
          columnName: 'Date',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Date',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['EmpName']!,
          columnName: 'EmpName',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'EmpName',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
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
          width: columnWidths1['Cost']!,
          columnName: 'Cost',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Per Hour Cost',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['WorkHrs']!,
          columnName: 'WorkHrs',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'WorkHrs',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths1['Value']!,
          columnName: 'Value',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Value',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
    ];
  }


  Future<List<Employee1>> fetchdataPU() async {
    List<Employee1> idlist = [];
    var url;
    url = "http://m.demo.larchvms.com/Home/FetchWorkingHrsPopUpDetails?Id=$id&ProjectId=$projectid";
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

    workingHrs() async {
      var url = "http://m.demo.larchvms.com/Home/FetchTotalHrsDetails?Id=$id&ProjectId=$projectid";
      var response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body);
      for(int i=0;i<data.length;i++){
        totalworkinghrs = data[i]['WorkHrs'];
      }
    }

    return DataGridRowAdapter(cells: [
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
        child: TextButton(child: Text(row.getCells()[15].value.toString(),overflow: TextOverflow.ellipsis),
          onPressed: (){
            id = row.getCells()[0].value.toString();
            projectid = row.getCells()[1].value.toString();
            procode = row.getCells()[3].value.toString();
            projname = row.getCells()[4].value.toString();
            contributor = row.getCells()[2].value.toString();
            contpers = row.getCells()[7].value.toString();
            contno = row.getCells()[8].value.toString();
            sdate = row.getCells()[5].value.toString();
            edate = row.getCells()[6].value.toString();
            pono = row.getCells()[11].value.toString();
            podate = row.getCells()[12].value.toString();
            localip = row.getCells()[9].value.toString();
            staticip = row.getCells()[10].value.toString();
            value = row.getCells()[14].value.toString();
            workingHrs();
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
                                     Text('ProjectCode : ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                     Text('$procode',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                   ],
                                 ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('Project Name : ',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text(''
                                        '$projname',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Contributor:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$contributor',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Contact No:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$contno',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Contact Person:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$contpers',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Start Date:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$sdate',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                    Text('End Date:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$edate',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('PO No:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$pono',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                    Text('PO Date:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                    Text('$podate',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                  ],
                                ),
                                SizedBox(height: 10.0,),
                                SingleChildScrollView(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('Local IP:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                      Text('$localip',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                      Text('Static IP:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                      Text('$staticip',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                      Text('Value:',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                      Text('$value',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                                    ],
                                  ),
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
                                              allowPullToRefresh: true,source: snapshot.data, columns: getColumnPU(),
                                            footerFrozenRowsCount: 1,
                                            footer: Container(
                                              height: 5,
                                                color: Colors.grey[400],
                                                child: Center(
                                                    child: Text(
                                                      'Total Working Hrs : $totalworkinghrs',
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ))),
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
        child: Text(row.getCells()[13].value.toString(),
          overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[14].value.toString(),
          overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      int.parse(row.getCells()[16].value) >= 0 ?
      Container(
        child: Text(row.getCells()[16].value.toString(),
          overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.green),),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ):
      Container(
        child: Text(row.getCells()[16].value.toString(),
          overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.red)),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(row.getCells()[17].value.toString(),
          overflow: TextOverflow.ellipsis,),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      int.parse(row.getCells()[18].value) >= 0 ?
      Container(
        child: Text(row.getCells()[18].value.toString(),
          overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.green)),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ):
      Container(
        child: Text(row.getCells()[18].value.toString(),
          overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.red)),
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
        DataGridCell(columnName: 'Id', value: dataGridrows.Id),
        DataGridCell(columnName: 'ProjectId', value: dataGridrows.ProjectId),
        DataGridCell(columnName: 'Contributor', value: dataGridrows.Contributor),
        DataGridCell(columnName: 'ProjectCode', value: dataGridrows.ProjectCode),
        DataGridCell(columnName: 'Project', value: dataGridrows.Project),
        DataGridCell(columnName: 'StartDt', value: dataGridrows.StartDt),
        DataGridCell(columnName: 'EndDt', value: dataGridrows.EndDt),
        DataGridCell(columnName: 'ContactPerson', value: dataGridrows.ContactPerson),
        DataGridCell(columnName: 'ContactNo', value: dataGridrows.ContactNo),
        DataGridCell(columnName: 'LocalIP', value: dataGridrows.LocalIP),
        DataGridCell(columnName: 'StaticIP', value: dataGridrows.StaticIP),
        DataGridCell(columnName: 'PONo', value: dataGridrows.PONo),
        DataGridCell(columnName: 'PODt', value: dataGridrows.PODt),
        DataGridCell(columnName: 'ProjectAmt', value: dataGridrows.ProjectAmt),
        DataGridCell(columnName: 'Value', value: dataGridrows.Value),
        DataGridCell(columnName: 'WorkHrs', value: dataGridrows.WorkHrs),
        DataGridCell(columnName: 'Profit', value: dataGridrows.Profit),
        DataGridCell(columnName: 'Status', value: dataGridrows.Status),
        DataGridCell(columnName: 'DueDays', value: dataGridrows.DueDays),
      ]);
    }).toList(growable: false);
  }
}


class Employee {
  factory Employee.fromJson(Map<String , dynamic> json){
    return Employee(Id: json['Id'],ProjectId: json['ProjectId'],Contributor: json['Contributor'],ProjectCode: json['ProjectCode'],Project: json['Project'],StartDt: json['StartDt'],EndDt: json['EndDt'],ContactPerson: json['ContactPerson'],ContactNo: json['ContactNo'],LocalIP: json['LocalIP'],StaticIP: json['StaticIP'],PONo: json['PONo'],PODt: json['PODt'],ProjectAmt: json['ProjectAmt'],Value: json['Value'],WorkHrs: json['WorkHrs'],Profit: json['Profit'],Status: json['Status'],DueDays: json['DueDays']);
  }
  Employee({this.Id,this.ProjectId,this.Contributor,this.ProjectCode,this.Project,this.StartDt,this.EndDt,this.ContactPerson,this.ContactNo,this.LocalIP,this.StaticIP,this.PONo,this.PODt,this.ProjectAmt,this.Value,this.WorkHrs,this.Profit,this.Status,this.DueDays});
  final String? Id;
  final String? ProjectId;
  final String? Contributor;
  final String? ProjectCode;
  final String? Project;
  final String? StartDt;
  final String? EndDt;
  final String? ContactPerson;
  final String? ContactNo;
  final String? LocalIP;
  final String? StaticIP;
  final String? PONo;
  final String? PODt;
  final String? ProjectAmt;
  final String? Value;
  final String? WorkHrs;
  final String? Profit;
  final String? Status;
  final String? DueDays;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'Id', value: '${e.Id}'),
      DataGridCell<String>(columnName: 'ProjectId', value: '${e.ProjectId}'),
      DataGridCell<String>(columnName: 'Contributor', value: '${e.Contributor}'),
      DataGridCell<String>(columnName: 'ProjectCode', value: '${e.ProjectCode}'),
      DataGridCell<String>(columnName: 'Project', value: '${e.Project}'),
      DataGridCell<String>(columnName: 'StartDt', value: '${e.StartDt}'),
      DataGridCell<String>(columnName: 'EndDt', value: '${e.EndDt}'),
      DataGridCell<String>(columnName: 'ContactPerson', value: '${e.ContactPerson}'),
      DataGridCell<String>(columnName: 'ContactNo', value: '${e.ContactNo}'),
      DataGridCell<String>(columnName: 'LocalIP', value: '${e.LocalIP}'),
      DataGridCell<String>(columnName: 'StaticIP', value: '${e.StaticIP}'),
      DataGridCell<String>(columnName: 'PONo', value: '${e.PONo}'),
      DataGridCell<String>(columnName: 'PODt', value: '${e.PODt}'),
      DataGridCell<String>(columnName: 'ProjectAmt', value: '${e.ProjectAmt}'),
      DataGridCell<String>(columnName: 'Value', value: '${e.Value}'),
      DataGridCell<String>(columnName: 'WorkHrs', value: '${e.WorkHrs}'),
      DataGridCell<String>(columnName: 'Profit', value: '${e.Profit}'),
      DataGridCell<String>(columnName: 'Status', value: '${e.Status}'),
      DataGridCell<String>(columnName: 'DueDays', value: '${e.DueDays}'),
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
        DataGridCell(columnName: 'Date', value: dataGridrows.Date),
        DataGridCell(columnName: 'EmpName', value: dataGridrows.EmpName),
        DataGridCell(columnName: 'Description', value: dataGridrows.Description),
        DataGridCell(columnName: 'Cost', value: dataGridrows.Cost),
        DataGridCell(columnName: 'WorkHrs', value: dataGridrows.WorkHrs),
        DataGridCell(columnName: 'Value', value: dataGridrows.Value),
      ]);
    }).toList(growable: false);
  }
}


class Employee1 {
  factory Employee1.fromJson(Map<String , dynamic> json){
    return Employee1(Date: json['Date'],EmpName: json['EmpName'],Description: json['Description'],Cost: json['Cost'],WorkHrs: json['WorkHrs'],Value: json['Value']);
  }
  Employee1({this.Date , this.EmpName , this.Description , this.Cost , this.WorkHrs , this.Value});
  final String? Date;
  final String? EmpName;
  final String? Description;
  final String? Cost;
  final String? WorkHrs;
  final String? Value;
}

class EmployeeDataSource1 extends DataGridSource {
  EmployeeDataSource1({required List employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'Date', value: '${e.Date}'),
      DataGridCell<String>(columnName: 'EmpName', value: '${e.EmpName}'),
      DataGridCell<String>(columnName: 'Description', value: '${e.Description}'),
      DataGridCell<String>(columnName: 'ExpAmt', value: '${e.ExpAmt}'),
      DataGridCell<String>(columnName: 'WorkHrs', value: '${e.WorkHrs}'),
      DataGridCell<String>(columnName: 'Value', value: '${e.Value}'),
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
