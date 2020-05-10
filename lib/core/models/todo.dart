class TodoTask {

  TodoTask(
    this._title,
    this._scheduledTime,
    this._category,
    this._priority,
    this._timeToStartAlarm,
    this._isDone,
    this._uploadedTime
  );

  TodoTask.withId(
    this._id,
    this._title,
    this._scheduledTime,
    this._category,
    this._priority,
    this._timeToStartAlarm,
    this._isDone,
    this._uploadedTime
  );

  TodoTask.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _scheduledTime = map['scheduledTime'];
    _category = map['category'];
    _priority = map['priority'];
    _timeToStartAlarm = map['timeToStartAlarm'];
    _isDone = map['isDone'];
    _uploadedTime = map['uploadedTime'];
  }

  int get id => _id;
  String get title => _title;
  String get scheduledTime => _scheduledTime;
  String get category => _category;
  int get priority => _priority;
  String get timeToStartAlarm => _timeToStartAlarm;
  int get isDone => _isDone;
  String get uploadedTime => _uploadedTime;

  set id(int id) {
    _id = id;
  }

  set title(String newTitle) {
    _title = newTitle;
  }

  set scheduledTime(String newScheduledTime) {
    _scheduledTime = newScheduledTime;
  }

  set category(String newCategory) {
    _category = newCategory;
  }

  set priority(int newPriority) {
    _priority = newPriority;
  }

  set timeToStartAlarm(String newTimeToStart) {
    _timeToStartAlarm = newTimeToStart;
  }

  set isDone(int newBool) {
    _isDone = newBool;
  }

  set uploadedTime(String newUploadedTime) {
    _uploadedTime = newUploadedTime;
  }


  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};

    map['title'] = _title;
    map['scheduledTime'] = _scheduledTime;
    map['category'] = _category;
    map['priority'] = _priority;
    map['timeToStartAlarm'] = _timeToStartAlarm;
    map['isDone'] = _isDone;
    map['uploadedTime'] = _uploadedTime;

    if(id != null) 
      map['id'] = _id;

    return map;
  }

 




  int _id;
  String _title;
  String _scheduledTime;
  String _category;
  int _priority;
  String _timeToStartAlarm;
  int _isDone;
  String _uploadedTime;


}