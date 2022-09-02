import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icon.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;

import 'admindash.dart';
import 'attendance.dart';
import 'dashboard.dart';
import 'editexpenseentry.dart';
import 'loginpage.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';

var expeditid;



class ExpenseEntry extends StatefulWidget {
  const ExpenseEntry({Key? key}) : super(key: key);

  @override
  _ExpenseEntryState createState() => _ExpenseEntryState();
}

class _ExpenseEntryState extends State<ExpenseEntry> {
  BsSelectBoxController _select4 = BsSelectBoxController();
  BsSelectBoxController _select1 = BsSelectBoxController();
  var datecontroller = TextEditingController();
  var decpcontroller = TextEditingController();
  var expamtcontroller = TextEditingController();
  var datalength;
  late DateTime date = DateTime.now();
  var fileupload = TextEditingController();
  var myFormat = DateFormat('dd/MM/yyyy');
  var items;
  final dataPagerHeight = 60.0;
  var rowsperpage = 4.0;
  List emptylist = ['No Data to Display'];
  late Map<String, double> columnWidths = {
    'TransId': double.nan,
    'EmpName': double.nan,
    'ExpenseDate': double.nan,
    'ExpenseType': double.nan,
    'Description': double.nan,
    'ExpAmt': double.nan,
    'DueDate': double.nan,
    'CreatedBy': double.nan,
    'CreatedDt': double.nan,
  };

  var files;
  var _EmployeeName = TextEditingController();

  fetchemployeedropdown() async {
    var url = "http://m.demo.larchvms.com/Home/FetchEmployeeDrp?EmpId=$userid";
    var response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    for(int i=0;i<data.length;i++){
      setState(() {
        _EmployeeName.text = data[i]['Name'];
      });
    }
  }

  TogetLength() async {
    var url;
    management == true ?
    url = "http://m.demo.larchvms.com/Home/FetchExpenseDetails?EmpId=0" :
    url = "http://m.demo.larchvms.com/Home/FetchExpenseDetails?EmpId=$userid";
    var response = await http.get(Uri.parse(url));
    items = json.decode(response.body);
    setState(() {
      datalength = items.length;
    });
  }

  InsertExpense() async {
    var url;
    management == true ?
    url = "http://m.demo.larchvms.com/Home/InsertExpense?EmpId=${_select1.getSelected()!.getValue()}&ExpenseDate=${datecontroller.text}&ExpenseTypeId=${_select4.getSelected()!.getValue()}&Description=${decpcontroller.text}&ExpenseAmount=${expamtcontroller.text}&Attachment=''&CreatedBy=$userid":
    url = "http://m.demo.larchvms.com/Home/InsertExpense?EmpId=$userid&ExpenseDate=${datecontroller.text}&ExpenseTypeId=${_select4.getSelected()!.getValue()}&Description=${decpcontroller.text}&ExpenseAmount=${expamtcontroller.text}&Attachment=''&CreatedBy=$userid";
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

  selectEmp() async {
    var url = "http://m.demo.larchvms.com/Home/FetchEmployeeDrp?EmpId=0";
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    _select1.setOptions([
      for(int i=0;i<json.length;i++)
        BsSelectBoxOption(value: json[i]['Id'], text: Text('${json[i]['Name']}'))
    ]);
  }


  void getFiles() async {
    PlatformFile? file;
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
       file = result.files.first;
    }
    setState(() {
      fileupload.text = file!.name;
    });
  }

   selectApi() async {
    var url = "http://m.demo.larchvms.com/Home/FetchExpenseTypeDrp";
    var response = await http.get(Uri.parse(url));
    var json = jsonDecode(response.body);
    _select4.setOptions([
      for(int i=0;i<json.length;i++)
        BsSelectBoxOption(value: json[i]['Id'], text: Text('${json[i]['Type']}'))
    ]);
  }

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


  List<GridColumn> getColumn() {
    return <GridColumn>[
      GridColumn(
          columnName: 'action',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Action',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['TransId']!,
          columnName: 'TransId',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Expense No',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'EmpName',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'EmpName',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['ExpenseDate']!,
          columnName: 'ExpenseDate',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'ExpenseDate',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['ExpenseType']!,
          columnName: 'ExpenseType',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'ExpenseType',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
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
          width: columnWidths['ExpAmt']!,
          columnName: 'ExpAmt',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'ExpAmt',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['DueDate']!,
          columnName: 'DueDate',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'DueDate',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['CreatedBy']!,
          columnName: 'CreatedBy',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'CreatedBy',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['CreatedDt']!,
          columnName: 'CreatedDt',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'CreatedDt',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),

    ];
  }

  Future<EmployeeDataGridSource> getEmployeeidlist() async {
    var idlist = await fetchdata();
    var url;
    return EmployeeDataGridSource(idlist,context);
  }

  Future<List<Employee>> fetchdata() async {
    List<Employee> idlist = [];
    var url;
    management == true ?
    url = "http://m.demo.larchvms.com/Home/FetchExpenseDetails?EmpId=0" :
    url = "http://m.demo.larchvms.com/Home/FetchExpenseDetails?EmpId=$userid";
    var response = await http.get(Uri.parse(url));
    items = json.decode(response.body).cast<Map<String , dynamic>>();
    for(int i=0;i<items.length;i++){
      if(items[i]['TransId'] == ''){
        idlist = await emptylist.map<Employee>((json) =>
            Employee.fromJson(json)).toList();
      }
      else{
        idlist = await items.map<Employee>((json) =>
            Employee.fromJson(json)).toList();
      }
    }
    return idlist;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    TogetLength();
    datecontroller.text = myFormat.format(date).toString();
    selectApi();
    fetchemployeedropdown();
    selectEmp();
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
                        'Expense Entry',
                        style: GoogleFonts.mcLaren(fontSize: 25),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                BsButton(
                  style: BsButtonStyle.light,
                  margin: EdgeInsets.only(right: 5.0, bottom: 10.0),
                  label: Icon(Icons.add),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => BsModal(
                        context: context,
                        dialog: BsModalDialog(
                          size: BsModalSize.xxl,
                          child: BsModalContent(
                            children: [
                              BsModalContainer(
                                  title: Text('Expense Entry Page'),
                                  closeButton: true),
                              BsModalContainer(
                                child:
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Text('Employee : ',style: GoogleFonts.mcLaren(textStyle: TextStyle(fontWeight: FontWeight.bold)),),
                                  SizedBox(height: 5.0,),
                                    management == true ?
                                    BsSelectBox(
                                      hintText: 'Select',
                                      controller: _select1,
                                    ):
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
                                ]
                                ),
                              ),
                              BsModalContainer(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                actions: [
                                  BsButton(
                                    style: BsButtonStyle.success,
                                    label: Text('Save'),
                                    prefixIcon: Icons.save,
                                    onPressed: () {
                                      InsertExpense();
                                    },
                                  ),
                                  SizedBox(width: 2.0,),
                                  BsButton(
                                    style: BsButtonStyle.danger,
                                    label: Text('Close'),
                                    prefixIcon: Icons.close,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      )),
                ),
              ],
            ),
            FutureBuilder(future: getEmployeeidlist(),builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
              // print(snapshot.hasData);
              return snapshot.hasData ?
              Column(
                children: [
                  SingleChildScrollView(
                    child: SfDataGridTheme(data: SfDataGridThemeData(headerColor: Color.fromRGBO(0, 0, 0, 0.5)),
                      child: SfDataGrid(onQueryRowHeight: (details) {
                        return details.rowIndex == 0 ? 50.0 : 60.0;
                      },selectionMode: SelectionMode.single,columnWidthMode: ColumnWidthMode.auto,allowColumnsResizing: true,
                          onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                            setState(() {
                              columnWidths[details.column.columnName] = details.width;
                            });
                            return true;
                          },
                          allowPullToRefresh: true,source: snapshot.data,
                        columns: getColumn(),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
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
                        pageCount: datalength/rowsperpage,
                      ),
                    ),)
                ],
              ): Center(child: Text('No data to display',style: GoogleFonts.mcLaren(textStyle: TextStyle(fontSize: 15.0)),));
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


  late List<DataGridRow> dataGridrows;
  late List<Employee> idlist;
  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
      return DataGridRowAdapter(cells: [
        Container(
          child: IconButton(onPressed: () {
            expeditid = row.getCells()[1].value.toString();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditExpense()));
          }, icon: Icon(Icons.edit),),
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
        DataGridCell(columnName: 'action' , value: null),
        DataGridCell(columnName: 'TransId', value: dataGridrows.TransId),
        DataGridCell(columnName: 'EmpName', value: dataGridrows.EmpName),
        DataGridCell(columnName: 'ExpenseDate', value: dataGridrows.ExpenseDate),
        DataGridCell(columnName: 'ExpenseType', value: dataGridrows.ExpenseType),
        DataGridCell(columnName: 'Description', value: dataGridrows.Description),
        DataGridCell(columnName: 'ExpAmt', value: dataGridrows.ExpAmt),
        DataGridCell(columnName: 'DueDate', value: dataGridrows.DueDate),
        DataGridCell(columnName: 'CreatedBy', value: dataGridrows.CreatedBy),
        DataGridCell(columnName: 'CreatedDt', value: dataGridrows.CreatedDt),
      ]);
    }).toList(growable: false);
  }
}


class Employee {
  factory Employee.fromJson(Map<String , dynamic> json){
    return Employee(TransId: json['TransId'],EmpName: json['EmpName'],ExpenseDate: json['ExpenseDate'],ExpenseType: json['ExpenseType'],Description: json['Description'],ExpAmt: json['ExpAmt'],DueDate: json['DueDate'],CreatedBy: json['CreatedBy'],CreatedDt: json['CreatedDt']);
  }
  Employee({this.TransId , this.EmpName , this.ExpenseDate , this.ExpenseType , this.Description , this.ExpAmt , this.DueDate , this.CreatedBy , this.CreatedDt});
  final String? TransId;
  final String? EmpName;
  final String? ExpenseDate;
  final String? ExpenseType;
  final String? Description;
  final String? ExpAmt;
  final String? DueDate;
  final String? CreatedBy;
  final String? CreatedDt;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'TransId', value: '${e.TransId}'),
      DataGridCell<String>(columnName: 'EmpName', value: '${e.EmpName}'),
      DataGridCell<String>(columnName: 'ExpenseDate', value: '${e.ExpenseDate}'),
      DataGridCell<String>(columnName: 'ExpenseType', value: '${e.ExpenseType}'),
      DataGridCell<String>(columnName: 'Description', value: '${e.Description}'),
      DataGridCell<String>(columnName: 'ExpAmt', value: '${e.ExpAmt}'),
      DataGridCell<String>(columnName: 'DueDate', value: '${e.DueDate}'),
      DataGridCell<String>(columnName: 'CreatedBy', value: '${e.CreatedBy}'),
      DataGridCell<String>(columnName: 'CreatedDt', value: '${e.CreatedDt}'),
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

