import 'dart:math';

import 'package:demostacked/model/eventslist_model.dart';
import 'package:demostacked/screens/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventListItem extends StatelessWidget {
  List<ListEvents> eventList;
  int i;

  EventListItem({
    this.eventList,
    this.i,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: generateRandomColor1().withOpacity(0.5),
      title: new Text(
        "${eventList[i].taskText}",
      ),
      subtitle: new Text(
          "${DateFormat.yMd().add_jm().format(eventList[i].dateTime)}"),
    );
  }

  Color generateRandomColor1() {
    // Define all colors you want here
    const predefinedColors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.pink,
    ];
    Random random = Random();
    return predefinedColors[random.nextInt(predefinedColors.length)];
  }
}
