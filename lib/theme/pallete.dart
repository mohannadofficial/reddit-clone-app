import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reddit_app/core/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pallete {
  // Colors
  static const blackColor = Color.fromRGBO(1, 1, 1, 1); // primary color
  static const greyColor = Color.fromRGBO(26, 39, 45, 1); // secondary color
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Colors.white;
  static var redColor = Colors.red.shade500;
  static var blueColor = Colors.blue.shade300;

  // Themes
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: blackColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: drawerColor,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: drawerColor,
    ),
    primaryColor: redColor,
    backgroundColor:
        drawerColor, // will be used as alternative background color
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: whiteColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: blackColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    primaryColor: redColor,
    backgroundColor: whiteColor,
  );
}

class ThemeModeCubit extends Cubit<ThemeData> {
  ThemeModes _mods;
  ThemeModeCubit({ThemeModes modes = ThemeModes.dark})
      : _mods = modes,
        super(Pallete.darkModeAppTheme);

  ThemeModes get mode => _mods;

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme');
    if (theme == 'light') {
      _mods = ThemeModes.light;
      emit(Pallete.lightModeAppTheme);
    } else {
      _mods = ThemeModes.dark;
      emit(Pallete.darkModeAppTheme);
    }
  }

  void toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_mods == ThemeModes.light) {
      _mods = ThemeModes.light;
      prefs.setString('theme', 'dark');
      emit(Pallete.lightModeAppTheme);
    } else {
      _mods = ThemeModes.dark;
      prefs.setString('theme', 'light');
      emit(Pallete.darkModeAppTheme);
    }
  }
}
