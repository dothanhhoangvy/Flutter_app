import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

enum MqttCurrentConnectionState3 {
  IDLE3,
  CONNECTING3,
  CONNECTED3,
  DISCONNECTED3,
  ERROR_WHEN_CONNECTING3
}

enum MqttSubscriptionState3 { IDLE3, SUBSCRIBED3 }

class GaugeFuel extends StatefulWidget {
  const GaugeFuel({
    super.key,
  });
  State<GaugeFuel> createState() => _GaugeFuelState();
}

class _GaugeFuelState extends State<GaugeFuel> {
  late MqttServerClient client3;

  MqttCurrentConnectionState3 connectionState3 =
      MqttCurrentConnectionState3.IDLE3;
  MqttSubscriptionState3 subscriptionState3 = MqttSubscriptionState3.IDLE3;
  late double FuelLvlVal = 0;
  late bool OverFl = false;
  late double valfllvl = 0;
  @override
  void initState() {
    super.initState();
    prepareMqttClient3();
    storedata();
  }

  void storedata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Timer.periodic(const Duration(seconds: 0), (timer) {
      if (!mounted) return;
      setState(() {
        valfllvl = pref.getDouble("fuel") ?? 0;
      });
    });
  }

  void prepareMqttClient3() async {
    _setupMqttClient3();
    await _connectClient3();
    _subscribeToTopic3('j1939/eng_fuel_rate');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: OverFl ? Colors.red.withOpacity(0.1) : Colors.white10,
        border: Border.all(
          color: OverFl ? Colors.red : const Color(0xFF53F9FF),
          width: 2.w,
        ),
      ),
      height: 170.h,
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: 200.w,
            height: 79.h,
            child: Padding(
              padding: const EdgeInsets.all(8.0).r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "fuel".toUpperCase(),
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 30.sp),
                  ),
                  Text(
                    "level".toUpperCase(),
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 187.h,
            width: 200.w,
            child: SfRadialGauge(
              animationDuration: 5,
              axes: <RadialAxis>[
                RadialAxis(
                    startAngle: 180,
                    endAngle: 0,
                    showTicks: false,
                    showAxisLine: false,
                    showLabels: false,
                    canScaleToFit: true,
                    ranges: <GaugeRange>[
                      GaugeRange(
                          startValue: 0,
                          endValue: 10,
                          startWidth: 10,
                          endWidth: 12.5,
                          color: _color1),
                      GaugeRange(
                          startValue: 12,
                          endValue: 20,
                          startWidth: 12.5,
                          endWidth: 15,
                          color: _color2),
                      GaugeRange(
                          startValue: 22,
                          endValue: 30,
                          startWidth: 15,
                          endWidth: 17.5,
                          color: _color3),
                      GaugeRange(
                          startValue: 32,
                          endValue: 40,
                          startWidth: 17.5,
                          endWidth: 20,
                          color: _color4),
                      GaugeRange(
                          startValue: 42,
                          endValue: 50,
                          startWidth: 20,
                          endWidth: 22.5,
                          color: _color5),
                      GaugeRange(
                          startValue: 52,
                          endValue: 60,
                          startWidth: 22.5,
                          endWidth: 25,
                          color: _color6),
                      GaugeRange(
                          startValue: 62,
                          endValue: 70,
                          startWidth: 25,
                          endWidth: 27.5,
                          color: _color7),
                      GaugeRange(
                          startValue: 72,
                          endValue: 80,
                          startWidth: 27.5,
                          endWidth: 30,
                          color: _color8),
                      GaugeRange(
                          startValue: 82,
                          endValue: 90,
                          startWidth: 30,
                          endWidth: 32.5,
                          color: _color9),
                      GaugeRange(
                          startValue: 92,
                          endValue: 100,
                          startWidth: 32.5,
                          endWidth: 35,
                          color: _color10)
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(
                          value: valfllvl,
                          enableAnimation: true,
                          needleEndWidth: 7,
                          onValueChanged: _onPointerValueChanged,
                          needleStartWidth: 1,
                          needleColor: Colors.red,
                          needleLength: 0.85,
                          knobStyle: const KnobStyle(
                              color: Colors.white, knobRadius: 0.09))
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                          widget: Container(
                              width: 30.00,
                              height: 30.00,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: ExactAssetImage('assets/fuel.png'),
                                  fit: BoxFit.fill,
                                ),
                              )),
                          angle: 270,
                          positionFactor: 0.35),
                      GaugeAnnotation(
                          widget: Text(
                            'E',
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          angle: 168,
                          positionFactor: 1),
                      GaugeAnnotation(
                          widget: Text(
                            'F',
                            style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          angle: 12,
                          positionFactor: 0.95),
                    ])
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onPointerValueChanged(double _value) {
    setState(() {
      if (_value >= 0 && _value <= 10) {
        _onFirstRangeColorChanged();
      } else if (_value >= 10 && _value <= 20) {
        _onSecondRangeColorChanged();
      } else if (_value >= 20 && _value <= 30) {
        _onThirdRangeColorChanged();
      } else if (_value >= 30 && _value <= 40) {
        _onFourthRangeColorChanged();
      } else if (_value >= 40 && _value <= 50) {
        _onFifthRangeColorChanged();
      } else if (_value >= 50 && _value <= 60) {
        _onSixthRangeColorChanged();
      } else if (_value >= 60 && _value <= 70) {
        _onSeventhRangeColorChanged();
      } else if (_value >= 70 && _value <= 80) {
        _onEighthRangeColorChanged();
      } else if (_value >= 80 && _value <= 90) {
        _onNinethRangeColorChanged();
      } else if (_value >= 90 && _value <= 100) {
        _onTenthRangeColorChanged();
      }
    });
  }

  Future<void> _connectClient3() async {
    try {
      print('client3 connecting....');
      connectionState3 = MqttCurrentConnectionState3.CONNECTING3;
      await client3.connect();
    } on Exception catch (e) {
      print('client2 exception - $e');
      connectionState3 = MqttCurrentConnectionState3.ERROR_WHEN_CONNECTING3;
      client3.disconnect();
    }

    // when connected, print a confirmation, else print an error
    if (client3.connectionStatus!.state == MqttConnectionState.connected) {
      connectionState3 = MqttCurrentConnectionState3.CONNECTED3;
      print('client3 connected');
    } else {
      print(
          'ERROR client3 connection failed - disconnecting, status is ${client3.connectionStatus}');
      connectionState3 = MqttCurrentConnectionState3.ERROR_WHEN_CONNECTING3;
      client3.disconnect();
    }
  }

  void _setupMqttClient3() {
    client3 = MqttServerClient.withPort('broker.hivemq.com', 'hoangvy', 1883);
    // the next 2 lines are necessary to connect with tls, which is used by HiveMQ Cloud
    // client.secure = true;
    // client.securityContext = SecurityContext.defaultContext;
    client3.clientIdentifier = "id3";
    client3.keepAlivePeriod = 20;
    client3.onDisconnected = _onDisconnected3;
    client3.onConnected = _onConnected3;
    client3.onSubscribed = _onSubscribed3;
  }

  void _subscribeToTopic3(String topicName3) {
    print('Subscribing to the $topicName3 topic');
    client3.subscribe(topicName3, MqttQos.atMostOnce);

    // print the message when it is received
    client3.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) async {
      final recMess3 = c[0].payload as MqttPublishMessage;
      var message3 =
          MqttPublishPayload.bytesToStringAsString(recMess3.payload.message);
      print("${c.length} | ${c[0].topic} : $message3");
      SharedPreferences pref = await SharedPreferences.getInstance();
      setState(() {
        FuelLvlVal = double.parse(message3);
        double maxval = 3212.75;
        double percent = (FuelLvlVal / maxval) * 100.0;
        double compare3 = 20;
        if (percent < compare3) {
          OverFl = true;
          notify3();
        } else {
          OverFl = false;
        }
        setState(() {
          pref.setDouble("fuel", percent);
        });
      });
    });
  }

  // callbacks for different events

  void _onSubscribed3(String topic3) {
    print('Subscription confirmed for topic $topic3');
    subscriptionState3 = MqttSubscriptionState3.SUBSCRIBED3;
  }

  void _onDisconnected3() {
    print('OnDisconnected client3 callback - Client disconnection');
    connectionState3 = MqttCurrentConnectionState3.DISCONNECTED3;
  }

  void _onConnected3() {
    connectionState3 = MqttCurrentConnectionState3.CONNECTED3;
    print('OnConnected client3 callback - Client connection was sucessful');
  }
}

void notify3() async {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 3,
        channelKey: "basic_channel",
        title: "Fuel Low!!! ${Emojis.symbols_warning}",
        body: "Alert Low Fuel",
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

void _onFirstRangeColorChanged() {
  _color1 = Colors.red;
  _color2 = Colors.white;
  _color3 = Colors.white;
  _color4 = Colors.white;
  _color5 = Colors.white;
  _color6 = Colors.white;
  _color7 = Colors.white;
  _color8 = Colors.white;
  _color9 = Colors.white;
  _color10 = Colors.white;
}

void _onSecondRangeColorChanged() {
  _color1 = Colors.white;
  _color2 = Colors.red;
  _color3 = Colors.white;
  _color4 = Colors.white;
  _color5 = Colors.white;
  _color6 = Colors.white;
  _color7 = Colors.white;
  _color8 = Colors.white;
  _color9 = Colors.white;
  _color10 = Colors.white;
}

void _onThirdRangeColorChanged() {
  _color1 = Colors.white;
  _color2 = Colors.white;
  _color3 = Colors.red;
  _color4 = Colors.white;
  _color5 = Colors.white;
  _color6 = Colors.white;
  _color7 = Colors.white;
  _color8 = Colors.white;
  _color9 = Colors.white;
  _color10 = Colors.white;
}

void _onFourthRangeColorChanged() {
  _color1 = Colors.white;
  _color2 = Colors.white;
  _color3 = Colors.white;
  _color4 = Colors.red;
  _color5 = Colors.white;
  _color6 = Colors.white;
  _color7 = Colors.white;
  _color8 = Colors.white;
  _color9 = Colors.white;
  _color10 = Colors.white;
}

void _onFifthRangeColorChanged() {
  _color1 = Colors.white;
  _color2 = Colors.white;
  _color3 = Colors.white;
  _color4 = Colors.white;
  _color5 = Colors.red;
  _color6 = Colors.white;
  _color7 = Colors.white;
  _color8 = Colors.white;
  _color9 = Colors.white;
  _color10 = Colors.white;
}

void _onSixthRangeColorChanged() {
  _color1 = Colors.white;
  _color2 = Colors.white;
  _color3 = Colors.white;
  _color4 = Colors.white;
  _color5 = Colors.white;
  _color6 = Colors.red;
  _color7 = Colors.white;
  _color8 = Colors.white;
  _color9 = Colors.white;
  _color10 = Colors.white;
}

void _onSeventhRangeColorChanged() {
  _color1 = Colors.white;
  _color2 = Colors.white;
  _color3 = Colors.white;
  _color4 = Colors.white;
  _color5 = Colors.white;
  _color6 = Colors.white;
  _color7 = Colors.red;
  _color8 = Colors.white;
  _color9 = Colors.white;
  _color10 = Colors.white;
}

void _onEighthRangeColorChanged() {
  _color1 = Colors.white;
  _color2 = Colors.white;
  _color3 = Colors.white;
  _color4 = Colors.white;
  _color5 = Colors.white;
  _color6 = Colors.white;
  _color7 = Colors.white;
  _color8 = Colors.red;
  _color9 = Colors.white;
  _color10 = Colors.white;
}

void _onNinethRangeColorChanged() {
  _color1 = Colors.white;
  _color2 = Colors.white;
  _color3 = Colors.white;
  _color4 = Colors.white;
  _color5 = Colors.white;
  _color6 = Colors.white;
  _color7 = Colors.white;
  _color8 = Colors.white;
  _color9 = Colors.red;
  _color10 = Colors.white;
}

void _onTenthRangeColorChanged() {
  _color1 = Colors.white;
  _color2 = Colors.white;
  _color3 = Colors.white;
  _color4 = Colors.red;
  _color5 = Colors.white;
  _color6 = Colors.white;
  _color7 = Colors.white;
  _color8 = Colors.white;
  _color9 = Colors.white;
  _color10 = Colors.red;
}

Color _color1 = Colors.red;
Color _color2 = Colors.white;
Color _color3 = Colors.white;
Color _color4 = Colors.white;
Color _color5 = Colors.white;
Color _color6 = Colors.white;
Color _color7 = Colors.white;
Color _color8 = Colors.white;
Color _color9 = Colors.white;
Color _color10 = Colors.white;
