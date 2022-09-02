import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/services.dart' show rootBundle;


var PNO;
var cat;
var INo;



class Excel_Export extends StatefulWidget {
  const Excel_Export({Key? key}) : super(key: key);

  @override
  State<Excel_Export> createState() => _Excel_ExportState();
}

class _Excel_ExportState extends State<Excel_Export> {

  var items;
  var tablelength;
  final dataPagerHeight = 60.0;
  var rowsperpage = 15.0;
  GlobalKey<SfDataGridState> key = GlobalKey<SfDataGridState>();


  Future<StockDataGridSource> getStockDataSource() async {
    var StockList = await generateStockList();
    return StockDataGridSource(StockList);
  }

  List<GridColumn> getColumn() {
    return <GridColumn>[
      GridColumn(
          columnName: 'PartNo',
          width: 100,
          label: Container(
              padding: EdgeInsets.all(6),
              alignment: Alignment.center,
              child: Text('PartNo',
                  overflow: TextOverflow.clip, softWrap: true)),
          allowSorting: true),
      GridColumn(
          columnName: 'Category',
          width: 120,
          label: Container(
              padding: EdgeInsets.all(7),
              alignment: Alignment.center,
              child: Text('Category',
                  overflow: TextOverflow.clip, softWrap: true)),
          allowSorting: true),
      GridColumn(
          columnName: 'CurrentStock',
          width: 100,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text('CurrentStock',
                  overflow: TextOverflow.clip, softWrap: true)),
          allowSorting: true),
      GridColumn(
          columnName: 'UOM',
          width: 80,
          label: Container(
              padding: EdgeInsets.all(8),
              alignment: Alignment.center,
              child: Text('UOM',
                  overflow: TextOverflow.clip, softWrap: true)),
          allowSorting: true),
    ];
  }


  Future<List<Stock>> generateStockList() async {
    var url;
    url = "https://apiaspl.larch.in/Home/FetchCurrentStock";
    var response = await http.get(Uri.parse(url));
    items = json.decode(response.body).cast<Map<String , dynamic>>();
    tablelength = items.length;
    List<Stock> StockList =await items.map<Stock>((json)=>Stock.fromJson(json)).toList();
    return StockList;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStockDataSource();
    generateStockList();
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: Text('Accurate'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.0,),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey,
                  border: Border.all(width: 5,color: Colors.greenAccent),
                  borderRadius: BorderRadius.circular(2)
              ),
              padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
              child: Row(
                children: [
                  Icon(Icons.keyboard_double_arrow_right),
                  Text(
                    'Current Stock',style: TextStyle(
                    color: Colors.black,fontWeight: FontWeight.bold,fontSize: 15.0,
                  ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0,),
            FutureBuilder(future: getStockDataSource(),builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
              return snapshot.hasData ?
              Column(
                children: [
                  SingleChildScrollView(
                    child: SfDataGridTheme(data: SfDataGridThemeData(headerColor: const Color(0xff009889)),
                      child: SfDataGrid(onQueryRowHeight: (details) {
                        // Set the row height as 70 to the column header row.
                        return details.rowIndex == 0 ? 50.0 : 60.0;
                      },selectionMode: SelectionMode.single,columnWidthMode: ColumnWidthMode.auto,allowColumnsResizing: true,
                        onColumnResizeUpdate: (ColumnResizeUpdateDetails details) {
                          return true;
                        },
                        key: key,
                        allowPullToRefresh: true,source: snapshot.data,
                        columns: getColumn(),
                        gridLinesVisibility: GridLinesVisibility.both,
                        headerGridLinesVisibility: GridLinesVisibility.both,
                        allowSorting: true,
                        sortingGestureType: SortingGestureType.tap,
                      ),
                    ),
                  ),
                  tablelength > 5 ?
                  Container(
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    height: dataPagerHeight,
                    child: SfDataPagerTheme(
                      data: SfDataPagerThemeData(
                        itemColor: Colors.white,
                        selectedItemColor: Colors.green,
                        itemBorderRadius: BorderRadius.circular(5),
                        backgroundColor: Color(0xff009889),
                      ),
                      child: SfDataPager(
                        delegate: snapshot.data,
                        direction: Axis.horizontal,
                        pageCount: tablelength/rowsperpage,
                      ),
                    ),):SizedBox(),
                ],
              ): Center(child: Text('No data to display',style:  TextStyle(fontSize: 15.0),));
            }),
            SizedBox(height: 50.0,),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(backgroundColor: Colors.blueGrey),
                      onPressed: ()  {
                        _createPDF();
                      },
                      child: Text('Export',style: TextStyle(color: Colors.white,fontSize: 15.0),)),
                  ],
              ),
            )
          ],
        ),
      ),

    ), onWillPop: () async => true);
  }
}


class StockDataGridSource extends DataGridSource {
  StockDataGridSource(this.StockList) {
    buildDataGridRow();
  }




  late List<DataGridRow> dataGridRows;
  late List<Stock> StockList;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {


    return DataGridRowAdapter(cells: [
      Container(
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: Text(
          row.getCells()[1].value.toString(),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(8.0),
        child: TextButton(
          child: Text(
            row.getCells()[2].value.toString(),
            overflow: TextOverflow.ellipsis,
          ),
          onPressed: () {
            PNO = row.getCells()[0].value.toString();
            cat = row.getCells()[1].value.toString();
            INo = row.getCells()[4].value.toString();
          },
        ),
      ),
      Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(8.0),
          child: Text(
            row.getCells()[3].value.toString(),
            overflow: TextOverflow.ellipsis,
          ))
    ]);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = StockList.map<DataGridRow>((dataGridRow) {
      // print(dataGridRow);
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'PartNo', value: dataGridRow.PartNo),
        DataGridCell<String>(
            columnName: 'Category', value: dataGridRow.Category),
        DataGridCell<String>(columnName: 'CurrentStock', value: dataGridRow.CurrentStock),
        DataGridCell<String>(
            columnName: 'UOM', value: dataGridRow.UOM),
        DataGridCell<String>(
            columnName: 'Item', value: dataGridRow.Item)
      ]);
    }).toList(growable: false);
  }
}

class Stock {
  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      PartNo: json['PartNo'],
      Category: json['Category'],
      CurrentStock: json['CurrentStock'],
      UOM: json['UOM'],
      Item: json['Item'],
    );
  }
  Stock(
      { required this.PartNo,
        required this.Category,
        required this.CurrentStock,
        required this.UOM,
        required this.Item,
      });
  final String? PartNo;
  final String? Category;
  final String? CurrentStock;
  final String? UOM;
  final String? Item;

}

class StockDataSource extends DataGridSource {
  StockDataSource({required List StockData}) {
    _StockData = StockData
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'PartNo', value: "${e.PartNo}"),
      DataGridCell<String>(columnName: 'Category', value: "${e.Category}"),
      DataGridCell<String>(columnName: 'CurrentStock', value: "${e.CurrentStock}"),
      DataGridCell<String>(columnName: 'UOM', value: "${e.UOM}"),
      DataGridCell<String>(columnName: 'Item', value: "${e.Item}"),
    ]))
        .toList();
  }

  List<DataGridRow> _StockData = [];

  @override
  List<DataGridRow> get rows => _StockData;

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


Future<void> _createPDF() async {
  PdfDocument document = PdfDocument();
  // final page = document.pages.add();
  //
  // page.graphics.drawString('Welcome to PDF Succinctly!',
  //     PdfStandardFont(PdfFontFamily.helvetica, 30));

  // page.graphics.drawImage(
  //     PdfBitmap(await _readImageData('Pdf_Succinctly.jpg')),
  //     Rect.fromLTWH(0, 100, 440, 550));

  PdfGrid grid = PdfGrid();
  grid.style = PdfGridStyle(
      font: PdfStandardFont(PdfFontFamily.timesRoman, 20),
      cellPadding: PdfPaddings(left: 3, right: 2, top: 2, bottom: 2));

  grid.columns.add(count: 4);
  grid.headers.add(1);

  PdfGridRow header = grid.headers[0];
  header.cells[0].value = 'PartNo';
  header.cells[1].value = 'Category';
  header.cells[2].value = 'CurrentStock';
  header.cells[3].value = 'UOM';

  var url_1;
  url_1 = "https://apiaspl.larch.in/Home/FetchCurrentStock";
  var response = await http.get(Uri.parse(url_1));
  var data_2 = jsonDecode(response.body);
  for(int i=0;i<data_2.length;i++)
  {
      PdfGridRow row = grid.rows.add();
      row.cells[0].value = '${data_2[i]['PartNo']}';
      row.cells[1].value = '${data_2[i]['Category']}';
      row.cells[2].value = '${data_2[i]['CurrentStock']}';
      row.cells[3].value = '${data_2[i]['UOM']}';
  }

  grid.draw(
      page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));

  List<int> bytes = document.saveSync();
  document.dispose();

  saveAndLaunchFile(bytes, 'Current Stock.pdf');
}
Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
  final path = (await getApplicationDocumentsDirectory()).path;
  final file = File('$path/$fileName');
  await file.writeAsBytes(bytes, flush: true);
  OpenFile.open('$path/$fileName');
  // String dir = (await getApplicationDocumentsDirectory()).path;
  // return new File('$dir/gamerel_data.json');
}
