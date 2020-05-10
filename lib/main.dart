import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasker/views/all_task.dart';
import 'package:tasker/views/tabs.dart';

const String isolateName = 'isolate';
const String countKey = 'count';

/// A port used to communicate from a background isolate to the UI isolate.
final ReceivePort port = ReceivePort();

SharedPreferences prefs;



Future<void> main() async { 
  WidgetsFlutterBinding.ensureInitialized();

  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName

  );
  prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey(countKey)) {
    await prefs.setInt(countKey, 0);
  }
  runApp(MyApp(
    port: port,
  ));
}

 


class MyApp extends StatelessWidget {
  const MyApp({
    this.port
  });
  final ReceivePort port;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
      ),
      home: AllTasks(
        port: port,
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, }) : super(key: key);


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Others'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
    );
  }
}
