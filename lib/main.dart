import 'package:app_budaya/screen/berita_page/listberita_screen.dart';
import 'package:app_budaya/screen/gallery_page/gallery_screen.dart';
import 'package:app_budaya/screen/login_screen.dart';
import 'package:app_budaya/screen/profil_page/profil_screen.dart';
import 'package:app_budaya/screen/sejarawan_page/listsejarawan_screen.dart';
import 'package:app_budaya/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budaya App',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {
        selectedIndex = tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        children: [
          ListBeritaScreen(),
          GalleryScreen(), 
          ListSejarawanScreen(),
          ProfilScreen(),
        ],
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
      ),
      bottomNavigationBar: WaterDropNavBar(
        backgroundColor: Color(0xff3EBFAA),
        waterDropColor: Colors.grey.shade100,
        onItemSelected: (index) {
          tabController.animateTo(index);
        },
        selectedIndex: selectedIndex,
        barItems: [
          BarItem(
            filledIcon: Icons.newspaper_rounded,
            outlinedIcon: Icons.newspaper_outlined,
          ),
          BarItem(
            filledIcon: Icons.browse_gallery_rounded,
            outlinedIcon: Icons.browse_gallery_outlined,
          ),
          BarItem(
            filledIcon: Icons.list_alt_rounded,
            outlinedIcon: Icons.list_alt_outlined,
          ),
          BarItem(
            filledIcon: Icons.person_search_rounded,
            outlinedIcon: Icons.person_search_outlined,
          ),
        ],
      ),
    );
  }
}

