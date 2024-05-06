import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';
import 'package:numberproj/StartScreens/levels.dart';
import 'package:numberproj/StartScreens/loginscr.dart';

class Marks6 extends StatefulWidget {
  const Marks6({super.key, required this.mark});
  final int mark;

  @override
  State<Marks6> createState() => _Marks6State();
}

class _Marks6State extends State<Marks6> {
  final numclikplayer = AudioPlayer();
  late List allScore = [];
  late List allScoreTime = [];
  // late Map<String, dynamic> player;
  late String username;
  late int score;
  late int counter;
  late List filterLvl = [];
  @override
  void initState() {
    super.initState();
    displayLeaderBoard();
  }

  Future<void> displayLeaderBoard() async {
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
          allScore.sort(
            (a, b) => a['time'].compareTo(b['time']),
          );
          allScoreTime = List.from(allScore);
          allScoreTime.sort(
            (a, b) => b['score'].compareTo(a['score']),
          );
          filterLvl = allScoreTime.where((element) => element['level'] == 6).toList();

        });

        print(allScore.length);
      }
    } catch (error) {
      print("Error while Getting Score Data!!");
    }
  }

  Future<void> numclikSound() async {
    String audioPath = "audio/numclick.mp3";
    await numclikplayer.play(AssetSource(audioPath));
  }

  @override
  Widget build(BuildContext context) {
    double scrHeight = MediaQuery.of(context).size.height;
    double scrWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 216, 142),
      body: Container(
        height: scrHeight,
        width: scrWidth,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/result2.png"),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            Positioned(
              top: scrHeight * 0.15,
              left: scrWidth * 0.47,
              child: Column(
                children: [
                  const Text(
                    "Level: 6",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Color.fromARGB(255, 16, 237, 5)),
                  ),
                  Text(
                    "Score: ${widget.mark}",
                    style: const TextStyle(
                        fontSize: 25,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: scrHeight * 0.4, left: scrWidth * 0.12),
              child: SizedBox(
                height: scrHeight * 0.51,
                width: scrWidth * 0.73,
                child: ListView.builder(
                  itemCount: filterLvl.length,
                  itemBuilder: (context, index) {
                    username = filterLvl[index]["username"] ?? '';
                    print(username);
                    score = filterLvl[index]["score"] ?? '';
                    print(score);
                    counter = filterLvl[index]["time"] ?? '';
                    print(counter);
                    return SizedBox(
                      height: scrHeight * 0.07,
                      child: Card(
                        shadowColor: const Color.fromARGB(255, 0, 0, 0),
                        elevation: 15,
                        color: const Color.fromARGB(255, 147, 255, 93),
                        // const Color.fromARGB(255, 172, 225, 235),
                        child: Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(249, 39, 126, 225),
                                    Color.fromRGBO(4, 8, 104, 1)
                                  ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 0),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [const Icon(Icons.person,color: Color.fromARGB(255, 147, 255, 93),size: 17,),
                                          Text(
                                            username,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row( mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            score.toString(),
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          const Icon(Icons.sports_score_sharp,color: Color.fromARGB(255, 147, 255, 93),size: 12,)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row( mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            counter.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Icon(Icons.av_timer_sharp,color: Color.fromARGB(255, 147, 255, 93),size: 12,)
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: scrHeight * 0.923, left: 130),
              child: NeoPopTiltedButton(
                isFloating: true,
                onTapUp: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const Levels(
                      )));
                },
                onTapDown: numclikSound,
                decoration: const NeoPopTiltedButtonDecoration(
                  color: Color.fromARGB(255, 148, 74, 47),
                  plunkColor: Color.fromARGB(255, 203, 185, 178),
                  shadowColor: Color.fromRGBO(36, 36, 36, 1),
                  showShimmer: true,
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 5,
                  ),
                  child: Text(
                    'Next Level',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color.fromARGB(255, 147, 255, 93)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
