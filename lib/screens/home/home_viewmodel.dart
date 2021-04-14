// ViewModel
import 'dart:convert';

import 'package:demostacked/model/eventslist_model.dart';
import 'package:demostacked/screens/home/notifyscreen/notifyview.dart';
import 'package:demostacked/services/all_service.dart';
import 'package:demostacked/services/local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:demostacked/ui/shared/globals.dart';
import 'package:quiver/collection.dart';
import 'package:demostacked/app/locator.dart';
import 'package:demostacked/app/logger.dart';
import 'package:demostacked/services/shared_perfernces_services.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeViewModel extends BaseViewModel {
  TextEditingController taskNameController = new TextEditingController();

  var today = DateTime.now();
  bool showListTasks = false;
  String dateTimeString = "";
  DateTime selectedDateTime;
  DateTime selectedDateTimeForCal;
  TextEditingController dateTextEditingController = new TextEditingController();
  //services objects
  LocalNotifications localNotifications = locator<LocalNotifications>();
  NavigationService navigationService = locator<NavigationService>();
  DialogService dialogService = locator<DialogService>();
  SnackbarService snackbarService = locator<SnackbarService>();
  AllServices allServices = locator<AllServices>();
  SharedPrefrenceService sharedPreferenceService =
      locator<SharedPrefrenceService>();

  bool cancelButtonTapped = false;

  int counter = 0;

  Future onSelectNotification(String payload) async {
    //when the notificaton is selected
    print(payload);
    ListEvents event = jsonDecode(payload);
    print(event);
  }

  //on the starting of the app
  onStartUp() {
    counter = sharedPreferenceService.notifyIdCount;
    print("this is counter value");
    print(counter);
    selectedDateTime = DateTime.now();
    selectedDateTimeForCal =
        new DateFormat("yyyy-MM-dd").parse(DateTime.now().toString());
    allServices.eventsMap = {};

    //notificatons part to setup for ios and android
    var initializationSettingsAndroid =
        AndroidInitializationSettings('flutter_devs');
    var initializationSettingsIOs = IOSInitializationSettings();
    var initSetttings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOs);

    //MAIN NOTIFICATIONS PART TO HANDLE THE NOTIFICATION
    localNotifications.flutterLocalNotificationsPlugin
        .initialize(initSetttings, onSelectNotification: onSelectNotification);
  }

  //on submit
  addToEventList(timeStamp, realTime) {
    counter = sharedPreferenceService.notifyIdCount;
    print("this is counter value");
    print(counter);
    notifyListeners();
    selectedDateTimeForCal = timeStamp;
    List<ListEvents> tempList = new List();

    //to check if the map contains the same date then add the current list data to the already made list in the map
    if (allServices.eventsMap.containsKey(timeStamp)) {
      tempList = allServices.eventsMap[timeStamp];
      tempList.add(ListEvents(
          dateTime: realTime,
          taskText: taskNameController.text,
          id: counter + 1));
      allServices.eventsMap[timeStamp] = tempList;
      sharedPreferenceService.notifyIdCount =
          sharedPreferenceService.notifyIdCount + 1;
    } else {
      //else make a new list and add that to the map
      tempList = [];
      tempList.add(ListEvents(
          dateTime: realTime,
          taskText: taskNameController.text,
          id: counter + 1));
      allServices.eventsMap[timeStamp] = tempList;
      sharedPreferenceService.notifyIdCount =
          sharedPreferenceService.notifyIdCount + 1;
    }
    showListTasks = !showListTasks;
    dateTextEditingController.clear();

    //to schedule the notificatons for the task events
    localNotifications.scheduleNotification(
      realTime,
      tempList,
      tempList.length - 1, //this will be the index of the event we are on
    );

    notifyListeners();
  }

  //for saving on the small calendar
  saveDateTime(val) {
    dateTimeString = val;
    notifyListeners();
  }

  //for hiding the list or showing the fields if FAB is pressed
  showOrHideTasks() {
    showListTasks = !showListTasks;
    notifyListeners();
  }

  //on Day selected in big clanedar
  changeListener(x, y, z) {
    //to convert the datetime to the date so that we can easily roll through the calendar
    selectedDateTimeForCal = new DateFormat("yyyy-MM-dd").parse(x.toString());

    print(selectedDateTimeForCal);
    print("length of my list");
    print(y.length);
    if (y.length == 0) {
      showListTasks = false;
    }

    selectedDateTime = x;
    dateTextEditingController.text = selectedDateTime.toString();
    notifyListeners();
  }

  onException() {
    snackbarService.showSnackbar(message: "Please Enter Valid Values");
  }

  //on a single event deleted or dissmissed
  onItemDissmissed(int index, List<ListEvents> itemList) async {
    await localNotifications.flutterLocalNotificationsPlugin
        .cancel(itemList[index].id);
    print("Canceling notificatons");
    print(itemList[index].dateTime);
    print(itemList[index].taskText);
    print(itemList[index].id);
    itemList.removeAt(index);
    snackbarService.showSnackbar(message: "Event Dissmissed");
    notifyListeners();
  }

  navigateToNotifyScreen(ListEvents event, int index) async {
    // var ok =
    await navigationService.navigateToView(NotifyView(
      listEventsItem: event,
      index: index,
    ));
    // if (ok == "done") {
    //   print("i am notifyLIsteners");
    //   notifyListeners();
    // }
  }

  //will cancel all the events and delete unused varialbes
  cancelAllEvents() async {
    var response = await dialogService.showConfirmationDialog(
      title: 'Cancel or Remove All ?',
      description: 'Are you sure you want to cancel all the events',
      confirmationTitle: 'Yes',
      dialogPlatform: DialogPlatform.Material,
      cancelTitle: 'No',
    );

    if (response.confirmed) {
      await localNotifications.flutterLocalNotificationsPlugin.cancelAll();
      snackbarService.showSnackbar(message: "All Events Were Canceled");
      //remove all  variables
      sharedPreferenceService.notifyIdCount = 0;
      counter = 0;

      allServices.eventsMap.clear();
    }
    notifyListeners();
  }
}
