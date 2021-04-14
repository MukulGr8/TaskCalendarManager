import 'package:demostacked/model/eventslist_model.dart';
import 'package:demostacked/screens/home/home_viewmodel.dart';
import 'package:demostacked/screens/home/notifyscreen/notify_viewmodel.dart';
import 'package:demostacked/ui/shared/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class NotifyView extends StatelessWidget {
  ListEvents listEventsItem;
  int index;
  NotifyView({this.listEventsItem, this.index});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotifyViewModel>.reactive(
      onModelReady: (model) => model.onStartUp(listEventsItem),
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        body: new Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: new ListView(
              children: [
                verticalSpaceMassive,
                //list tile for showing the list view for the notifications
                new ListTile(
                  tileColor: Colors.redAccent.withOpacity(0.6),
                  title: new Text("${listEventsItem.taskText}"),
                  subtitle: new Text("${listEventsItem.dateTime}"),
                ),

                verticalSpaceMedium,

                //showing buttons for the accept and dissmiss
                verticalSpaceLarge,

                //build fields
                buildFields(model, index, listEventsItem),
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => NotifyViewModel(),
    );
  }

  buildFields(NotifyViewModel model, int index, ListEvents listEventsItem) {
    return new Column(
      children: [
        verticalSpaceMedium,
        //task text in the field
        new TextField(
          decoration: new InputDecoration(
            hintText: "Enter Task Here",
          ),
          controller: model.taskTextEditingController,
        ),

        verticalSpaceMedium,

        new FlatButton(
          color: Colors.red,
          onPressed: () async {
            await model.onItemEdited(index, listEventsItem);
            // model.navigationService.back(result: "done");
          },
          child: new Text("Done", style: new TextStyle(color: Colors.white)),
        ),

        verticalSpaceLarge,
      ],
    );
  }
}
