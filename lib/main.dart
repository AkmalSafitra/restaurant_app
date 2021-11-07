import 'dart:io';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurantapp/provider/database_provider.dart';
import 'package:restaurantapp/provider/preference_provider.dart';
import 'package:restaurantapp/provider/restaurant_provider.dart';
import 'package:restaurantapp/provider/scheduling_provider.dart';
import 'package:restaurantapp/ui/bookmarks_page.dart';
import 'package:restaurantapp/ui/restaurant_detail_page.dart';
import 'package:restaurantapp/ui/restaurant_search_page.dart';
import 'package:restaurantapp/ui/splash_screen.dart';
import 'package:restaurantapp/common/styles.dart';
import 'package:restaurantapp/common/text_theme.dart';
import 'package:restaurantapp/utils/background_service.dart';
import 'package:restaurantapp/utils/notification_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/api/api_service.dart';
import 'data/db/database_helper.dart';
import 'data/preferences/preferences_helper.dart';
import 'ui/home_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();

  _service.initializeIsolate();

  if(Platform.isAndroid){
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotifications(flutterLocalNotificationsPlugin);

  runApp(MyApp());
}

class MyApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // force platform target because android studio arctic fox version doesnt support toggle platform in Flutter inspector
    // debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    debugDefaultTargetPlatformOverride = TargetPlatform.android;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RestaurantProvider(apiService: ApiService()),
        ),

        ChangeNotifierProvider(create: (_) => SchedulingProvider()),

        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => DatabaseProvider(databaseHelper: DatabaseHelper()),
        ),
      ],
      child: Consumer<PreferencesProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            theme: ThemeData(
              primaryColor: primaryColor,
              accentColor: secondaryColor,

              textTheme: myTextTheme,
              appBarTheme: AppBarTheme(
                textTheme: myTextTheme.apply(bodyColor: Colors.black),
                elevation: 0,
              ),

              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  primary: secondaryColor,
                  textStyle: TextStyle(),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(0),
                    ),
                  ),
                )
              ),

              primarySwatch: Colors.red,
              visualDensity: VisualDensity.adaptivePlatformDensity,

              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                selectedItemColor: secondaryColor,
                unselectedItemColor: Colors.grey,
              ),
            ),
            initialRoute: SplashScreen.routeName,
            routes:{
              SplashScreen.routeName: (context) => SplashScreen(),
              HomePage.routeName: (context) => HomePage(),
              RestaurantDetailPage.routeName:(context) => RestaurantDetailPage(id: ModalRoute.of(context)?.settings.arguments as String),
              RestaurantSearchPage.routeName:(context) => RestaurantSearchPage(),
              BookmarksPage.routeName:(context) => BookmarksPage(),
            },
          );
        },
      ),
    );
  }
}

