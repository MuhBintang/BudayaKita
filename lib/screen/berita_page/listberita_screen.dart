import 'package:app_budaya/const.dart';
import 'package:app_budaya/model/berita/model_berita.dart';
import 'package:app_budaya/screen/berita_page/detailberita_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ListBeritaScreen extends StatefulWidget {
  const ListBeritaScreen({super.key});

  @override
  State<ListBeritaScreen> createState() => _ListBeritaScreenState();
}

class _ListBeritaScreenState extends State<ListBeritaScreen> {
  String? id, username;
  List<Datum>? _searchResult;
  List<Datum>? _beritaList;

  //fungsi untuk get data berita
  Future<List<Datum>?> getBerita() async {
    try {
      http.Response res = await http.get(
          Uri.parse('$url/berita.php'));
      return modelBeritaFromJson(res.body).data;
    } catch (e) {
      setState(() {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
      return null;
    }
  }

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      username = pref.getString("username") ?? '';
      print('id $id');
    });
  }

  @override
  void initState() {
    super.initState();
    getBerita();
    getSession();
  }

  void _searchBerita(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResult = null;
      });
      return;
    }

    setState(() {
      _searchResult = _beritaList
          ?.where((berita) =>
              berita.judul.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Card(
              elevation: 2, // Tinggi elevasi card
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Border radius card
              ),
              color: Color(0xFF3EBFAA), // Warna card
              child: SizedBox(
                width: 390,
                height: 188,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
                      child: Text(
                        'Welcome, ${username}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: TextField(
                        onChanged: _searchBerita,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Cari berita...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF3EBFAA)), // Memberikan warna pada border ketika dipencet
                            borderRadius: BorderRadius.circular(16),
                          ),
                          filled: true, // Mengisi bidang dengan warna
                          fillColor: Colors.white70, // Memberikan warna putih pada bidang
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 200, // Sesuaikan posisi Expanded sesuai kebutuhan
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder(
              future: getBerita(),
              builder: (BuildContext context, AsyncSnapshot<List<Datum>?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                if (snapshot.hasData) {
                  _beritaList = snapshot.data;
                  if (_searchResult != null && _searchResult!.isNotEmpty) {
                    return ListView.builder(
                      itemCount: _searchResult!.length,
                      itemBuilder: (context, index) {
                        Datum? data = _searchResult![index];
                        return buildBeritaCard(data);
                      },
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Datum? data = snapshot.data![index];
                        return buildBeritaCard(data);
                      },
                    );
                  }
                }
                return Container();
              },
            ),
          ),
        ),
      ],
    ),
  );
}
  Widget buildBeritaCard(Datum? data) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          //ketika item di klik pindah ke detail
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailBeritaScreen(data),
            ),
          );
        },
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    '$url/image/${data?.gambar}',
                    fit: BoxFit.contain,width: double.infinity,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  '${data?.judul}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: 
                Text(
                  '${data?.author},${data?.created}\n${data?.konten}',
                  maxLines: 2,
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
