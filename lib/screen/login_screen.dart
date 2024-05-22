import 'package:app_budaya/const.dart';
import 'package:app_budaya/main.dart';
import 'package:app_budaya/model/user/model_login.dart';
import 'package:app_budaya/screen/berita_page/listberita_screen.dart';
import 'package:app_budaya/screen/register_screen.dart';
import 'package:app_budaya/screen/splash_screen.dart';
import 'package:app_budaya/utils/cek_session.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  //key untuk form
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  //fungsi untuk post data
  bool isLoading = false;
  Future<ModelLogin?> loginAccount() async {
    try {
      setState(() {
        isLoading = true;
      });

      http.Response res = await http.post(Uri.parse('$url/login.php'), body: {
        "username": txtUsername.text,
        "password": txtPassword.text,
      });
      ModelLogin data = modelLoginFromJson(res.body);
      //cek kondisi (ini berdasarkan value respon api
      //value ,1 (ada data login),dan 0 (gagal)
      if (data.value == 1) {
        setState(() {
          //save session
          session.saveSession(
              data.value ?? 0, data.idUser ?? "", data.username ?? "", data.nama ?? "", data.nohp ?? "", data.alamat ?? "", data.email ?? "");

          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));

          //pindah ke page berita
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavigationPage()),
              (route) => false);
        });
      } else {
        setState(() {
          isLoading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${data.message}')));
        });
      }
    } catch (e) {
      //munculkan error
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Form(
            key: keyForm,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Memindahkan teks ke sebelah kiri
                  children: [
                    Image.asset(
                      "images/BudayaKita.png",
                      width: 231,
                      height: 57,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Text(' Buat Akun Anda', 
                    // style: TextStyle(
                    // fontSize: 18, fontWeight: FontWeight.bold),
                    // ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: txtUsername,
                      validator: (val) {
                        return val!.isEmpty ? "Tidak Boleh Kosong" : null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 34,
                    ),
                    TextFormField(
                      controller: txtPassword,
                      obscureText: true,
                      validator: (val) {
                        return val!.isEmpty ? "Tidak Boleh Kosong" : null;
                      },
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: 
                      // MaterialButton(
                      //   onPressed: () {
                      //     //cek kondisi dan get data inputan
                      //     if (keyForm.currentState?.validate() == true) {
                      //       //kita panggil function login
                      //       loginAccount();
                      //     }
                      //   },
                      //   color: Colors.orange,
                      //   textColor: Colors.white,
                      //   height: 45,
                      //   child: Text('Login'),
                      // ),
                        MaterialButton(onPressed: (){
                          if (keyForm.currentState?.validate() == true) {
                            //kita panggil function login
                            loginAccount();
                          }
                        },
                        padding: EdgeInsets.symmetric(horizontal: 170, vertical: 15),
                        color: Color(0xff705FAA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13)
                        ),
                        child: Text('Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xffF2F2F2)
                          ),
                        ),
                      ), 
                    ),
                    SizedBox(height: 25,),
                    Text('---------------------------------------------- or ----------------------------------------------',
                      style: TextStyle(
                        color: Colors.black
                      ),
                    ),
                    SizedBox(height: 25,),
                    MaterialButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
                    },
                    padding: EdgeInsets.symmetric(horizontal: 167, vertical: 15),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13), 
                          side: BorderSide(color: Colors.black)
                        ),
                        child: Text('Sign In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.black
                          ),
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
