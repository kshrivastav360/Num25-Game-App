import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:numberproj/StartScreens/loginscr.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SignScr extends StatelessWidget {
  SignScr({super.key});

  var txtname = TextEditingController();
  var txtphone = TextEditingController();
  var txtpin = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //registering user using api
    Future<void> registeruser() async {
      final url = Uri.parse("http://77.37.44.61:8086/mpuzzle2/user/register");
      try {
        final response = await http.post(url,
            body: jsonEncode({
              "mobileNumber": txtphone.text,
              "username": txtname.text,
              "pin": txtpin.text,
              "roles": "USER"
            }),
            headers: {'Content-Type': 'application/json'});
        if (response.statusCode == 200) {
          Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const LoginScr(),
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
        print(error);
      }
    }

    double scrHeight = MediaQuery.of(context).size.height;
    // double scrWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: 1000,
        height: 5000,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/cloud.png"),
                fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
                  child: Image.asset(
                    "assets/images/pandalogo.png",
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      controller: txtname,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        labelText: 'NAME',
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
                      controller: txtphone,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
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
                      controller: txtpin,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(25),
                          ),
                        ),
                        labelText: 'PIN',
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      registeruser();
                    },
                    child: const Text("SUBMIT"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
