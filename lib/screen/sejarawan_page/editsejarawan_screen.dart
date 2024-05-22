import 'dart:convert';
import 'dart:io';

import 'package:app_budaya/const.dart';
import 'package:app_budaya/main.dart';
import 'package:app_budaya/model/sejarawan/modelEdit_sejarawan.dart';
import 'package:app_budaya/model/sejarawan/model_sejarawan.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class SejarawanEditScreen extends StatefulWidget {
  final Datum? data;
  const SejarawanEditScreen(this.data ,{super.key});

  @override
  State<SejarawanEditScreen> createState() => _SejarawanEditScreenState();
}

class _SejarawanEditScreenState extends State<SejarawanEditScreen> {
  TextEditingController updatenama = TextEditingController();
  TextEditingController updategambar = TextEditingController();
  TextEditingController updatejenisKelamin = TextEditingController();
  TextEditingController updatedeskripsi = TextEditingController();
  TextEditingController updatetglLahir = TextEditingController();
  TextEditingController updateasal = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  bool isLoading = false;
  String? id;
  XFile? _image;

  _pilihGallery() async {
    var image = await ImagePicker().pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _image = image;
    });
  }

  _pilihCamera() async {
    var image = await ImagePicker().pickImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _image = image;
    });
  }

  Future<ModelEditSejarawan?> editSejarawan() async {
    try {
      setState(() {
        isLoading = true;
        print(id);
      });

      if (_image != null) {
        var stream =
            http.ByteStream(DelegatingStream.typed(_image!.openRead()));
        var length = await _image!.length();
        var uri = Uri.parse('${url}/edit_sejarawan.php');
        var request = http.MultipartRequest("POST", uri);
        var multipartFile = new http.MultipartFile(
          "foto",
          stream,
          length,
          filename: path.basename(_image!.path),
        );

        request.fields['id_sejarawan'] = widget.data!.idSejarawan;
        request.fields['nama'] = updatenama.text;
        request.files.add(multipartFile);
        request.fields['tgl_lahir'] = updatetglLahir.text;
        request.fields['asal'] = updateasal.text;
        request.fields['jenis_kelamin'] = updatejenisKelamin.text;
        request.fields['deskripsi'] = updatedeskripsi.text;

        var response = await request.send();

        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          var jsonResponse = json.decode(responseBody);
          ModelEditSejarawan data =
              modelEditSejarawanFromJson(jsonResponse);

          if (data.isSuccess == true) {
            setState(() {
              isLoading = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${data.message}')),
              );
            });
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BottomNavigationPage(),
              ),
              (route) => false,
            );
          } else {
            setState(() {
              isLoading = false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${data.message}')),
              );
            });
          }
        }
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please select an image')),
          );
        });
      }
    } catch (e) {
      // setState(() {
      //   isLoading = false;
      //   ScaffoldMessenger.of(context)
      //       .showSnackBar(SnackBar(content: Text(e.toString())));
      //   print(e.toString());
      // });
    }
  }

  @override
void initState() {
  super.initState();
  id = widget.data?.idSejarawan;
  updatenama = TextEditingController(text: widget.data?.nama ?? '');
  updategambar = TextEditingController(text: widget.data?.foto ?? '');
  updatetglLahir = TextEditingController(text: widget.data?.tglLahir?? '');
  updateasal = TextEditingController(text: widget.data?.asal ?? '');
  updatedeskripsi = TextEditingController(text: widget.data?.deskripsi ?? '');
  updatejenisKelamin = TextEditingController(text: widget.data?.jenisKelamin ?? '');
}


  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 150,
      child: Icon(Icons.file_copy_rounded),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Data Sejarah", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
        backgroundColor: Color(0xff3EBFAA),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: keyForm,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      // _pilihCamera();
                      _pilihGallery();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 500.0,
                      child: _image == null
                          ? Image.network(
                              '$url/sejarawan/${widget.data?.foto}',
                              fit: BoxFit.fill,
                            )
                          : Image.file(
                              File(_image!.path),
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: updatenama,
                    validator: (val) {
                      return val!.isEmpty ? "Tidak boleh kosong" : null;
                    },
                    decoration: InputDecoration(
                        labelText: "Nama",
                        hintText: "Nama",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3EBFAA)),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: updatetglLahir,
                    validator: (val) {
                      return val!.isEmpty ? "Tidak boleh kosong" : null;
                    },
                    decoration: InputDecoration(
                        labelText: "Tanggal Lahir",
                        hintText: "Tanggal Lahir",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3EBFAA)),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: updateasal,
                    validator: (val) {
                      return val!.isEmpty ? "Tidak boleh kosong" : null;
                    },
                    decoration: InputDecoration(
                        labelText: "Asal",
                        hintText: "Asal",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3EBFAA)),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: updatejenisKelamin,
                    validator: (val) {
                      return val!.isEmpty ? "Tidak boleh kosong" : null;
                    },
                    decoration: InputDecoration(
                        labelText: "Jenis Kelamin",
                        hintText: "Jenis Kelamin",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3EBFAA)),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: updatedeskripsi,
                    validator: (val) {
                      return val!.isEmpty ? "Tidak boleh kosong" : null;
                    },
                    decoration: InputDecoration(
                        labelText: "Deskripsi",
                        hintText: "Deskripsi",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Color(0xff3EBFAA)),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () async {
                      if (keyForm.currentState?.validate() == true) {
                        await editSejarawan(); // Tunggu hingga operasi selesai
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BottomNavigationPage()),
                          (route) => false,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Silahkan isi data terlebih dahulu"),
                          ),
                        );
                      }
                    },
                    color: Color(0xff3EBFAA),
                    textColor: Colors.white,
                    height: 45,
                    child: const Text("Submit"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}