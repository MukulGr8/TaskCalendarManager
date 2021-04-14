import 'dart:convert';

import 'package:demostacked/model/eventslist_model.dart';
import 'package:demostacked/ui/widgets/dumb_widgets/EventListItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class LocalNotifications {
  //local notificatons object
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //seceduled notfications
  Future<void> scheduleNotification(DateTime realTime,
      List<ListEvents> eventList, int indexOfTempList) async {
    //making a payload for the notifications to send it further when navigating on screens
    ListEventsTemp eve = ListEventsTemp(
        dateTime: realTime.toString(),
        taskText: eventList[indexOfTempList].taskText,
        id: eventList[indexOfTempList].id);
    String eventListModal = jsonEncode(eve.toJson());

    print("Schdeuling notificatons");
    print(realTime);
    print(eventList[indexOfTempList].taskText);
    print(eventList[indexOfTempList].id);
    var scheduledNotificationDateTime = realTime;
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      icon: 'flutter_devs',
      largeIcon: DrawableResourceAndroidBitmap('flutter_devs'),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        eventList[indexOfTempList].id,
        'Notify for Tasks',
        '${eventList[indexOfTempList].taskText}',
        scheduledNotificationDateTime,
        platformChannelSpecifics,
        payload: eventListModal);
  }
}
