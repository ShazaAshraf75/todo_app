// ignore_for_file: prefer_const_constructors

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/layout/home_layout.dart';

import 'cubit/bloc_observer.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      runApp(MyApp());  
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColorLight: Colors.deepOrangeAccent[200],
          colorScheme: ThemeData()
              .colorScheme
              .copyWith(primary: Colors.deepOrange[200])),
      home: HomeLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
