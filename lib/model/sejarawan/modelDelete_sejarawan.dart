// To parse this JSON data, do
//
//     final modelDeleteSejarawan = modelDeleteSejarawanFromJson(jsonString);

import 'dart:convert';

ModelDeleteSejarawan modelDeleteSejarawanFromJson(String str) => ModelDeleteSejarawan.fromJson(json.decode(str));

String modelDeleteSejarawanToJson(ModelDeleteSejarawan data) => json.encode(data.toJson());

class ModelDeleteSejarawan {
    int value;
    String message;

    ModelDeleteSejarawan({
        required this.value,
        required this.message,
    });

    factory ModelDeleteSejarawan.fromJson(Map<String, dynamic> json) => ModelDeleteSejarawan(
        value: json["value"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "value": value,
        "message": message,
    };
}
