class ListEvents {
  int id;
  DateTime dateTime;
  String taskText;

  ListEvents({this.dateTime, this.taskText, this.id});
}

class ListEventsTemp {
  int id;
  String dateTime;
  String taskText;

  ListEventsTemp({this.dateTime, this.taskText, this.id});

  ListEventsTemp.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        dateTime = json['dateTime'],
        taskText = json['taskText'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'dateTime': dateTime,
        'taskText': taskText,
      };
}
