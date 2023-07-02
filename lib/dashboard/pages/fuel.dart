import 'dart:async';
import'dart:math';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:testcapstone/NetworkHandler.dart';

import '../../Networkchart.dart';
import '../../data/genmodal.dart';
const imgTabbar = "assets/supergraphic.svg";

class FuelLvlPara extends StatefulWidget {
  const FuelLvlPara({super.key});

  @override
  State<FuelLvlPara> createState() => _FuelLvlParaState();
}

class _FuelLvlParaState extends State<FuelLvlPara> {
  Timer? timer;
  bool circular =true;
    List<Welcome> welcome1 = [];
  NetworkHelper _networkHelper = NetworkHelper();
// Redraw the series with updating or creating new points by using this controller.
ChartSeriesController? _chartSeriesController;
late ZoomPanBehavior _zoomPanBehavior;
// Count of type integer which binds as x value for the series
int count = 19;
  //late TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
            _zoomPanBehavior = ZoomPanBehavior(
      // Enables pinch zooming
      enablePinching: true, zoomMode: ZoomMode.x, enablePanning: true,
      enableDoubleTapZooming: true,
      enableSelectionZooming: true,
      enableMouseWheelZooming: true, maximumZoomLevel: 0.3,
    );
    super.initState();
    Timer.periodic(const Duration(seconds: 3),(timer){
      fetchData();
    });
  }
    Future<void> fetchData() async {
 var response = await _networkHelper
        .get("https://realnodedjshv.up.railway.app/data/fuel");
    List<Welcome> tempdata = welcomeFromJson(response.body);
    if (!mounted) return;
    setState(() {
      welcome1 = tempdata;
      circular = false;
    });

  }
  void _updateDataSource(Timer timer) {

   if (welcome1.length == 20) {
     // Removes the last index data of data source.
     welcome1.removeAt(0);
     // Here calling updateDataSource method with addedDataIndexes to add data in last index and removedDataIndexes to remove data from the last.
     _chartSeriesController?.updateDataSource(addedDataIndexes: <int>[welcome1.length - 1],
  removedDataIndexes: <int>[0]);
   }
   count = count + 1;
}

  @override
  Widget build(BuildContext context) {
    timer = Timer.periodic(const Duration(milliseconds: 1000), _updateDataSource);
   // _tooltipBehavior = TooltipBehavior(enable: true);
    // _getChartData();

    // timer = Timer.periodic(const Duration(milliseconds: 5000), (_timer) {
    //   setState(() {
    //     _getChartData();
    //   });
    // });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Fuel Level",
          style: TextStyle(
              fontSize: 18.sp, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10),
            child: SizedBox(
              height: 10.h,
              width: double.infinity,
              child: SvgPicture.asset(
                imgTabbar,
                fit: BoxFit.cover,
              ),
            )),
      ),
      body: Center(
        child: circular?CircularProgressIndicator(): SfCartesianChart(
                // Chart title
                 zoomPanBehavior: _zoomPanBehavior,
                title: ChartTitle(text: 'Fuel Lvl Analysis'),
                // Enable legend
                legend: Legend(
                  isVisible: true,
                  toggleSeriesVisibility: true,
                  // Border color and border width of legend
                ),
                // Enable tooltip
               // tooltipBehavior: _tooltipBehavior,
                series: <LineSeries<Welcome, String>>[
                  LineSeries<Welcome, String>(
                      dataSource: welcome1,
                      xValueMapper: (Welcome WelCome, _) => WelCome.time,
                      yValueMapper: (Welcome WelCome, _) => WelCome.fuel,
                      // Enable data label
                      name: 'FuLvL',
                    enableTooltip: true,
                    markerSettings: MarkerSettings(isVisible: true),
                      dataLabelSettings: DataLabelSettings(isVisible: true))
                ],
                primaryXAxis: CategoryAxis(
                
                  labelRotation:300,
                    majorGridLines: const MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.hide,
                    interval: 3,
                    title: AxisTitle(text: 'Time')),
                primaryYAxis: CategoryAxis(
                  plotBands: <PlotBand>[
                  PlotBand(
                      verticalTextPadding: '-8%',
                      horizontalTextPadding: '-1%',opacity: 0.7,
                      text: 'Low!!!',
                      textAngle: 0,
                      start: 0,
                      end: 20,
                      color: Colors.white.withOpacity(1),
                      textStyle:
                          TextStyle(color: Colors.deepOrange, fontSize: 16),
                      borderColor: Colors.red,
                      borderWidth: 2)
                ],
                  axisLine: const AxisLine(width: 0),
                  majorTickLines: const MajorTickLines(size: 0),
                  title: AxisTitle(text: 'Fuel Lvl (%)'),
                ),
              ),
      ),

      
      
      
      
    );
  }
  @override
  void dispose() {
    super.dispose();
     timer?.cancel();
  //  _chartData!.clear();
  }
}
