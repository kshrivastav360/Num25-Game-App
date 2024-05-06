import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberproj/StartScreens/levels.dart';
import 'package:numberproj/provider/placepro.dart';
import 'package:numberproj/StartScreens/signup.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

String token = '';

class LoginScr extends ConsumerStatefulWidget {
  const LoginScr({super.key});

  @override
  ConsumerState<LoginScr> createState() => _LoginScrState();
}

class _LoginScrState extends ConsumerState<LoginScr> {
  bool isLoggedIn = false;
  var txtname = TextEditingController();
  var txtphone = TextEditingController();
  var txtpin = TextEditingController();
  Map<String, dynamic>? loginData;
  late String username;
  late String phno;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> loginuser() async {
    print("hello");
    final url = Uri.parse("http://77.37.44.61:8086/mpuzzle2/user/login");
    try {
      final response = await http.post(
        url,
        body: jsonEncode({"mobileNumber": txtphone.text, "pin": txtpin.text}),
        headers: {'Content-Type': 'application/json'},
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          loginData = json.decode(response.body);
        });
        logIn();
      } else {
        // Registration failed, handle error

        print('Failed to register user: ${response.statusCode}');
      }
    } catch (error) {
      print(error);
    }
  }

  void logIn() async {
    var prefs = await SharedPreferences.getInstance();
    print("login()");
    if (loginData == null) {}
    if (loginData != null) {
      final bool status = loginData!["success"];
      // final String message = loginData!["message"];
      setState(() {
        username = loginData!["username"];
        phno = loginData!["mobileNumber"];
      });

      prefs.setString('userName', username);
      prefs.setString('mobileNumber', phno);

      ref.read(userProvider.notifier).addUser(username);

      token = loginData!["token"];
      print(status);
      print("${username}1");
      if (status == true) {
        prefs.setBool('LoggedIn', true);

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Levels(
              // name: username,
              //  phNo: txtphone.text,
              ),
        ));
      }
    }
  }

  Future<void> _checkLoginStatus() async {
    print("loginStatus");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setBool('LoggedIn', false);
    bool isLoggedIn = prefs.getBool('LoggedIn') ?? false;
    //  final String username = loginData!["username"];
    //final String username = loginData!["username"];
    if (isLoggedIn) {
      String? userName = prefs.getString('userName');
      // User is logged in, navigate to the Dashboard screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Levels(
            // name: userName,
            // phNo: txtphone.text,
            ),
      ));
    }
  }

  void _showErrorMessage() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 254, 245, 220),
            title: const Text(
              'Log-In Failure',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
            ),
            content: const Text(
              'Please Enter Valid Credentials to LogIn',
              style: TextStyle(
                  fontSize: 17.0, color: Color.fromARGB(255, 0, 0, 0)),
            ),
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 240, 180, 180)),
                onPressed: () {
                  Navigator.pop(context);
                  logIn();
                },
                child: const Text(
                  'Retry',
                  style: TextStyle(
                      fontSize: 20.0, color: Color.fromARGB(255, 3, 3, 3)),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    double scrHeight = MediaQuery.of(context).size.height;
    double scrWidth = MediaQuery.of(context).size.width;
    return ProviderScope(
      child: Scaffold(
        body: Container(
          height: scrHeight,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/cloud.png"),
                  fit: BoxFit.fill)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: scrHeight * 0.10),
                  child: const Text(
                    "Welcome to NUM 25",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(),
                  child: (Lottie.asset('assets/zadupanda.json')
                      //fit: BoxFit.cover,
                      ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: txtphone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        labelText: 'PHONE NUMBER',
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: txtpin,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        labelText: 'PIN',
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "New User? ",
                    ),
                    SizedBox(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => SignScr(),
                              ));
                            },
                            child: const Text(
                              "signup",
                              style: TextStyle(
                                  decoration: TextDecoration.underline),
                            )),
                      ),
                    )
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      if (txtphone.text.isEmpty && txtpin.text.isEmpty) {
                        _showErrorMessage();
                      } else {
                        loginuser();
                      }
                    },
                    child: const Text("LOGIN"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
