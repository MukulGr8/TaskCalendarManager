import 'package:date_time_picker/date_time_picker.dart';
import 'package:demostacked/screens/home/home_viewmodel.dart';
import 'package:demostacked/services/permission_services.dart';
import 'package:demostacked/ui/shared/css_colors.dart';
import 'package:demostacked/ui/shared/ui_helpers.dart';
import 'package:demostacked/ui/widgets/dumb_widgets/EventListItem.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeView extends StatelessWidget {
  final CalendarController calendarController = new CalendarController();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      onModelReady: (model) => model.onStartUp(),
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(
          child: Container(
            child: new ListView(
              children: [
                SizedBox(height: 30.0),

                //table calendar
                TableCalendar(
                  calendarController: calendarController,
                  events: model.allServices.eventsMap,
                  onDaySelected: (x, y, z) {
                    model.changeListener(x, y, z);
                  },
                ),

                verticalSpaceSmall,

                GestureDetector(
                  onTap: () {
                    model.cancelAllEvents();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: new Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Center(
                            child: new Text(
                          "Cancel All Events",
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w800),
                        )),
                      ),
                    ),
                  ),
                ),

                verticalSpaceSmall,

                AnimatedCrossFade(
                  duration: const Duration(seconds: 1),
                  firstChild: buildFields(model),
                  secondChild: buildListViewForTasks(model),
                  crossFadeState: model.showListTasks
                      ? CrossFadeState.showFirst
                      : CrossFadeState.showSecond,
                ),

                verticalSpaceMedium,

                //go
              ],
            ),
          ),
        ),
        floatingActionButton: new FloatingActionButton.extended(
            label: !model.showListTasks
                ? new Text("Add Task")
                : new Text("Show Tasks"),
            backgroundColor: const Color(0xff03dac6),
            foregroundColor: Colors.black,
            onPressed: () {
              model.showOrHideTasks();
            }),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }

  buildListViewForTasks(HomeViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => verticalSpaceSmall,
          shrinkWrap: true,
          itemCount: model?.allServices?.eventsMap[model.selectedDateTimeForCal]
                  ?.length ??
              0,
          itemBuilder: (context, i) {
            return GestureDetector(
              onTap: () {
                //to navigat to the route
                model.navigateToNotifyScreen(
                    model?.allServices?.eventsMap[model.selectedDateTimeForCal]
                        [i],
                    i);
              },
              child: Dismissible(
                // Show a red background as the item is swiped away.
                background: Container(color: Colors.red),
                key: Key(model?.allServices
                    ?.eventsMap[model.selectedDateTimeForCal][i].dateTime
                    .toString()),
                onDismissed: (direction) {
                  model.onItemDissmissed(
                      i,
                      model?.allServices
                          ?.eventsMap[model.selectedDateTimeForCal]);
                },
                child: EventListItem(
                  i: i,
                  eventList: model
                      ?.allServices?.eventsMap[model.selectedDateTimeForCal],
                ),
              ),
            );
          }),
    );
  }

  buildFields(HomeViewModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 5.0, color: Colors.blueAccent)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            children: [
              SizedBox(height: 30.0),
              new Text("Task Detail",
                  style: new TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 30.0),

              //Task name
              new TextField(
                decoration: InputDecoration(
                  hintText: "Enter Task Here",
                ),
                controller: model.taskNameController,
              ),

              //date time picker
              DateTimePicker(
                type: DateTimePickerType.dateTimeSeparate,
                dateMask: 'd MMM, yyyy',
                use24HourFormat: false,
                controller: model.dateTextEditingController,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
                dateLabelText: 'Date',
                timeLabelText: "Hour",
                onSaved: (val) {
                  model.saveDateTime(val);
                },
                onChanged: (val) {
                  model.saveDateTime(val);
                },
              ),

              SizedBox(height: 40.0),

              //submit button
              Center(
                child: new FlatButton(
                    color: Colors.blueAccent,
                    onPressed: () {
                      try {
                        DateTime dateTimeTemp =
                            DateTime.parse(model.dateTimeString);
                        DateTime tempDateOnly = new DateFormat("yyyy-MM-dd")
                            .parse(model.dateTimeString);
                        model.addToEventList(tempDateOnly,
                            dateTimeTemp); //sending the temp datetime and the date only
                      } on Exception catch (_) {
                        model.onException();
                      }
                    },
                    child: new Text(
                      "Submit",
                      style: new TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
