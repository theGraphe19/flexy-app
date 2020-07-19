import './cart.dart';

class CartOverView {
  int id;
  List<Cart> cartItems;

  CartOverView({
    this.id,
    this.cartItems,
  });

  CartOverView.fromMap(int id, List<dynamic> list) {
    this.id = id;
    cartItems = [];
    for (var i = 0; i < list.length; i++) cartItems.add(Cart.fromMap(list[i]));
  }
}
