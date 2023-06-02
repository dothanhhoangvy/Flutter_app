import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import 'controller_color.dart';

enum MqttCurrentConnectionState2 {
  IDLE2,
  CONNECTING2,
  CONNECTED2,
  DISCONNECTED2,
  ERROR_WHEN_CONNECTING2
}

enum MqttSubscriptionState2 { IDLE2, SUBSCRIBED2 }

class GaugeTemp extends StatefulWidget {
  const GaugeTemp({super.key});

  @override
  State<GaugeTemp> createState() => _GaugeTempState();
}

class _GaugeTempState extends State<GaugeTemp> {
  MqttCurrentConnectionState2 connectionState2 =
      MqttCurrentConnectionState2.IDLE2;
  MqttSubscriptionState2 subscriptionState2 = MqttSubscriptionState2.IDLE2;
  late MqttServerClient client2;
  late double EngTempVal = 0;
  late bool OverTmp = false;
  late double valengtmp = 0;

  @override
  void initState() {
    super.initState();
    storedata();
    prepareMqttClient2();
  }

  void prepareMqttClient2() async {
    _setupMqttClient2();
    await _connectClient2();
    _subscribeToTopic2('j1939/eng_ecu_temp');
  }

  void storedata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Timer.periodic(const Duration(seconds: 0), (timer) {
      if (!mounted) return;
      setState(() {
        valengtmp = pref.getDouble("engtmp") ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OverTmp ? Colors.red.withOpacity(0.1) : Colors.black,
        border: Border.all(
          color: OverTmp ? Colors.red : const Color(0xFF53F9FF),
          width: 2.w,
        ),
      ),
      height: 200.h,
      width: 150.w,
      child: Column(
        children: [
          Container(
            height: 180.h,
            width: 200.w,
            child: SfLinearGauge(
              minimum: -40,
              maximum: 210,
              orientation: LinearGaugeOrientation.vertical,
              majorTickStyle: LinearTickStyle(
                  length: 10, thickness: 2.5, color: Colors.white),
              minorTickStyle: LinearTickStyle(
                  length: 5, thickness: 1.75, color: Colors.white),
              minorTicksPerInterval: 9,
              axisLabelStyle: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              labelOffset: 10,
              markerPointers: [
                LinearWidgetPointer(
                  value: valengtmp,
                  position: LinearElementPosition.outside,
                  offset: 10,
                  child: Text("$valengtmp°C",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold)),
                ),
                LinearShapePointer(
                  value: valengtmp,
                  color: Colors.red,
                  shapeType: LinearShapePointerType.triangle,
                  position: LinearElementPosition.inside,
                  offset: 10,
                ),
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
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0).r,
            child: Container(
              width: 200.w,
              height: 79.h,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 15, 0, 0).r,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "engine".toUpperCase(),
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "temp".toUpperCase(),
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 30.sp),
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

  void _setupMqttClient2() {
    client2 = MqttServerClient.withPort('broker.hivemq.com', 'hoangvy', 1883);
    // the next 2 lines are necessary to connect with tls, which is used by HiveMQ Cloud

    // client.secure = true;
    // client.securityContext = SecurityContext.defaultContext;
    client2.clientIdentifier = "id2";
    client2.keepAlivePeriod = 20;
    client2.onDisconnected = _onDisconnected2;
    client2.onConnected = _onConnected2;
    client2.onSubscribed = _onSubscribed2;
  }

  void _subscribeToTopic2(String topicName2) {
    print('Subscribing to the $topicName2 topic');
    client2.subscribe(topicName2, MqttQos.atMostOnce);

    // print the message when it is received
    client2.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) async {
      final recMess2 = c[0].payload as MqttPublishMessage;
      var message2 =
          MqttPublishPayload.bytesToStringAsString(recMess2.payload.message);
      print("${c.length} | ${c[0].topic} : $message2");
      SharedPreferences pref = await SharedPreferences.getInstance();
      setState(() {
        EngTempVal = double.parse(message2);

        if (EngTempVal > 80) {
          OverTmp = true;

          notify1();
        } else {
          OverTmp = false;
        }
        setState(() {
          pref.setDouble("engtmp", EngTempVal);
        });
      });
    });
  }

  Future<void> _connectClient2() async {
    try {
      print('client2 connecting....');
      connectionState2 = MqttCurrentConnectionState2.CONNECTING2;
      await client2.connect();
    } on Exception catch (e) {
      print('client2 exception - $e');
      connectionState2 = MqttCurrentConnectionState2.ERROR_WHEN_CONNECTING2;
      client2.disconnect();
    }

    // when connected, print a confirmation, else print an error
    if (client2.connectionStatus!.state == MqttConnectionState.connected) {
      connectionState2 = MqttCurrentConnectionState2.CONNECTED2;
      print('client2 connected');
    } else {
      print(
          'ERROR client2 connection failed - disconnecting, status is ${client2.connectionStatus}');
      connectionState2 = MqttCurrentConnectionState2.ERROR_WHEN_CONNECTING2;
      client2.disconnect();
    }
  }

  void _onSubscribed2(String topic2) {
    print('Subscription confirmed for topic $topic2');
    subscriptionState2 = MqttSubscriptionState2.SUBSCRIBED2;
  }

  void _onDisconnected2() {
    print('OnDisconnected client2 callback - Client disconnection');
    connectionState2 = MqttCurrentConnectionState2.DISCONNECTED2;
  }

  void _onConnected2() {
    connectionState2 = MqttCurrentConnectionState2.CONNECTED2;
    print('OnConnected client2 callback - Client connection was sucessful');
  }
}

void notify1() async {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: "basic_channel",
        title: "Temperature over!!! ${Emojis.symbols_warning}",
        body: "Alert over Temperature",
        bigPicture: 'asset://assets/engtemp.png',
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
