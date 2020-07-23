import './order_details.dart';

class Bill {
  List<OrderDetails> orders;
  List<dynamic> bills;

  Bill({
    this.orders,
    this.bills,
  });

  Bill.fromMap(
    Map<dynamic, dynamic> map,
    int billId,
  ) {
    orders = [];
    for (var i = 0; i < map['orders'].length; i++) {
      orders.add(OrderDetails.mapToBill(map['orders'][i], billId));
    }
    this.bills = map['bills'];
  }
}
