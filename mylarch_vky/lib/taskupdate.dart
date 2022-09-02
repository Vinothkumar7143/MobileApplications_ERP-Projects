import 'dart:convert';

import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:bs_flutter_selectbox/bs_flutter_selectbox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';

import 'admindash.dart';
import 'attendance.dart';
import 'dashboard.dart';
import 'edittaskupdate.dart';
import 'loginpage.dart';

var taskupeditid;

class TaskUpdate extends StatefulWidget {
  const TaskUpdate({Key? key}) : super(key: key);

  @override
  _TaskUpdateState createState() => _TaskUpdateState();
}

class _TaskUpdateState extends State<TaskUpdate> {
  BsSelectBoxController _select1 = BsSelectBoxController();
  BsSelectBoxController _select2 = BsSelectBoxController();
  BsSelectBoxController _select3 = BsSelectBoxController();
  BsSelectBoxController _select4 = BsSelectBoxController();
  BsSelectBoxController _select5 = BsSelectBoxController();
  var items;
  var datalength;
  var tablelength;
  final dataPagerHeight = 60.0;
  late DateTime date = DateTime.now();
  var rowsperpage = 4.0;
  late Map<String, double> columnWidths = {
    'ClintName': double.nan,
    'Project': double.nan,
    'Description': double.negativeInfinity,
    'WorkHrs': double.nan,
    'CreatedDate': double.nan,
    'CreatedBy': double.nan,
  };

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
    print(_select1.getSelected()!.getValue());
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

  insertTask() async {
    var url = "http://m.demo.larchvms.com/Home/InsertTask?ClientId=${_select1.getSelected()!.getValue()}&ProjectId=${_select2.getSelected()!.getValue()}&EmpId=${_select5.getSelected()!.getValue()}&WorkDate=${datecontroller.text}&WorkHrs=${_select3.getSelected()!.getValue()}" + "." + "${_select4.getSelected()!.getValue()}&Description=${decpcontroller.text}&CreatedBy=$userid";
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


  var decpcontroller = TextEditingController();
  var _Employeename = TextEditingController();
  var datecontroller = TextEditingController();
  var myFormat = DateFormat('dd/MM/yyyy');

  List<GridColumn> getColumn() {
    return <GridColumn>[GridColumn(
          columnName: 'action',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Action',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: 100,
          columnName: 'WorkDate',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'Date',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          columnName: 'EmployeeName',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'EmployeeName',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['ClintName']!,
          columnName: 'ClintName',
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
                'Project Name',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
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
          width: columnWidths['WorkHrs']!,
          columnName: 'WorkHrs',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'WorkHrs',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
              ))),
      GridColumn(
          width: columnWidths['CreatedDate']!,
          columnName: 'CreatedDate',
          autoFitPadding: EdgeInsets.all(10.0),
          label: Container(
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: Text(
                'CreatedDate',style: TextStyle(color: Colors.white),overflow: TextOverflow.ellipsis,
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
    url = "http://m.demo.larchvms.com/Home/FetchProjectHistory?Id=0" :
    url = "http://m.demo.larchvms.com/Home/FetchProjectHistory?Id=$userid";
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
    selectContributor();
    datecontroller.text = myFormat.format(date).toString();
    selectHrs();
    selectMins();
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
              child: FloatingActionButton(heroTag: "TU",onPressed: (){
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
                        'Task Update',
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
                                  title: Text('New Task Update'),
                                  closeButton: true),
                              BsModalContainer(
                                child:
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Contributor : ',style: GoogleFonts.mcLaren(textStyle: TextStyle(fontWeight: FontWeight.bold)),),
                                      SizedBox(height: 5.0,),
                                      BsSelectBox(
                                        hintText: 'Select',
                                        controller: _select1,
                                        onClose: (){ selectproject(); },
                                      ),
                                      SizedBox(height: 5.0,),
                                      Text('Project : ',style: GoogleFonts.mcLaren(textStyle: TextStyle(fontWeight: FontWeight.bold)),),
                                      SizedBox(height: 5.0,),
                                      BsSelectBox(
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
                                            decoration: InputDecoration(suffixIcon: IconButton(onPressed: () { _selectDate(); },icon: Icon(Icons.calendar_today),),border: OutlineInputBorder()
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
                                      insertTask();
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
                        // Set the row height as 70 to the column header row.
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
                  tablelength > 4 ?
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
                        pageCount: tablelength/rowsperpage,
                      ),
                    ),):SizedBox(),
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
        child: IconButton(onPressed: (){
          taskupeditid = row.getCells()[1].value.toString();
          Navigator.push(context, MaterialPageRoute(builder: (context)=>EditTaskUpdate()));
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
      Container(
        child: Text(row.getCells()[9].value.toString(),overflow: TextOverflow.ellipsis,),
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
        DataGridCell(columnName: 'Id', value: dataGridrows.Id),
        DataGridCell(columnName: 'WorkDate', value: dataGridrows.WorkDate),
        DataGridCell(columnName: 'EmployeeName', value: dataGridrows.EmployeeName),
        DataGridCell(columnName: 'ClintName', value: dataGridrows.ClintName),
        DataGridCell(columnName: 'Project', value: dataGridrows.Project),
        DataGridCell(columnName: 'Description', value: dataGridrows.Description),
        DataGridCell(columnName: 'WorkHrs', value: dataGridrows.WorkHrs),
        DataGridCell(columnName: 'CreatedDate', value: dataGridrows.CreatedDate),
        DataGridCell(columnName: 'CreatedBy', value: dataGridrows.CreatedBy),
      ]);
    }).toList(growable: false);
  }
}


class Employee {
  factory Employee.fromJson(Map<String , dynamic> json){
    return Employee(Id: json['Id'],WorkDate: json['WorkDate'],EmployeeName: json['EmployeeName'],ClintName: json['ClintName'],Project: json['Project'],Description: json['Description'],WorkHrs: json['WorkHrs'],CreatedDate: json['CreatedDate'],CreatedBy: json['CreatedBy']);
  }
  Employee({this.Id,this.WorkDate , this.EmployeeName , this.ClintName , this.Project , this.Description , this.WorkHrs , this.CreatedDate , this.CreatedBy});
  final String? Id;
  final String? WorkDate;
  final String? EmployeeName;
  final String? ClintName;
  final String? Project;
  final String? Description;
  final String? WorkHrs;
  final String? CreatedDate;
  final String? CreatedBy;
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource({required List employeeData}) {
    _employeeData = employeeData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'WorkDate', value: '${e.WorkDate}'),
      DataGridCell<String>(columnName: 'EmployeeName', value: '${e.EmployeeName}'),
      DataGridCell<String>(columnName: 'ClintName', value: '${e.ClintName}'),
      DataGridCell<String>(columnName: 'Project', value: '${e.Project}'),
      DataGridCell<String>(columnName: 'Description', value: '${e.Description}'),
      DataGridCell<String>(columnName: 'WorkHrs', value: '${e.WorkHrs}'),
      DataGridCell<String>(columnName: 'CreatedDate', value: '${e.CreatedDate}'),
      DataGridCell<String>(columnName: 'CreatedBy', value: '${e.CreatedBy}'),
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
