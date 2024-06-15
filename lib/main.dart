import 'package:flutter/material.dart';
import 'package:uday_interview/utlis/app_colors.dart';
import 'package:uday_interview/view/filter_screen.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Uday flutter practical",
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.whiteColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.blackColor,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 15, color: AppColors.whiteColor),
        ),
      ),
      home: const FilterScreen(),
    );
  }
}
