import 'package:flutter/material.dart';
import 'package:mapsminhasviagensapp/screens/splash_screen.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF0066CC),
      ),
      title: "Minhas Viagens",
      home: SplashScreen(),
    ));
