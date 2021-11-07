import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurantapp/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {

  PreferencesHelper preferencesHelper;

  PreferencesProvider({required this.preferencesHelper}){
    // _getTheme();
    _getDailyRestaurantPreferences();
  }

  // bool _isDarkTheme = false;
  // bool get isDarkTheme => _isDarkTheme;
  //
  // void _getTheme() async {
  //   _isDarkTheme = await preferencesHelper.isDarkTheme;
  //   notifyListeners();
  // }
  //
  // void enableDarkTheme(bool value) {
  //   preferencesHelper.setDarkTheme(value);
  //   _getTheme();
  // }
  //
  // ThemeData get themeData => _isDarkTheme ? darkTheme : lightTheme;

  bool _isDailyRestaurantActive = false;
  bool get isDailyRestaurantActive => _isDailyRestaurantActive;

  void _getDailyRestaurantPreferences() async {
    _isDailyRestaurantActive = await preferencesHelper.isDailyRestaurantActive;
    notifyListeners();
  }

  void enableDailyRestaurant(bool value) {
    preferencesHelper.setDailyRestaurant(value);
    _getDailyRestaurantPreferences();
  }



}