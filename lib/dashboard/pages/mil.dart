import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:odometer/odometer.dart';
import 'package:testcapstone/NetworkHandler.dart';
import 'package:testcapstone/data/data.dart';

const imgTabbar = "assets/supergraphic.svg";

class MileagePara extends StatefulWidget {
  const MileagePara({super.key});

  @override
  State<MileagePara> createState() => _MileageParaState();
}

class _MileageParaState extends State<MileagePara> {

  Timer? timer;
  bool circular =true;
  NetworkHandler networkHandler = NetworkHandler();
  StreamController<DataModel> _streamController = StreamController();
  @override
void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1),(timer){
      fetchData();
    });
  }
  Future<void> fetchData() async {
    var response = await networkHandler.get("data/");
    // setState(() {
      DataModel dataModel =DataModel?.fromJson(response);
      circular =false;
      if (!_streamController.isClosed) {
      _streamController.sink.add(dataModel);}
    // });
  }

    @override
  void dispose() {
    super.dispose();
    _streamController.close();
    // timer?.cancel();
  //  _chartData!.clear();
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mileage",
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
      body: Center(
        child: StreamBuilder<DataModel>(
          stream: _streamController.stream,
        builder: (context,snapdata){
          switch(snapdata.connectionState){
            case ConnectionState.waiting: return const Center(child: CircularProgressIndicator(),);
            default: if(snapdata.hasError){
              return const Text("Please wait....");
            }else{
              return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            width: double.infinity,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSlideOdometerNumber(
                  groupSeparator: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                  ),
                  odometerNumber: OdometerNumber(snapdata.data!.Mileage!.toInt()),
                  duration: const Duration(milliseconds: 1000),
                  letterWidth: 35,
                  numberTextStyle: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              ],
            ),
          ),
        );
            }
          }
        }, 
        ),
      ),  
    );
  }
}
