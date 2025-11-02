
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../firebase_options.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      body: body()
      );
  }
  body(){
    return Center(
      child: Text("Home"),
    );
  }
}

