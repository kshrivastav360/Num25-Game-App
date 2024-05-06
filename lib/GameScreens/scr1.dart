import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:numberproj/DrawerScrn.dart';
import 'package:numberproj/StartScreens/loginscr.dart';
import 'package:numberproj/provider/placepro.dart';
import 'package:numberproj/ResultScreens/result.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class HomeScreen1 extends ConsumerStatefulWidget {
  const HomeScreen1({super.key});
  // late String? name;
  // late String? phNo;
  @override
  ConsumerState<HomeScreen1> createState() => _HomeScreen1State();
}

class _HomeScreen1State extends ConsumerState<HomeScreen1> {
  final startplayer = AudioPlayer();
  final overplayer = AudioPlayer();
  final numclikplayer = AudioPlayer();
  final winningplayer = AudioPlayer();
  final lossplayer = AudioPlayer();

  List<bool> buttonClicked = List.generate(25, (index) => false);
  bool tf = false;
  int count = 25;
  int time = 0;
  int counter = 25;
  late Timer _timer;
  int score = 0;
  int numcheck = 1;
  int onclick = 0;
  bool isStarted = true;
  int level = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //chechTokenExpiry();
  }

  Future<void> updateScore(int scr, int time) async {
    var prefs = await SharedPreferences.getInstance();
    late String? phNo;
    phNo = prefs.getString("mobileNumber");

    print("number: $phNo");
    print("time : $time, phone num$phNo,  score$scr");
    final url = Uri.parse(
        'http://77.37.44.61:8086/mpuzzle2/leader/update/$phNo/$scr/$time/${1}');
    print("time : $time, $level");
    try {
      final response = await http.patch(url,
          body: jsonEncode({
            "mobileNumber": phNo,
            "score": scr,
            "time": time,
            "level": 1
          }),
          headers: {
            "Content-Type": "application/json",
            'Authorization': 'Bearer $token',
          });
      print("time : $time, $level");
      print(response.statusCode);
      if (response.statusCode == 200) {
        Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Marks(
                mark: scr,
                phno: phNo.toString(),
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 3.0);
                const end = Offset.zero;
                const curve = Curves.decelerate;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                var offsetAnimation = animation.drive(tween);
                return SlideTransition(position: offsetAnimation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 500),
            ));
        _timer.cancel();
      } else {
        var prefs = await SharedPreferences.getInstance();
        prefs.setBool('LoggedIn', false);
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LoginScr(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);
            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ));
      }
    } catch (error) {
      print("error while Patching Data:$error");
    }
  }
  // Future<void> chechTokenExpiry() async {
  //   print("token$token");
  //   final url = Uri.parse('http://77.37.44.61:8086/mpuzzle2/user/${widget.phNo}');
  //   try {
  //     final response = await http.get(url, headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     });
  //     print(response.statusCode);
  //     if (response.statusCode != 200) {
  //       var prefs = await SharedPreferences.getInstance();
  //       prefs.setBool('LoggedIn', false);
  //       Navigator.of(context).pushReplacement(MaterialPageRoute(
  //           builder: (context) => const LoginScr()));

  //     }
  //   } catch (error) {
  //     print("Error while Getting Score Data!!");
  //   }
  // }

  void startwatch() {
    counter = 25;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (counter > 0) {
        setState(() {
          counter--;
          time++;
        });
      } else {
        startplayer.stop();
        _timer.cancel();
        overSound();
        setState(() {
          // score = 0;
          tf = false;
          numbers.shuffle();
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              actions: [
                Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        image: DecorationImage(
                            image: AssetImage("assets/images/cloud.png"),
                            fit: BoxFit.cover)),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 30, top: 15, left: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Center(
                            child: Text(
                              "Time over!😔",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                if (score <= 20) {
                                  startplayer.stop();
                                  lossSound();
                                  updateScore(score, time);
                                  _timer.cancel();
                                } else {
                                  winningSound();
                                  updateScore(score, time);
                                  _timer.cancel();
                                }
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) => Marks(mark: score, phno: widget.phNo.toString(),),
                                //     ));
                              },
                              child: const Card(
                                shadowColor: Colors.black,
                                elevation: 5,
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Score",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ))
              ],
              backgroundColor: Colors.transparent,
            ),
          );
        });
      }
    });
  }

  final numbers = <int>[
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25
  ];

  void resetButtonColors() {
    setState(() {
      buttonClicked = List.generate(25, (index) => false);
    });
  }

  Future<void> startSound() async {
    String audioPath = "audio/mainMusic.mp3";
    await startplayer.play(AssetSource(audioPath));
  }

  Future<void> overSound() async {
    String audioPath = "audio/abe-yaar-58907.mp3";
    await overplayer.play(AssetSource(audioPath));
  }

  Future<void> numclikSound() async {
    String audioPath = "audio/numclick.mp3";
    await numclikplayer.play(AssetSource(audioPath));
  }

  Future<void> winningSound() async {
    String audioPath = "audio/winninSound (1).mp3";
    await numclikplayer.play(AssetSource(audioPath));
  }

  Future<void> lossSound() async {
    String audioPath = "audio/lossSound.mp3";
    await numclikplayer.play(AssetSource(audioPath));
  }

  @override
  Widget build(BuildContext context) {
    var userObj = ref.watch(userProvider);
    
    double scrHeight = MediaQuery.of(context).size.height;
    double scrWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: DrawerScrn(
        username:userObj.uName,
      ),
      appBar: AppBar(
        title: const Text(
          "Level 1",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
              color: Color.fromARGB(255, 41, 180, 69)),
        ),

        // backgroundColor: Colors.tra,
        // flexibleSpace: const Image(image: AssetImage("assets/images/homescreen2.png"),fit: BoxFit.cover,),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromARGB(249, 39, 126, 225),
              Color.fromRGBO(4, 8, 104, 1)
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                updateScore(score, time);
              },
              icon: const Icon(
                AntDesign.trophy_fill,
                color: Color.fromARGB(255, 0, 0, 0),
                size: 25,
              ))
        ],
      ),
      body: Container(
        width: 1000,
        height: 5000,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/homescreen2.png"),
                fit: BoxFit.fill)),
        child: Column(children: [
          Padding(
            padding: EdgeInsets.only(top: scrHeight * 0.14),
            child: Container(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 237, 255, 97),
                  borderRadius: BorderRadius.all(Radius.circular(11))),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Timer: $counter',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    //backgroundColor: Colors.amber
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: SizedBox(
              width: scrWidth,
              height: scrHeight * 0.48,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: count,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, mainAxisSpacing: 7, crossAxisSpacing: 7),
                itemBuilder: (context, count) {
                  return Container(
                    decoration: const BoxDecoration(shape: BoxShape.rectangle),
                    child: InkWell(
                      onTap: buttonClicked[count]
                          ? null
                          : () {
                              numclikSound();
                              onclick = numbers[count];
                              if (onclick == numcheck) {
                                setState(() {
                                  buttonClicked[count] = true;
                                });
                                numcheck++;
                                score++;
                                if (onclick == 25) {
                                  if (score <= 20) {
                                    startplayer.stop();
                                    lossSound();
                                    updateScore(score, time);
                                    _timer.cancel();
                                  } else {
                                    startplayer.stop();
                                    winningSound();
                                    updateScore(score, time);
                                    
                                    _timer.cancel();
                                  }
                                }
                              } else {
                                {
                                  overSound();
                                  startplayer.stop();
                                  setState(() {
                                    tf = false;
                                    numbers.shuffle();
                                  });
                                  _timer.cancel();
                                  counter = 25;

                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      actions: [
                                        Container(
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30)),
                                                image: DecorationImage(
                                                    image: AssetImage(
                                                        "assets/images/cloud.png"),
                                                    fit: BoxFit.cover)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15, right: 30, left: 30),
                                              child: Column(
                                                children: [
                                                  const Text(
                                                    "Incorrect Sequence Try Again!!😔",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  TextButton(
                                                      onPressed: () {
                                                        if (score <= 20) {
                                                          startplayer.stop();
                                                          lossSound();
                                                          updateScore(
                                                              score, time);
                                                          _timer.cancel();
                                                          time = 0;
                                                        } else {
                                                          winningSound();
                                                          updateScore(
                                                              score, time);
                                                          _timer.cancel();
                                                          time = 0;
                                                        }
                                                      },
                                                      child: const Card(
                                                        shadowColor:
                                                            Colors.black,
                                                        elevation: 5,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child: Text(
                                                            "Score",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ))
                                                ],
                                              ),
                                            ))
                                      ],
                                      backgroundColor: Colors.transparent,
                                    ),
                                  );
                                }
                              }
                            },
                      child: Card(
                        elevation: 5,
                        color: buttonClicked[count]
                            ? const Color.fromARGB(255, 14, 113, 34)
                            : const Color.fromARGB(255, 41, 180, 69),
                        child: tf
                            ? Center(
                                child: Text(
                                  numbers[count].toString(),
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize:
                                        15, //screen size >395 "14"////screen size <395 "11"
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // const SizedBox(
          //   height: 10,
          // ),
          Padding(
            padding: EdgeInsets.only(left: scrWidth * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      numclikSound();
                      overplayer.stop();
                      startplayer.stop();
                      setState(() {
                        resetButtonColors();
                        isStarted = true;
                        numcheck = 1;
                        score = 0;       
                        tf = false;
                        numbers.shuffle();
                      });
                      _timer.cancel();
                      counter = 25;
                      time = 0;
                    },
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Color.fromARGB(255, 233, 202, 81))),
                    child: const Text(
                      "Reset",
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    )),
                const SizedBox(
                  width: 7,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        backgroundColor:
                            const Color.fromARGB(255, 154, 129, 123)),
                    //  const ButtonStyle(
                    //     backgroundColor: MaterialStatePropertyAll(
                    //         Color.fromARGB(255, 183, 109, 232))),
                    onPressed: isStarted
                        ? () {
                            numclikSound();
                            startSound();
                            setState(() {
                              isStarted = false;
                              startwatch();
                              tf = true;
                              numbers.shuffle();
                            });
                          }
                        : null,
                    child: const Text(
                      "Start",
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    )),
                const SizedBox(
                  width: 7,
                ),
              
              ],
            ),
          ),
        ]),
      ),
    );
  }
  @override
  void dispose() {
    // Dispose AudioPlayer instances
    startplayer.dispose();
    overplayer.dispose();
    numclikplayer.dispose();
    winningplayer.dispose();
    lossplayer.dispose();

    // Cancel timer
    _timer.cancel();

    super.dispose();
  }
}
