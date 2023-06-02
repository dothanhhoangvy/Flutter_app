// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<Welcome> welcomeFromJson(String str) =>
    List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));

String welcomeToJson(List<Welcome> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Welcome {
  int? engineSpeed;
  String time;
  int? temperature;
  int? fuel;

  Welcome({
    this.engineSpeed,
    required this.time,
    this.temperature,
    this.fuel,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        engineSpeed: json["Engine_Speed"],
        time: json["Time"],
        temperature: json["Temperature"],
        fuel: json["Fuel"],
      );

  Map<String, dynamic> toJson() => {
        "Engine_Speed": engineSpeed,
        "Time": time,
        "Temperature": temperature,
        "Fuel": fuel,
      };
}
