import 'package:app_budaya/const.dart';
import 'package:app_budaya/model/berita/model_berita.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailBeritaScreen extends StatelessWidget {

  //konstruktor penampung data
  final Datum? data;
  const DetailBeritaScreen(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3EBFAA),
        title: Text(
          data!.judul, 
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(data?.author ?? "", 
              style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            ),
            ),
          ),
          SizedBox(height: 3),
          Padding(
            padding: EdgeInsets.all(10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network('$url/image/${data?.gambar}',
                fit: BoxFit.fill,
              ),
            ),
          ),
          ListTile(
            title: Text(data?.judul ?? "",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
              ),
            ),
            subtitle: Text(DateFormat().format(data?.created ?? DateTime.now())),
            trailing: Icon(Icons.star, color: Color(0xff3EBFAA),),
          ),

          Container(
            margin: EdgeInsets.all(10),
            child: Text(data?.konten ?? "", style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold
            ),),
          )
        ],
      ),
    );
  }
}