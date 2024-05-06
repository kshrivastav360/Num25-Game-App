import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberproj/StartScreens/splashscr.dart';
//import 'package:flutter/services.dart';

void main() {
  runApp(
        const ProviderScope(
          child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: LottieSplashScreen(),
              ),
        ),
  );
}
