class Notification {
  int id;
  String title;
  String message;
  String date;

  Notification({
    this.id,
    this.title,
    this.message,
    this.date,
  });

  Notification.fromJson(Map<dynamic, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.message = map['message'];
    this.date = map['date'];
  }
}
