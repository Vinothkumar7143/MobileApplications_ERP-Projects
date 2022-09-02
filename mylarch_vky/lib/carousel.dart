
import 'package:bs_flutter_buttons/bs_flutter_buttons.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

bool modalopen = false;

class IFlutterCarouselSlider extends StatefulWidget {
  @override
  _IFlutterCarouselSliderState createState() => _IFlutterCarouselSliderState();
}

class _IFlutterCarouselSliderState extends State<IFlutterCarouselSlider> {
  late List<GDPData> _chartdata;
  late TooltipBehavior _tooltipBehavior;

  final List<Color> colors = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.white,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];
  final List<String> letters = [
    "Outstanding Sales Receivable",
    "Outstanding Purchase Payable",
    "Outstanding Expense Payable",
    "Profit and Loss",
    "OverDue AMC Details",
    "Project Details",
    "Customer Pending Bug",
  ];

  bool _isPlaying = false;

  CarouselSliderController? _sliderController;

  @override
  void initState() {
    super.initState();
    _sliderController = CarouselSliderController();
    _chartdata = getdata();
    _tooltipBehavior = TooltipBehavior(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    var dts = DTS(context: context);
    return Scaffold(
      body: ListView(
        children: <Widget>[
          SizedBox(height: 100.0,),
          Text('Petty Cash Avaliable:',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
          SizedBox(height: 10.0,),
          Container(
            height: 500,
            child: CarouselSlider.builder(
              unlimitedMode: true,
              controller: _sliderController,
              slideBuilder: (index) {
                return Container(
                  alignment: Alignment.center,
                  color: colors[index],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            colors[index] == Colors.yellow || colors[index] == Colors.white ?
                            Text(
                              letters[index],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.black
                              ),
                            ):
                            Text(
                              letters[index],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(height: 10),
                            letters[index] == "Profit and Loss" ?
                            SfCircularChart(
                              legend: Legend(isVisible: true,overflowMode: LegendItemOverflowMode.wrap),
                              tooltipBehavior: _tooltipBehavior,
                              series: <CircularSeries>[
                                PieSeries<GDPData,String>(
                                  dataSource:  _chartdata,
                                  xValueMapper: (GDPData data,_) => data.contries,
                                  yValueMapper: (GDPData data,_) => data.gdp,
                                  dataLabelSettings: DataLabelSettings(isVisible: true,),
                                  enableTooltip: true,
                                )
                              ],):
                            SafeArea(
                              child: SingleChildScrollView(
                                child: PaginatedDataTable(
                                  availableRowsPerPage: [5,10,15],
                                  columns: [
                                    DataColumn(label: Text("col#1")),
                                    DataColumn(label: Text("col#2")),
                                    DataColumn(label: Text("col#3")),
                                    DataColumn(label: Text("col#4")),
                                  ],
                                  source: dts,
                                  rowsPerPage: 5,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              slideTransform: CubeTransform(),
              slideIndicator: CircularSlideIndicator(
                padding: EdgeInsets.only(bottom: 32),
                currentIndicatorColor: Colors.white,
                indicatorBorderColor: Colors.black,
              ),
              itemCount: colors.length,
              initialPage: 0,
              enableAutoSlider: false,
            ),
          ),
        ],
      ),

    );
  }
  List<GDPData> getdata() {
    final List<GDPData> chartdata = [
      GDPData(contries: 'Sales',gdp: 759336),
      GDPData(contries: 'Purchase',gdp: 340840),
      GDPData(contries: 'Expense',gdp: 779700),
    ];
    return chartdata;
  }
}

class Source extends DataTableSource {
  @override
  DataRow? getRow(int index) {
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text("Rowl$index")),
      DataCell(Text("Android Mobile Application")),
      DataCell(Text("Row3$index")),
      DataCell(Text("Android Mobile Application")),
    ]);
  }
  @override
  bool get isRowCountApproximate => true;

  @override
  int get rowCount => 100;

  @override
  int get selectedRowCount => 0;
}


class DTS extends DataTableSource {
  DTS({required this.context});
  var source = Source();
  BuildContext context;
  @override
  DataRow getRow(int index) {
    return DataRow.byIndex(index: index, cells: [
      DataCell(Text("Rowl$index")),
      DataCell(Text("Row2$index")),
      DataCell(Text("Android Mobile Application")),
      DataCell(TextButton(child: Text("Row4$index"),onPressed: (){
        showDialog(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Contributor :',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                Text('MAHESH VAL SD',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                              ],
                            ),
                            SizedBox(height: 5.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Invoice No :',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                Text('L0038/21-22',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                              ],
                            ),
                            SizedBox(height: 5.0,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Invoice Date :',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                                Text('08/12/2021',style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold,color: Colors.green),),
                              ],
                            ),
                            SizedBox(height: 5.0,),
                            SafeArea(
                              child: SingleChildScrollView(
                                child: PaginatedDataTable(
                                  columns: [
                                    DataColumn(label: Text("col#1")),
                                    DataColumn(label: Text("col#2")),
                                    DataColumn(label: Text("col#3")),
                                    DataColumn(label: Text("col#4")),
                                  ],
                                  source: source,
                                  rowsPerPage: 1,
                                ),
                              ),
                            )
                          ]
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },)),
    ]);
  }

  @override
  bool get isRowCountApproximate => true;

  @override
  int get rowCount => 100;

  @override
  int get selectedRowCount => 0;
}

class GDPData {
  GDPData({this.contries,this.gdp});
  final String? contries;
  final int? gdp;
}