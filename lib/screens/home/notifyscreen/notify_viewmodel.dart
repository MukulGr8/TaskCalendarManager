import 'package:date_time_picker/date_time_picker.dart';
import 'package:demostacked/app/locator.dart';
import 'package:demostacked/model/eventslist_model.dart';
import 'package:demostacked/services/all_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NotifyViewModel extends BaseViewModel {
  TextEditingController taskTextEditingController = new TextEditingController();
  SnackbarService snackbarService = locator<SnackbarService>();
  AllServices allServices = locator<AllServices>();
  NavigationService navigationService = locator<NavigationService>();

  onItemEdited(int index, ListEvents listEventsItem) {
    listEventsItem.taskText = taskTextEditingController.text;
    // DateTime temp = new DateFormat("yyyy-MM-dd").parse(listEventsItem.dateTime.toString());
    snackbarService.showSnackbar(message: "Editing fields");
    notifyListeners();
  }

  onStartUp(ListEvents listEventsItem) {
    taskTextEditingController.text = listEventsItem.taskText;
    notifyListeners();
  }
}
