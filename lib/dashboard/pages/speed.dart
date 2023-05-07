import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'package:testcapstone/NetworkHandler.dart';
import 'package:testcapstone/data/data.dart';
const imgTabbar = "assets/supergraphic.svg";

class SpeedPara extends StatefulWidget {
  const SpeedPara({super.key});

  @override
  State<SpeedPara> createState() => _SpeedParaState();
}

class _SpeedParaState extends State<SpeedPara> {
  Timer? timer;
  bool circular =true;
  NetworkHandler networkHandler = NetworkHandler();
  DataModel? dataModel = DataModel();
  late TooltipBehavior _tooltipBehavior;
    StreamController<DataModel> _streamController = StreamController();
  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 3),(timer){
      fetchData();
    });
  }
    Future<void> fetchData() async {
    var response = await networkHandler.get("/home/data/speed");
    // setState(() {
      DataModel dataModel =DataModel?.fromJson(response);
      circular =false;
      if (!_streamController.isClosed) {
      _streamController.sink.add(dataModel);}
    // });
  }
  // void LocalNotif() {
  //   double compare = 120;
  //   var value1 =  dataModel?.engine_speed ?? 0;
  //   setState(() {
  //     if (value1 > compare ) {
  //       Notify();
  //     }
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    _tooltipBehavior = TooltipBehavior(enable: true);
    // _getChartData();

    // timer = Timer.periodic(const Duration(milliseconds: 5000), (_timer) {
    //   setState(() {
    //     _getChartData();
    //   });
    // });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Engine Speed",
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
        child: StreamBuilder<DataModel>(
          stream: _streamController.stream,
        builder: (context,snapdata){
          switch(snapdata.connectionState){
            case ConnectionState.waiting: return const Center(child: CircularProgressIndicator(),);
            default: if(snapdata.hasError){
              return const Text("Please wait....");
            }else{
              return BuildSpeed(snapdata.data!);
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
  //  _chartData!.clear();
  }
  // void _getChartData() {
  //   _chartData = <_ChartData>[];
  //   for (int i = 0; i <= 20; i++) {
  //     _chartData!.add(_ChartData(i, _value.toInt()));
  //   }
  // }


void labelCreated(AxisLabelCreatedArgs args) {
    if (args.text == '0') {
      args.text = 'N';
      args.labelStyle = const GaugeTextStyle(
          color: Colors.red, fontWeight: FontWeight.bold, fontSize: 14);
    } else if (args.text == '10') {
      args.text = '';
    } else if (args.text == '20') {
      args.text = 'E';
    } else if (args.text == '30') {
      args.text = '';
    } else if (args.text == '40') {
      args.text = 'S';
    } else if (args.text == '50') {
      args.text = '';
    } else if (args.text == '60') {
      args.text = 'W';
    } else if (args.text == '70') {
      args.text = '';
    }
  }
  Widget BuildSpeed(DataModel dataModel){
      print(dataModel.engine_speed);
  // void localNotif() {
    double compare = 120;
    var value1 =  dataModel.engine_speed ?? 0;
      if (value1 >= compare ) {
        print(true)
;        notify();
      }
  return SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0).r,
                child: SfRadialGauge(axes: <RadialAxis>[
                  RadialAxis(
                      startAngle: 270,
                      endAngle: 270,
                      minimum: 0,
                      maximum: 80,
                      interval: 10,
                      radiusFactor: 0.4,
                      showAxisLine: false,
                      showLastLabel: false,
                      minorTicksPerInterval: 4,
                      majorTickStyle: const MajorTickStyle(
                          length: 8, thickness: 3, color: Colors.black),
                      minorTickStyle: const MinorTickStyle(
                          length: 3, thickness: 1.5, color: Colors.black),
                      axisLabelStyle: const GaugeTextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      onLabelCreated: labelCreated),
                  RadialAxis(
                      minimum: 0,
                      maximum: 200,
                      labelOffset: 30,
                      axisLineStyle: const AxisLineStyle(
                          thicknessUnit: GaugeSizeUnit.factor,
                          thickness: 0.03),
                      majorTickStyle: const MajorTickStyle(
                          length: 6, thickness: 4, color: Colors.black),
                      minorTickStyle: const MinorTickStyle(
                          length: 3, thickness: 3, color: Colors.black),
                      axisLabelStyle: const GaugeTextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      ranges: <GaugeRange>[
                        GaugeRange(
                            startValue: 0,
                            endValue: 200,
                            sizeUnit: GaugeSizeUnit.factor,
                            startWidth: 0.03,
                            endWidth: 0.03,
                            gradient: const SweepGradient(colors: <Color>[
                              Colors.green,
                              Colors.yellow,
                              Colors.red
                            ], stops: <double>[
                              0.0,
                              0.5,
                              1
                            ]))
                      ],
                      pointers: <GaugePointer>[
                        NeedlePointer(
                            value: dataModel.engine_speed!,
                            needleLength: 0.95,
                            enableAnimation: true,
                            animationType: AnimationType.ease,
                            needleStartWidth: 1.5,
                            needleEndWidth: 6,
                            needleColor: Colors.red,
                            knobStyle: const KnobStyle(
                                knobRadius: 0.09,
                                sizeUnit: GaugeSizeUnit.factor))
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            widget: Column(children: <Widget>[
                              Text(dataModel.engine_speed!.toString(),
                                  style: TextStyle(
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              Text('Km/h',
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold))
                            ]),
                            angle: 90,
                            positionFactor: 1.75),
                      ])
                ]),
              ),
              // Slider(
              //     min: 0,
              //     max: 200,
              //     divisions: 200,
              //     value: _value,
              //     onChanged: (value) {
              //       setState(() {
              //         _value = value;
              //       });
              //     }),
              // SfCartesianChart(
              //   title: ChartTitle(text: "Engine Speed Analysis"),
              //   // legend: Legend(isVisible: true),
              //   tooltipBehavior: _tooltipBehavior,
              //   series: <LineSeries<_ChartData, num>>[
              //     LineSeries<_ChartData, num>(
              //       name: "Speed",
              //       dataSource: _chartData!,
              //       xValueMapper: (_ChartData sales, _) => sales.x,
              //       yValueMapper: (_ChartData sales, _) => sales.y,
              //       enableTooltip: true,
              //       dataLabelSettings: const DataLabelSettings(
              //         isVisible: true,
              //         textStyle: TextStyle(
              //             fontStyle: FontStyle.normal,
              //             fontWeight: FontWeight.bold,
              //             fontSize: 10),
              //       ),
              //     )
              //   ],
              //   primaryXAxis: NumericAxis(
              //       majorGridLines: const MajorGridLines(width: 0),
              //       edgeLabelPlacement: EdgeLabelPlacement.shift,
              //       interval: 3,
              //       title: AxisTitle(text: 'Time (seconds)')),
              //   primaryYAxis: NumericAxis(
              //     labelFormat: '{value}',
              //     axisLine: const AxisLine(width: 0),
              //     majorTickLines: const MajorTickLines(size: 0),
              //     title: AxisTitle(text: 'Engine speed (Km/h)'),
              //   ),
              // ),
            ],
          ),
        ),
      );}


}

// List<_ChartData>? _chartData;
// class _ChartData {
//   _ChartData(this.x, this.y);
//   final int x;
//   final int y;
// }

void notify() async {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: "basic_channel",
        title: "Speed over!!! ${Emojis.symbols_warning}",
        body: "Alert over speed",
        bigPicture: 'asset://assets/alert.jpg',
        displayOnForeground: true,
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
