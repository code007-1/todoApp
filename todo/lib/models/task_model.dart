class Task {
  int id;
  String title;
  String description;
  DateTime date;
  String priority;
  int status; //0 - incomplete, 1 - Complete
  bool notifyMe; //0 - no, 1 -yes
  bool alarm; //0 - no, 1 - yes

  Task(
      {this.title,
      this.description,
      this.date,
      this.priority,
      this.status,
      this.notifyMe,
      this.alarm});
  Task.withId(
      {this.id,
      this.title,
      this.description,
      this.date,
      this.priority,
      this.status,
      this.notifyMe,
      this.alarm});
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['description'] = description;
    map['date'] = date.toIso8601String();
    map['priority'] = priority;
    map['status'] = status;
    map['notifyMe'] = notifyMe;
    map['alarm'] = 'alarm';
    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        date: DateTime.parse(map['date']),
        priority: map['priority'],
        status: map['status'],
        notifyMe: map['notifyMe'],
        alarm: map['alarm']);
  }
}
