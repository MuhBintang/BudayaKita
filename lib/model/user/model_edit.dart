// To parse this JSON data, do
//
//     final modelEditUser = modelEditUserFromJson(jsonString);

import 'dart:convert';

ModelEditUser modelEditUserFromJson(String str) => ModelEditUser.fromJson(json.decode(str));

String modelEditUserToJson(ModelEditUser data) => json.encode(data.toJson());

class ModelEditUser {
    bool isSuccess;
    int value;
    String message;
    String username;
    String idUser;
    String nama;
    String email;
    String nohp;
    String alamat;

    ModelEditUser({
        required this.isSuccess,
        required this.value,
        required this.message,
        required this.username,
        required this.idUser,
        required this.nama,
        required this.email,
        required this.nohp,
        required this.alamat,
    });

    factory ModelEditUser.fromJson(Map<String, dynamic> json) => ModelEditUser(
        isSuccess: json["is_success"],
        value: json["value"],
        message: json["message"],
        username: json["username"],
        idUser: json["id_user"],
        nama: json["nama"],
        email: json["email"],
        nohp: json["nohp"],
        alamat: json["alamat"],
    );

    Map<String, dynamic> toJson() => {
        "is_success": isSuccess,
        "value": value,
        "message": message,
        "username": username,
        "id_user": idUser,
        "nama": nama,
        "email": email,
        "nohp": nohp,
        "alamat": alamat,
    };
}
