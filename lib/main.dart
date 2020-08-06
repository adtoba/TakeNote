import 'dart:ui';
import 'package:TakeNote/views/splash_screen.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:TakeNote/views/all_task.dart';


void main() { 
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
   @override
  Widget build(BuildContext context) {
    return DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (Brightness brightness) 
        => ThemeData(
          brightness: brightness,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme.apply(
              bodyColor: brightness == Brightness.dark ? Colors.white : Colors.black,
              displayColor: brightness == Brightness.dark ? Colors.white : Colors.black
            )
          ),
          primarySwatch: Colors.blue,
          iconTheme: IconThemeData(
            color: brightness == Brightness.dark 
              ? Colors.white 
              : Colors.black
          ),          
        ),
      themedWidgetBuilder: (BuildContext context, ThemeData theme) {
        return  MaterialApp(
          title: 'TakeNote',
          theme: theme,
          home: SplashScreen()
        );
      }
      
    );
  }
}

