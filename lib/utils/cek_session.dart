import 'package:shared_preferences/shared_preferences.dart';

class SessionManager{
  int? value;
  String? idUser, userName, nama, nohp, alamat, email;

  Future<void> saveSession(int val, String id, String userName, String nama, String nohp, String alamat, String email) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("value", val);
    pref.setString("id_user", id);
    pref.setString("username", userName);
    pref.setString("nama", nama);
    pref.setString("nohp", nohp);
    pref.setString("alamat", alamat);
    pref.setString("email", email);
  }

  Future getSession() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getInt("value");
    pref.getString("id_user");
    pref.getString("username");
    pref.getString("nama");
    pref.getString("nohp");
    pref.getString("alamat");
    pref.getString("email");
    return value;
  }

  Future getSesiIdUser() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getString("id_user");
    return idUser;
  }

  //clear session --> logout
  Future clearSession() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}

SessionManager session = SessionManager();