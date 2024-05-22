// To parse this JSON data, do
//
//     final modelCreateSejarawan = modelCreateSejarawanFromJson(jsonString);

import 'dart:convert';

ModelCreateSejarawan modelCreateSejarawanFromJson(String str) => ModelCreateSejarawan.fromJson(json.decode(str));

String modelCreateSejarawanToJson(ModelCreateSejarawan data) => json.encode(data.toJson());

class ModelCreateSejarawan {
    bool isSuccess;
    String message;

    ModelCreateSejarawan({
        required this.isSuccess,
        required this.message,
    });

    factory ModelCreateSejarawan.fromJson(Map<String, dynamic> json) => ModelCreateSejarawan(
        isSuccess: json["isSuccess"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
    };
}
