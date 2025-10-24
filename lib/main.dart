import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(home: HomePage()));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E1E),
      appBar: AppBar(
        toolbarHeight: 130,
        backgroundColor: Color(0xFF1E1E1E),
        title: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Olá, Murilo!",
            style: TextStyle(
              color: Color(0xFFE0E0E0),
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: body(),
    );
  }
}

 Widget body(){
  return Column(
    children: [
      Container(
        child: Column(

        ),
      )
    ],

  );
 }