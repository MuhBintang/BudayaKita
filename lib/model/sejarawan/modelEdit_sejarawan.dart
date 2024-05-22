// To parse this JSON data, do
//
//     final modelEditSejarawan = modelEditSejarawanFromJson(jsonString);

import 'dart:convert';

ModelEditSejarawan modelEditSejarawanFromJson(String str) => ModelEditSejarawan.fromJson(json.decode(str));

String modelEditSejarawanToJson(ModelEditSejarawan data) => json.encode(data.toJson());

class ModelEditSejarawan {
    bool isSuccess;
    int value;
    String message;
    String nama;
    String tglLahir;
    String asal;
    String jenisKelamin;
    String deskripsi;

    ModelEditSejarawan({
        required this.isSuccess,
        required this.value,
        required this.message,
        required this.nama,
        required this.tglLahir,
        required this.asal,
        required this.jenisKelamin,
        required this.deskripsi,
    });

    factory ModelEditSejarawan.fromJson(Map<String, dynamic> json) => ModelEditSejarawan(
        isSuccess: json["is_success"],
        value: json["value"],
        message: json["message"],
        nama: json["nama"],
        tglLahir: json["tgl_lahir"],
        asal: json["asal"],
        jenisKelamin: json["jenis_kelamin"],
        deskripsi: json["deskripsi"],
    );

    Map<String, dynamic> toJson() => {
        "is_success": isSuccess,
        "value": value,
        "message": message,
        "nama": nama,
        "tgl_lahir": tglLahir,
        "asal": asal,
        "jenis_kelamin": jenisKelamin,
        "deskripsi": deskripsi,
    };
}
