import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'dart:async';
import 'package:testcapstone/NetworkHandler.dart';
import 'package:testcapstone/data/data.dart';

import "package:logger/logger.dart";

var logger = Logger();
const imgTabbar = "assets/supergraphic.svg";

class TempPara extends StatefulWidget {
  const TempPara({super.key});

  @override
  State<TempPara> createState() => _TempParaState();
}

class _TempParaState extends State<TempPara> {
  Timer? timer;
  bool circular =true;
  NetworkHandler networkHandler = NetworkHandler();
  DataModel dataModel = DataModel();
  StreamController<DataModel> _streamController = StreamController();
    @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1),(timer){
      
      fetchData();
    });
    
  }
  Future<void> fetchData() async {
    var response = await networkHandler.get("/home/data/tempt");
    // setState(() {
      dataModel =DataModel.fromJson(response);
      circular =false;
      if (!_streamController.isClosed) {
      _streamController.sink.add(dataModel);}
    // });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Engine Temperature",
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: const BackButton(
          color: Colors.black, // <-- SEE HERE
        ),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(10),
            child: SizedBox(
              height: 10,
              width: double.infinity,
              child: SvgPicture.asset(
                imgTabbar,
                fit: BoxFit.cover,
              ),
            )),
      ),
      // body: circular? CircularProgressIndicator(): 
      body: Center(
        child: StreamBuilder<DataModel>(
          stream: _streamController.stream,
        builder: (context,snapdata){
          switch(snapdata.connectionState){
            
            case ConnectionState.waiting: return const Center(child: CircularProgressIndicator(),);
            default: if(snapdata.hasError){
              return const Text("Please wait....");
              
            }else{
            
              return buildTemp(snapdata.data!);      
            }
          }
        }, 
        
        ),
      ),
    );
    
  }


  @override
  void dispose() {
    super.dispose();
    _streamController.close();
    // timer?.cancel();
  }


 }

// class _ChartData {
//   _ChartData(this.temperature, this.timestamp);
//   final double temperature;
//   final String timestamp;
// }

Widget buildTemp(DataModel dataModel){
  print(dataModel.temperature);
  // void localNotif() {
    double compare = 80;
    var value1 =  dataModel.temperature ?? 0;
      if (value1 >= compare ) {
        print(true);
        notify();
      }
  // }
    // late TooltipBehavior _tooltipBehavior;
    //     _tooltipBehavior = TooltipBehavior(enable: true);
    //     DataModel data = DataModel();
  return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SfLinearGauge(  
                minimum: -40,
                maximum: 210,
                orientation: LinearGaugeOrientation.vertical,
                majorTickStyle: const LinearTickStyle(
                    length: 10, thickness: 2.5, color: Colors.black),
                minorTickStyle: const LinearTickStyle(
                    length: 5, thickness: 1.75, color: Colors.black),
                minorTicksPerInterval: 10,
                axisLabelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                labelOffset: 5,
                markerPointers: [
                  LinearShapePointer(
                    value: dataModel.temperature! ,
                    
                    color: Colors.red,
                    shapeType: LinearShapePointerType.triangle,
                    offset: 5,
                    position: LinearElementPosition.inside,
                  )
                ],
                ranges: const <LinearGaugeRange>[
                  //First range
                  LinearGaugeRange(
                      startValue: 0, endValue: 70, color: Colors.green),
                  //Second range
                  LinearGaugeRange(
                      startValue: -40, endValue: 0, color: Colors.blue),
                  LinearGaugeRange(
                      startValue: 160, endValue: 210, color: Colors.red),
                                        LinearGaugeRange(
                      startValue: 70, endValue: 160, color: Colors.yellow),
                ],
                
              ),
              
            ),
            // SingleChildScrollView(
            //   child: SfCartesianChart(
            //     title: ChartTitle(text: "Engine Temperature Analysis"),
            //     // legend: Legend(isVisible: true),
            //     tooltipBehavior: _tooltipBehavior,
            //     series: <LineSeries<DataModel,double>>[
            //       LineSeries<DataModel,double>(
            //         name: "Temp",
            //         dataSource: DataModel data =[],
            //         xValueMapper: (DataModel dataModel, _) => dataModel.temperature,
            //         yValueMapper: (DataModel dataModel, _) => dataModel.temperature,
            //         enableTooltip: true,
            //         dataLabelSettings: const DataLabelSettings(
            //           isVisible: true,
            //           textStyle: TextStyle(
            //               fontStyle: FontStyle.normal,
            //               fontWeight: FontWeight.bold,
            //               fontSize: 10),
            //         ),
            //       )
            //     ],
            //     primaryXAxis: NumericAxis(
            //         majorGridLines: const MajorGridLines(width: 0),
            //         edgeLabelPlacement: EdgeLabelPlacement.shift,
            //         interval: 3,
            //         title: AxisTitle(text: 'Time (seconds)')),
            //     primaryYAxis: NumericAxis(
            //       labelFormat: '{value}°C',
            //       axisLine: const AxisLine(width: 0),
            //       majorTickLines: const MajorTickLines(size: 0),
            //       title: AxisTitle(text: 'Engine Temperature (°C)'),
            //     ),
            //   ),
            // ),
          ],
        ),
      );

}


  void notify() async {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: "basic_channel",
        title: "Temperature over!!! ${Emojis.symbols_warning}",
        body: "Alert over Temperature",
        bigPicture: 'asset://assets/alert.jpg',
        displayOnForeground: true,
        displayOnBackground: true,
        notificationLayout: NotificationLayout.BigPicture,
      ),
      actionButtons: [
        NotificationActionButton(
            key: 'DISMISS',
            label: 'Dismiss',
            actionType: ActionType.DismissAction,
            isDangerousOption: true)
      ]);
}




