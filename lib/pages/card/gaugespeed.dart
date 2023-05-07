import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

enum MqttCurrentConnectionState1 {
  IDLE1,
  CONNECTING1,
  CONNECTED1,
  DISCONNECTED1,
  ERROR_WHEN_CONNECTING1
}

enum MqttSubscriptionState1 { IDLE1, SUBSCRIBED1 }

class GaugeSpeed extends StatefulWidget {
  const GaugeSpeed({super.key});

  @override
  State<GaugeSpeed> createState() => _GaugeSpeedState();
}

class _GaugeSpeedState extends State<GaugeSpeed> {
  late MqttServerClient client1;
  late bool OverSpd = false;
  MqttCurrentConnectionState1 connectionState1 =
      MqttCurrentConnectionState1.IDLE1;
  MqttSubscriptionState1 subscriptionState1 = MqttSubscriptionState1.IDLE1;
  late double VhSpdVal = 0;
  late double valvhspd = 0;
  @override
  void initState() {
    super.initState();
    storedata();
    prepareMqttClient1();
  }

  void prepareMqttClient1() async {
    _setupMqttClient1();
    await _connectClient1();
    _subscribeToTopic1('j1939/vehicle_speed');
  }

  void storedata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Timer.periodic(const Duration(seconds: 0), (timer) {
      if (!mounted) return;
      setState(() {
        valvhspd = pref.getDouble("speed") ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OverSpd ? Colors.red.withOpacity(0.1) : Colors.white10,
        border: Border.all(
          color: OverSpd ? Colors.red : const Color(0xFF53F9FF),
          width: 2.w,
        ),
      ),
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 187.h,
            width: 200.w,
            child: SfRadialGauge(
              axes: <RadialAxis>[
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
                        length: 5, thickness: 3, color: Colors.white),
                    minorTickStyle: const MinorTickStyle(
                        length: 1, thickness: 1.5, color: Colors.white),
                    axisLabelStyle: GaugeTextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp),
                    labelOffset: 0.8,
                    onLabelCreated: labelCreated),
                RadialAxis(
                  minimum: 0,
                  maximum: 200,
                  labelOffset: 15,
                  axisLineStyle: const AxisLineStyle(
                      thicknessUnit: GaugeSizeUnit.factor, thickness: 0.03),
                  majorTickStyle: const MajorTickStyle(
                      length: 6, thickness: 4, color: Colors.white),
                  minorTickStyle: const MinorTickStyle(
                      length: 3, thickness: 3, color: Colors.white),
                  axisLabelStyle: const GaugeTextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                  interval: 30,
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
                        value: valvhspd,
                        needleLength: 0.95,
                        enableAnimation: true,
                        animationType: AnimationType.ease,
                        needleStartWidth: 1.5,
                        needleEndWidth: 6,
                        needleColor: Colors.red,
                        knobStyle: const KnobStyle(
                            knobRadius: 0.09,
                            sizeUnit: GaugeSizeUnit.factor,
                            color: Colors.white))
                  ],
                  annotations: <GaugeAnnotation>[
                    GaugeAnnotation(
                        widget: Column(children: <Widget>[
                          Text(valvhspd.toString(),
                              style: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          const SizedBox(height: 5),
                          Text('Km/h',
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))
                        ]),
                        angle: 90,
                        positionFactor: 1.7),
                  ],
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0).r,
            child: Container(
              width: 200.w,
              height: 79.h,
              child: Padding(
                padding: const EdgeInsets.all(10.0).r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "vehicle".toUpperCase(),
                      style: TextStyle(fontSize: 20.sp, color: Colors.white),
                    ),
                    Text(
                      "speed".toUpperCase(),
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 25.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _connectClient1() async {
    try {
      print('client1 connecting....');
      connectionState1 = MqttCurrentConnectionState1.CONNECTING1;
      await client1.connect();
    } on Exception catch (e) {
      print('client1 exception - $e');
      connectionState1 = MqttCurrentConnectionState1.ERROR_WHEN_CONNECTING1;
      client1.disconnect();
    }

    // when connected, print a confirmation, else print an error
    if (client1.connectionStatus!.state == MqttConnectionState.connected) {
      connectionState1 = MqttCurrentConnectionState1.CONNECTED1;
      print('client1 connected');
    } else {
      print(
          'ERROR client1 connection failed - disconnecting, status is ${client1.connectionStatus}');
      connectionState1 = MqttCurrentConnectionState1.ERROR_WHEN_CONNECTING1;
      client1.disconnect();
    }
  }

  void _setupMqttClient1() {
    client1 = MqttServerClient.withPort('broker.hivemq.com', 'hoangvy', 1883);
    // the next 2 lines are necessary to connect with tls, which is used by HiveMQ Cloud
    // client.secure = true;
    // client.securityContext = SecurityContext.defaultContext;
    client1.clientIdentifier = "id1";
    client1.keepAlivePeriod = 20;
    client1.onDisconnected = _onDisconnected1;
    client1.onConnected = _onConnected1;
    client1.onSubscribed = _onSubscribed1;
  }

  void _subscribeToTopic1(String topicName1) {
    print('Subscribing to the $topicName1 topic');
    client1.subscribe(topicName1, MqttQos.atMostOnce);

    // print the message when it is received
    client1.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) async {
      final recMess1 = c[0].payload as MqttPublishMessage;
      var message1 =
          MqttPublishPayload.bytesToStringAsString(recMess1.payload.message);
      print("${c.length} | ${c[0].topic} : $message1");
      SharedPreferences pref = await SharedPreferences.getInstance();
      setState(() {
        VhSpdVal = double.parse(message1);

        double compare2 = 80;
        if (VhSpdVal >= compare2) {
          OverSpd = true;
          print(OverSpd);
          print(true);
          notify2();
        } else {
          OverSpd = false;
        }
        setState(() {
          pref.setDouble("speed", VhSpdVal);
        });
      });
    });
  }

  void _onSubscribed1(String topic1) {
    print('Subscription confirmed for topic $topic1');
    subscriptionState1 = MqttSubscriptionState1.SUBSCRIBED1;
  }

  void _onDisconnected1() {
    print('OnDisconnected client1 callback - Client disconnection');
    connectionState1 = MqttCurrentConnectionState1.DISCONNECTED1;
  }

  void _onConnected1() {
    connectionState1 = MqttCurrentConnectionState1.CONNECTED1;
    print('OnConnected client1 callback - Client connection was sucessful');
  }
}

void labelCreated(AxisLabelCreatedArgs args) {
  if (args.text == '0') {
    args.text = 'N';
    args.labelStyle = const GaugeTextStyle(
        color: Colors.red, fontWeight: FontWeight.bold, fontSize: 10);
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

void notify2() async {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 2,
        channelKey: "basic_channel",
        title: "Speed over!!! ${Emojis.symbols_warning}",
        body: "Alert Over Speed",
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
