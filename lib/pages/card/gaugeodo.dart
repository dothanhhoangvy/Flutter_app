import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'package:odometer/odometer.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MqttCurrentConnectionState4 {
  IDLE4,
  CONNECTING4,
  CONNECTED4,
  DISCONNECTED4,
  ERROR_WHEN_CONNECTING4
}

enum MqttSubscriptionState4 { IDLE4, SUBSCRIBED4 }

class GaugeOdo extends StatefulWidget {
  const GaugeOdo({super.key});

  @override
  State<GaugeOdo> createState() => _GaugeOdoState();
}

class _GaugeOdoState extends State<GaugeOdo> {
  late MqttServerClient client4;
  late bool odocon = false;
  MqttCurrentConnectionState4 connectionState4 =
      MqttCurrentConnectionState4.IDLE4;
  MqttSubscriptionState4 subscriptionState4 = MqttSubscriptionState4.IDLE4;
  late double MilVal = 0;
  late double odoval = 0;
  @override
  void initState() {
    super.initState();
    storedata();
    prepareMqttClient4();
  }

  void prepareMqttClient4() async {
    _setupMqttClient4();
    await _connectClient4();
    _subscribeToTopic4('j1939/mileague');
  }

  void storedata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    Timer.periodic(const Duration(seconds: 0), (timer) {
      if (!mounted) return;
      setState(() {
        odoval = pref.getDouble("odo") ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: odocon ? Colors.red.withOpacity(0.1) : Colors.white10,
        border: Border.all(
          color: odocon ? Colors.red : const Color(0xFF53F9FF),
          width: 2.w,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
                    "Mileage".toUpperCase(),
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 30.sp),
                  ),
                  Text(
                    "Distance".toUpperCase(),
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(3, 55, 0, 0).r,
            child: Container(
              height: 60.h,
              decoration: BoxDecoration(
                color: Colors.white10,
                border: Border.all(
                  color: Colors.white,
                  width: 2.w,
                ),
                borderRadius: BorderRadius.circular(10).r,
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0).r,
                child: AnimatedSlideOdometerNumber(
                  groupSeparator: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                  ),
                  odometerNumber: OdometerNumber(MilVal.toInt()),
                  duration: const Duration(milliseconds: 1000),
                  letterWidth: 25.w,
                  numberTextStyle: TextStyle(
                      fontSize: 25.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _connectClient4() async {
    try {
      print('client4 connecting....');
      connectionState4 = MqttCurrentConnectionState4.CONNECTING4;
      await client4.connect();
    } on Exception catch (e) {
      print('client4 exception - $e');
      connectionState4 = MqttCurrentConnectionState4.ERROR_WHEN_CONNECTING4;
      client4.disconnect();
    }

    // when connected, print a confirmation, else print an error
    if (client4.connectionStatus!.state == MqttConnectionState.connected) {
      connectionState4 = MqttCurrentConnectionState4.CONNECTED4;
      print('client4 connected');
    } else {
      print(
          'ERROR client4 connection failed - disconnecting, status is ${client4.connectionStatus}');
      connectionState4 = MqttCurrentConnectionState4.ERROR_WHEN_CONNECTING4;
      client4.disconnect();
    }
  }

  void _setupMqttClient4() {
    client4 = MqttServerClient.withPort('broker.hivemq.com', 'hoangvy', 1883);
    // the next 2 lines are necessary to connect with tls, which is used by HiveMQ Cloud
    // client.secure = true;
    // client.securityContext = SecurityContext.defaultContext;
    client4.clientIdentifier = "id4";
    client4.keepAlivePeriod = 20;
    client4.onDisconnected = _onDisconnected4;
    client4.onConnected = _onConnected4;
    client4.onSubscribed = _onSubscribed4;
  }

  void _subscribeToTopic4(String topicName4) {
    print('Subscribing to the $topicName4 topic');
    client4.subscribe(topicName4, MqttQos.atMostOnce);

    // print the message when it is received
    client4.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) async {
      final recMess4 = c[0].payload as MqttPublishMessage;
      var message4 =
          MqttPublishPayload.bytesToStringAsString(recMess4.payload.message);
      print("${c.length} | ${c[0].topic} : $message4");
      SharedPreferences pref = await SharedPreferences.getInstance();
      setState(() {
        MilVal = double.parse(message4);

        if ((MilVal % 200) == 0) {
          odocon = true;
          print(odocon);
          print(true);
          notify4();
        } else {
          odocon = false;
        }
        setState(() {
          pref.setDouble("odo", MilVal);
        });
      });
    });
  }

  void _onSubscribed4(String topic4) {
    print('Subscription confirmed for topic $topic4');
    subscriptionState4 = MqttSubscriptionState4.SUBSCRIBED4;
  }

  void _onDisconnected4() {
    print('OnDisconnected client4 callback - Client disconnection');
    connectionState4 = MqttCurrentConnectionState4.DISCONNECTED4;
  }

  void _onConnected4() {
    connectionState4 = MqttCurrentConnectionState4.CONNECTED4;
    print('OnConnected client4 callback - Client connection was sucessful');
  }
}

void notify4() async {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 4,
        channelKey: "basic_channel",
        title: "Maintenance!!! ${Emojis.symbols_warning}",
        body: "Time to maintenance",
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
