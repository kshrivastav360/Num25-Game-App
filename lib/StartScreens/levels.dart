import 'dart:convert';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberproj/DrawerScrn.dart';
import 'package:numberproj/GameScreens/scr1.dart';
import 'package:numberproj/GameScreens/scr1a.dart';
import 'package:numberproj/GameScreens/scr4.dart';
import 'package:numberproj/StartScreens/loginscr.dart';
import 'package:numberproj/GameScreens/scr2.dart';
import 'package:http/http.dart' as http;
import 'package:numberproj/GameScreens/scr2a.dart';
import 'package:numberproj/GameScreens/scr4a.dart';
import 'package:numberproj/provider/placepro.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Levels extends ConsumerStatefulWidget {
  const Levels({super.key});

  @override
  ConsumerState<Levels> createState() => _LevelsState();
}

class _LevelsState extends ConsumerState<Levels> {
  final numclikplayer = AudioPlayer();
  late List allScore = [];
  late String username;
  late int score;
  late int counter;
  late List filterLvl = [];

  Future<void> numclikSound() async {
    String audioPath = "audio/numclick.mp3";
    await numclikplayer.play(AssetSource(audioPath));
  }

  Future<void> displayLeaderBoard() async {
    numclikSound();
    print("token$token");
    final url = Uri.parse('http://77.37.44.61:8086/mpuzzle2/leader/allscore');
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          allScore = json.decode(response.body);

          filterLvl =
              allScore.where((element) => element['level'] == 5).toList();
        });
        if (filterLvl.any((element) => element['score'] >= 25)) {
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                HomeScreen4a(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 3.0);
              const end = Offset.zero;
              const curve = Curves.decelerate;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ));
        } else {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              actions: [
                Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        image: DecorationImage(
                            image: AssetImage("assets/images/cloud.png"),
                            fit: BoxFit.cover)),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 30, top: 30, left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "To Unlock This Level \nYou Must Score More than 25 😎....\n in 5th Level",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 202, 3, 3),
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Card(
                                  shadowColor: Colors.black,
                                  elevation: 5,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "Got It!! 😉",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ))
              ],
              backgroundColor: Colors.transparent,
            ),
          );
        }

        print(allScore.length);
      }
    } catch (error) {
      print("Error while Getting Score Data!!");
    }
  }
   Future<void> displayLeaderBoardA() async {
    numclikSound();
    print("token$token");
    final url = Uri.parse('http://77.37.44.61:8086/mpuzzle2/leader/allscore');
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          allScore = json.decode(response.body);

          filterLvl =
              allScore.where((element) => element['level'] == 4).toList();
        });
        if (filterLvl.any((element) => element['score'] >= 20)) {
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                HomeScreen4(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 3.0);
              const end = Offset.zero;
              const curve = Curves.decelerate;
              var tween =
                  Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 500),
          ));
        } else {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              actions: [
                Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        image: DecorationImage(
                            image: AssetImage("assets/images/cloud.png"),
                            fit: BoxFit.cover)),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 30, top: 30, left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "To Unlock This Level \nYou Must Score More than 20 😎....\n in 4th Level",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color.fromARGB(255, 202, 3, 3),
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Card(
                                  shadowColor: Colors.black,
                                  elevation: 5,
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "Got It!! 😉",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                          )
                        ],
                      ),
                    ))
              ],
              backgroundColor: Colors.transparent,
            ),
          );
        }

        print(allScore.length);
      }
    } catch (error) {
      print("Error while Getting Score Data!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    var userObj = ref.watch(userProvider);
    double scrHeight = MediaQuery.of(context).size.height;
    double scrWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        drawer: Drawer(
          child: DrawerScrn(username: userObj.uName),
        ),
        body: GestureDetector(
          onHorizontalDragUpdate: (details) {
            if (details.delta.dx > 20) {
              Scaffold.of(context).openDrawer();
            }
          },
          child: FittedBox(
            child: Container(
              height: scrHeight,
              width: scrWidth,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/levelBgImage.png"),
                      fit: BoxFit.fill)),
              child: Stack(
                children: [
                  Positioned(
                      top: scrHeight * 0.89,
                      left: scrWidth * 0.8,
                      child: CircleAvatar(
                        backgroundColor: 
                            const Color.fromARGB(255, 202, 240, 234),
                        radius: 70,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 50, bottom: 40),
                          child: IconButton(
                              color: const Color.fromARGB(255, 78, 123, 185),
                              iconSize: 30,
                              highlightColor:
                                  const Color.fromARGB(255, 242, 60, 60),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          title: const Text(
                                              "Do you want to Log Out?"),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () async {
                                                  var pref =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  pref.setBool(
                                                      "LoggedIn", false);
                                                  Navigator.of(context)
                                                      .pushAndRemoveUntil(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const LoginScr(),
                                                    ),
                                                    (route) => false,
                                                  );
                                                },
                                                child: const Text("Yes"))
                                          ],
                                        ));
                              },
                              icon: const Icon(Icons.logout)),
                        ),
                      )),
                  Positioned(
                    //Leevel1
                    top: -10,
                    left: 10,
                    child: InkWell(
                      onTap: () {
                        numclikSound();
                        Navigator.of(context).push(PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const HomeScreen1(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 3.0);
                            const end = Offset.zero;
                            const curve = Curves.decelerate;
                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            var offsetAnimation = animation.drive(tween);
                            return SlideTransition(
                                position: offsetAnimation, child: child);
                          },
                          transitionDuration: const Duration(milliseconds: 500),
                        ));
                      },
                      child: const Image(
                        image: AssetImage("assets/images/Level_1.png"),
                        height: 200,
                      ),
                    ),
                  ),
                  Positioned(
                      //Leevel2
                      top: 60,
                      left: 170,
                      child: InkWell(
                          onTap: () {
                            numclikSound();
                            Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      const HomeScreen1a(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 3.0);
                                const end = Offset.zero;
                                const curve = Curves.decelerate;
                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                    position: offsetAnimation, child: child);
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                            ));
                          },
                          child: const Image(
                            image: AssetImage("assets/images/lvl2.png"),
                            height: 200,
                          ))),
                  Positioned(
                      //Leevel3
                      top: 140,
                      left: 10,
                      child: InkWell(
                          onTap: () {
                            numclikSound();
                            Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      HomeScreen2(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 3.0);
                                const end = Offset.zero;
                                const curve = Curves.decelerate;
                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                    position: offsetAnimation, child: child);
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                            ));
                          },
                          child: const Image(
                            image: AssetImage("assets/images/lvl3.png"),
                            height: 200,
                          ))),
                  Positioned(
                      //Leevel4
                      top: 220,
                      left: 170,
                      child: InkWell(
                          onTap: () {
                            numclikSound();
                            Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      HomeScreen2a(),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 3.0);
                                const end = Offset.zero;
                                const curve = Curves.decelerate;
                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);
                                return SlideTransition(
                                    position: offsetAnimation, child: child);
                              },
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                            ));
                          },
                          child: const Image(
                            image: AssetImage("assets/images/lvl4.png"),
                            height: 200,
                          ))),
                  Positioned(
                      //Leevel5
                      top: 320,
                      left: 0,
                      child: InkWell(
                          highlightColor: Colors.amber,
                          onTap: () {
                            displayLeaderBoardA();
                          },
                          child: const Image(
                            image: AssetImage("assets/images/lvl5.png"),
                            height: 200,
                          ))),
                  Positioned(
                      //Leevel6
                      top: 420,
                      left: 170,
                      child: InkWell(
                          onTap: () {
                            displayLeaderBoard();
                          },
                          child: const Image(
                            image: AssetImage("assets/images/lvl6.png"),
                            height: 200,
                          ))),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
