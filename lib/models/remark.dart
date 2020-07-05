class Remark {
  int id;
  int userId;
  String userName;
  int productId;
  String productName;
  String remarks;

  Remark({
    this.id,
    this.userId,
    this.userName,
    this.productId,
    this.productName,
    this.remarks,
  });

  Remark.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.userId = int.parse(map['user_id']);
    this.userName = map['user_name'];
    this.productId = int.parse(map['prod_id']);
    this.productName = map['prod_name'];
    this.remarks = map['remarks'];
  }
}
