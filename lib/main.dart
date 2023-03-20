

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo/shared/bloc_observe/observe.dart';
import 'package:todo/shared/cubit/cubit.dart';
import 'package:todo/shared/cubit/states.dart';
import 'package:todo/todo_app/todo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer =MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: buildThemeLightData(),
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
  ThemeData buildThemeLightData() {
    return ThemeData(
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            )),
        drawerTheme: const DrawerThemeData(backgroundColor: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
                iconSize: MaterialStateProperty.all(16),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                elevation: MaterialStateProperty.all(0),
                foregroundColor: MaterialStateProperty.all(Colors.black),
                textStyle: MaterialStateProperty.all(
                  GoogleFonts.cairo(
                    fontSize: 16,
                    color: Colors.white60,
                  ),
                ))),
        brightness: Brightness.light,
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.white,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          elevation: 2,
          foregroundColor: Colors.indigo,
        ),
        appBarTheme: AppBarTheme(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            elevation: 0,
            titleTextStyle: GoogleFonts.cairo(
              fontSize: 20,
              color: HexColor('000'),
            ),
            iconTheme: IconThemeData(
              color: HexColor('000'),
            )),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          elevation: 20,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.black,
          enableFeedback: false,
        ));
  }
}

