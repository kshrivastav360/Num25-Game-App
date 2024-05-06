import 'package:flutter/material.dart';
import 'package:numberproj/StartScreens/loginscr.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class DrawerScrn extends StatelessWidget {
  DrawerScrn({super.key,this.username});
  late String? username;

  @override
  Widget build(BuildContext context) {
    
    print(username);
    double scrHeight = MediaQuery.of(context).size.height;
   // double scrWidth = MediaQuery.of(context).size.width;
    print(username);
    return Drawer(
      width: 250,
        child: Container(
          height: scrHeight,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/cloud.png"), fit: BoxFit.cover)),
          child: ListView(
            children: [
              Column(
                children: [
                  ClipOval(child: Image.asset("assets/images/pandalogo.png",height: 150,)),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Text(username.toString(),style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                  ),
                  const Divider(
                    color: Color.fromARGB(255, 0, 0, 0),thickness: 2,
                  )
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text("Do you want to Log Out?"),
                              actions: [
                                ElevatedButton(
                                    onPressed: () async {
                                      var pref =
                                          await SharedPreferences.getInstance();
                                      pref.setBool("LoggedIn", false);
                                      Navigator.of(context)
                                          .pushAndRemoveUntil(MaterialPageRoute(
                                        builder: (context) =>  const LoginScr(),
                                      ),
                                      (route) => false,
                                      );
                                    },
                                    child: const Text("Yes"))
                              ],
                            ));
                  },
                  leading: const Icon(
                    Icons.logout,
                    size: 25,
                    color: Colors.black,
                    weight: 30.00,
                  ),
                  title: const Text(
                    "LogOut",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(255, 0, 0, 0)),
                  ))
            ],
          ),
        ),
      );
  }
}