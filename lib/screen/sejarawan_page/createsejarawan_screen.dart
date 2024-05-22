import 'dart:io';

import 'package:app_budaya/const.dart';
import 'package:app_budaya/main.dart';
import 'package:app_budaya/model/sejarawan/modelCreate_sejarawan.dart';
import 'package:app_budaya/screen/sejarawan_page/listsejarawan_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:async/async.dart';

class SejarawanCreateScreen extends StatefulWidget {
  const SejarawanCreateScreen({Key? key}) : super(key: key);

  @override
  State<SejarawanCreateScreen> createState() => _SejarawanCreateScreenState();
}

class _SejarawanCreateScreenState extends State<SejarawanCreateScreen> {
  XFile? _image;
  String? _nama;
  final picker = ImagePicker();
  TextEditingController nama = TextEditingController();
  TextEditingController asal = TextEditingController();
  TextEditingController valjK = TextEditingController();
  TextEditingController deskripsi = TextEditingController();
  TextEditingController gambar = TextEditingController();
  TextEditingController tglLahir = TextEditingController();

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  bool isLoading = false;

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

// <modelTambahPegawai>
  Future<ModelCreateSejarawan?> registerAccount() async {
    try {
      setState(() {
        isLoading = true;
      });

      var stream = http.ByteStream(DelegatingStream.typed(_image!.openRead()));
      var length = await _image!.length();
      var uri = Uri.parse('${url}/create_sejarawan.php');
      var request = http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile(
        "foto",
        stream,
        length,
        filename: path.basename(_image!.path),
      );

      request.fields['nama'] = nama.text;
      request.files.add(multipartFile);
      request.fields['tgl_lahir'] = tglLahir.text;
      request.fields['asal'] = asal.text;
      request.fields['jenis_kelamin'] = valjK.text;
      request.fields['deskripsi'] = deskripsi.text;

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        ModelCreateSejarawan data = modelCreateSejarawanFromJson(responseBody);
        if (data.isSuccess == true) {
          setState(() {
            isLoading = false;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('${data.message}')));
          });

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => BottomNavigationPage()),
              (route) => false);
        } else if (data.isSuccess == false) {
          setState(() {
            isLoading = false;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('${data.message}')));
          });
        } else {
          setState(() {
            isLoading = false;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('${data.message}')));
          });
        }
      }
    } catch (e) {
      setState(() {
        print(e.toString());
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // registerAccount();
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
        title: Text(
          "Tambah Sejarawan",
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff3EBFAA),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: keyForm,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: nama,
                    validator: (val) {
                      return val!.isEmpty ? "Tidak boleh kosong" : null;
                    },
                    decoration: InputDecoration(
                        labelText: "Nama",
                        hintText: "Nama",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.blue.shade300),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  InkWell(
                    onTap: () {
                      // _pilihCamera();
                      _pilihGallery();
                    },
                    child: Container(
                      width: double.infinity,
                      height: 150.0,
                      child: _image == null
                          ? placeholder
                          : Image.file(
                              File(_image!.path),
                              fit: BoxFit.fill,
                            ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: deskripsi,
                    validator: (val) {
                      return val!.isEmpty ? "Tidak boleh kosong" : null;
                    },
                    decoration: InputDecoration(
                        labelText: "Deskripsi",
                        hintText: "Deskripsi",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.blue.shade300),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: asal,
                    validator: (val) {
                      return val!.isEmpty ? "Tidak boleh kosong" : null;
                    },
                    decoration: InputDecoration(
                        labelText: "Asal",
                        hintText: "Asal",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.blue.shade300),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: tglLahir,
                    validator: (val) {
                      return val!.isEmpty ? "Tidak boleh kosong" : null;
                    },
                    decoration: InputDecoration(
                        labelText: "Tanggal Lahir",
                        hintText: "Tanggal Lahir",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.blue.shade300),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    controller: valjK,
                    validator: (val) {
                      return val!.isEmpty ? "Tidak boleh kosong" : null;
                    },
                    decoration: InputDecoration(
                        labelText: "jenis kelamin",
                        hintText: "jenis kelamin",
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1, color: Colors.blue.shade300),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    onPressed: () {
                      if (keyForm.currentState?.validate() == true) {
                        registerAccount();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text("silahkan isi data terlebih dahulu")));
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

