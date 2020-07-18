class Chat {
  int id;
  int userid;
  String userName;
  int adminId;
  String adminName;
  String message;
  DateTime timeStamp;

  Chat({
    this.id,
    this.userid,
    this.userName,
    this.adminId,
    this.adminName,
    this.message,
    this.timeStamp,
  });

  Chat.fromMap(Map<dynamic, dynamic> map) {
    this.id = map['id'];
    this.userid = int.parse(map['user_id']);
    this.userName = map['user_name'];
    this.adminId = int.parse(map['admin_id']);
    this.adminName = map['admin'];
    this.message = map['message'];
    this.timeStamp = DateTime.parse(map['created_at']);
  }
}
