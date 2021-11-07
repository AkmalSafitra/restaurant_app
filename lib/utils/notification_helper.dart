
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:restaurantapp/common/navigation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurantapp/data/model/restaurant.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper{
  static NotificationHelper? _instance;

  NotificationHelper._internal(){
    _instance = this;
  }

  late int randomRestaurantIndex;

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async{
    var inititalizationSettingsAndroid = AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: inititalizationSettingsAndroid, iOS: initializationSettingsIOS
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {

          if(payload != null){
            print('notification payload: ' + payload);
          }
          selectNotificationSubject.add(payload ?? 'empty payload');

        });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin, RestaurantResult resturants
      ) async {

    var _channelId = "1";
    var _channelName = "channel_01";
    var _channelDescription = "dicoding news channel";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _channelId, _channelName, _channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: DefaultStyleInformation(true, true)
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics
    );

    randomRestaurantIndex = Random().nextInt(resturants.restaurants.length - 1);
    var titleNotification = "<b>Discover Top Restaurant</b>";
    var titleRestaurant = resturants.restaurants[randomRestaurantIndex].name;

    await flutterLocalNotificationsPlugin.show(0, titleNotification, titleRestaurant, platformChannelSpecifics,
        payload: json.encode((resturants.toJson())));
  }

  void configureSelectNotificationSubject(String route, BuildContext context){
    selectNotificationSubject.stream.listen((String payload) async {
      var data = RestaurantResult.fromJson(json.decode(payload));
      Navigator.pushNamed(context, route, arguments: data.restaurants[randomRestaurantIndex].id);
    });
  }

}