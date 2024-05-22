import 'package:app_budaya/const.dart';
import 'package:app_budaya/model/sejarawan/modelDelete_sejarawan.dart';
import 'package:app_budaya/model/sejarawan/model_sejarawan.dart';
import 'package:app_budaya/screen/sejarawan_page/createsejarawan_screen.dart';
import 'package:app_budaya/screen/sejarawan_page/editsejarawan_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ListSejarawanScreen extends StatefulWidget {
  const ListSejarawanScreen({Key? key}) : super(key: key);

  @override
  State<ListSejarawanScreen> createState() => _ListSejarawanScreenState();
}

class _ListSejarawanScreenState extends State<ListSejarawanScreen> {
  TextEditingController txtcari = TextEditingController();
  bool isCari = false;
  bool isLoading = false;
  late List<Datum> _allSejarawan = [];
  late List<Datum> _searchResult = [];

  @override
  void initState() {
    getSejarawan();
    super.initState();
  }

  Future<List<Datum>?> getSejarawan() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res = await http.get(Uri.parse('$url/getSejarawan.php'));
      List<Datum> data = modelSejarawanFromJson(res.body).data ?? [];
      setState(() {
        _allSejarawan = data;
        _searchResult = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> deleteSejarawan(int id) async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.delete(Uri.parse('$url/delete_sejarawan.php?id_sejarawan=$id'));

      if (res.statusCode == 200) {
        ModelDeleteSejarawan data = modelDeleteSejarawanFromJson(res.body);

        if (data.value == 1) {
          setState(() {
            _searchResult.removeWhere((sejarawan) => sejarawan.idSejarawan == id.toString());
          });

          _filterBerita(txtcari.text);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${data.message}'),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${data.message}'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menghapus Sejarawan'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
        ),
      );
    }
  }

  void _filterBerita(String query) {
    List<Datum> filteredBerita = _allSejarawan
        .where((sejarawan) => sejarawan.nama!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _searchResult = filteredBerita;
    });
  }

  void _showSejarawanDetails(Datum sejarawan) {
  String formattedTglLahir = sejarawan.tglLahir;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(sejarawan.nama ?? ''),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network('$url/sejarawan/${sejarawan.foto}'),
              SizedBox(height: 10),
              Text('Nama: ${sejarawan.nama ?? ''}'),
              Text('Tanggal Lahir: $formattedTglLahir'),
              Text('Asal: ${sejarawan.asal ?? ''}'),
              Text('\n${sejarawan.deskripsi ?? ''}'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Tutup'),
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        backgroundColor: Color(0xff3EBFAA),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SejarawanCreateScreen()),
          );
        },
        tooltip: "Tambah Sejarawan",
        child: Icon(
          Icons.add,
          size: 25,
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              onChanged: _filterBerita,
              controller: txtcari,
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(Icons.search),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Color(0xff3EBFAA),
                hintText: "Search",
                hintStyle: TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.deepOrange.shade100,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.people,
                          size: 30,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("List Sejarawan"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: isLoading
                        ? Center(child: CircularProgressIndicator(color: Colors.green))
                        : ListView.builder(
                            itemCount: _searchResult.length,
                            itemBuilder: (context, index) {
                              Datum data = _searchResult[index];
                              return GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                  child: Card(
                                    child: ListTile(
                                      minLeadingWidth: 15,
                                      leading: Image.network('$url/sejarawan/${data?.foto}'),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            tooltip: "Hapus data",
                                            onPressed: () {
                                              int idToDelete = int.parse(_searchResult[index].idSejarawan);
                                              deleteSejarawan(idToDelete);
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                          ),
                                          IconButton(
                                            tooltip: "Edit data",
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          SejarawanEditScreen(data))
                                                          );
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.yellow.shade800,
                                              size: 20,
                                            ),
                                          ),
                                          IconButton(
                                            tooltip: "Lihat data",
                                            onPressed: () {
                                              _showSejarawanDetails(data);
                                            },
                                            icon: Icon(
                                              Icons.info_outline_rounded,
                                              color: Colors.green,
                                              size: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      title: Text("${data.nama}"),
                                      subtitle: Text("${data.asal}"),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
