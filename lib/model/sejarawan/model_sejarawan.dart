// To parse this JSON data, do
//
//     final modelSejarawan = modelSejarawanFromJson(jsonString);

import 'dart:convert';

ModelSejarawan modelSejarawanFromJson(String str) => ModelSejarawan.fromJson(json.decode(str));

String modelSejarawanToJson(ModelSejarawan data) => json.encode(data.toJson());

class ModelSejarawan {
    bool isSuccess;
    String message;
    List<Datum> data;

    ModelSejarawan({
        required this.isSuccess,
        required this.message,
        required this.data,
    });

    factory ModelSejarawan.fromJson(Map<String, dynamic> json) => ModelSejarawan(
        isSuccess: json["isSuccess"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "isSuccess": isSuccess,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String idSejarawan;
    String nama;
    String foto;
    String tglLahir;
    String asal;
    String jenisKelamin;
    String deskripsi;

    Datum({
        required this.idSejarawan,
        required this.nama,
        required this.foto,
        required this.tglLahir,
        required this.asal,
        required this.jenisKelamin,
        required this.deskripsi,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        idSejarawan: json["id_sejarawan"],
        nama: json["nama"],
        foto: json["foto"],
        tglLahir: json["tgl_lahir"],
        asal: json["asal"],
        jenisKelamin: json["jenis_kelamin"],
        deskripsi: json["deskripsi"],
    );

    Map<String, dynamic> toJson() => {
        "id_sejarawan": idSejarawan,
        "nama": nama,
        "foto": foto,
        "tgl_lahir": tglLahir,
        "asal": asal,
        "jenis_kelamin": jenisKelamin,
        "deskripsi": deskripsi,
    };
}
