class Task {
  Task(
    this._title,
    this._description,
    this._dateTime,
    this._priority
  );

  Task.withId(
    this._id,
    this._title,
    this._description,
    this._dateTime,
    this._priority
  );

  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get dateTime => _dateTime;
  int get priority => _priority;

  set title(String newTitle) {
    _title = newTitle;
  }

  set description(String newDescription) {
    _description = newDescription;
  }

  set dateTime(String newDateTime) {
    this._dateTime = newDateTime;
  }

  set priority(int newPriority) {
    _priority = newPriority;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['title'] = _title;
    map['description'] = _description;
    map['dateTime'] = _dateTime;
    map['priority'] = _priority;
    if(_id != null) map['id'] = _id;

    return map;
  }

  Task.fromMap(Map<String, dynamic> map, [String idString]) {
    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _dateTime = map['dateTime'];
    _priority = map['priority'];
  }



  int _id;
  String _title;
  String _description;
  String _dateTime;
  int _priority;
  

}