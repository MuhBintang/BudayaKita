import 'package:app_budaya/const.dart';
import 'package:app_budaya/main.dart';
import 'package:app_budaya/model/user/model_edit.dart';
import 'package:app_budaya/utils/cek_session.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfilEditScreen extends StatefulWidget {
  const ProfilEditScreen({super.key});

  @override
  State<ProfilEditScreen> createState() => _ProfilEditScreenState();
}

class _ProfilEditScreenState extends State<ProfilEditScreen> {
  final TextEditingController _idUserController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _nohpController = TextEditingController();
  String? id, username, email, alamat, nohp, nama;

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  bool isLoading = false;

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id_user") ?? '';
      username = pref.getString("username") ?? '';
      nama = pref.getString("nama") ?? '';
      email = pref.getString("email") ?? '';
      alamat = pref.getString("alamat") ?? '';
      nohp = pref.getString("nohp") ?? '';
    });
  }

  Future<void> editUser() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res = await http.post(Uri.parse('${url}/edit_user.php'), body: {
        "id_user": _idUserController.text, // Ambil nilai teks dari TextEditingController
        "username": _usernameController.text,
        "email": _emailController.text,
        "nohp": _nohpController.text,
        "alamat": _alamatController.text,
        "nama": _namaController.text
      });
      print(res.body); // Print server response for debugging
      ModelEditUser data = modelEditUserFromJson(res.body);
      if (data.value == 1) {
        setState(() {
          isLoading = false;
          session.saveSession(
              data.value ?? 0,
              data.idUser ?? "",
              data.username ?? "",
              data.email ?? "",
              data.alamat ?? "",
              data.nohp ?? "",
              data.nama ?? "");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNavigationPage()),
            (route) => false);
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xff3EBFAA),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: keyForm,
            child: Column(
              children: [
                // Stack for profile picture and edit icon
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.person_2_rounded, color: Colors.black),
                        onPressed: () {
                          // Logic to change profile picture
                          // This might include showing a dialog or navigating to a new screen
                        },
                      ),
                    ),
                  ],
                ),

                // Space between profile picture and user information
                SizedBox(height: 24.0),

                // Username Edit Form
                TextFormField(
                  controller: _idUserController,
                  decoration: InputDecoration(
                    labelText: 'ID User',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _namaController,
                  decoration: InputDecoration(
                    labelText: 'Nama',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _alamatController,
                  decoration: InputDecoration(
                    labelText: 'Alamat',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nohpController,
                  decoration: InputDecoration(
                    labelText: 'Nomor Handphone',
                    border: OutlineInputBorder(),
                  ),
                ),

                // Space between user information and buttons
                SizedBox(height: 16.0),
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onPressed: () {
                    if (keyForm.currentState?.validate() == true) {
                      editUser();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Silahkan isi data terlebih dahulu")));
                    }
                  },
                  color: Color(0xff3EBFAA),
                  textColor: Colors.white,
                  height: 45,
                  child: const Text("Edit"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
