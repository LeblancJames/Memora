import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memora/activity_details.dart';
// import 'package:memora/databases/database_service.dart';
import 'package:memora/models/activity_model.dart';
import 'package:memora/visited_page.dart';
import 'package:memora/wish_list.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void initDatabase() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}

void main() {
  initDatabase();
  WidgetsFlutterBinding.ensureInitialized();
  // buildDummy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memora',
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),

      initialRoute: '/',
      routes: {'/': (context) => const MyHomePage(title: 'Memora')},
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;
  final PageController pageController = PageController();

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  //swipe functionality
  void onPageChanged(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            color: Color(0xFF212121),
            letterSpacing: 0.5,
          ),
        ),
        toolbarHeight: 64,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged, //swipe functionality
        children: const [WishListPage(), VisitedPage()],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => ActivityDetails(
                      activity: Activity(
                        id: 0,
                        name: '',
                        location: '',
                        categoriesOne: [false, false, false, false, false],
                        categoriesTwo: [false, false, false, false, false],
                        notes: '',
                        rating: 0,
                        visited: false,
                        photoPaths: [],
                      ),
                    ),
              ),
            );
          },
          backgroundColor: const Color(0xFF4A90E2), // your primary blue
          shape: const CircleBorder(),
          tooltip: 'New Activity',
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: Stack(
        children: [
          BottomNavigationBar(
            backgroundColor: Color(0xFFFFFFFF),
            currentIndex: selectedIndex,
            onTap: onTabTapped,
            selectedItemColor: Color(0xFF4A90E2),
            unselectedItemColor: Color(0xFFBDBDBD),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.bookmark),
                label: 'Yet To Go',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.check),
                label: 'Visited',
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left:
                MediaQuery.of(context).size.width *
                (selectedIndex / 2), //positions bar based on index
            width: MediaQuery.of(context).size.width / 2,
            height: 5,
            child: Container(color: Color(0xFF4A90E2)),
          ),
        ],
      ),
    );
  }
}
