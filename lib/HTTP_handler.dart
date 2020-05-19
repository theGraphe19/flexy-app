import 'dart:convert';

import 'package:dio/dio.dart';

import './credentials.dart';
import './models/user.dart';
import './models/product.dart';
import './models/product_details.dart';
import './models/order.dart';

class HTTPHandler {
  User currentUser = User();
  Dio _dio = Dio();
  List<Product> productList = [];

  Future<User> loginUser(String email, String password) async {
    User user = User();
    FormData formData = FormData.fromMap({
      'email': email,
      'password': password,
    });

    Response response = await _dio.post(
      loginUrl,
      data: formData,
    );

    print(response.data['status']);
    if (response.data['status'].contains('success')) {
      user.mapToUser(response.data['user']);
      currentUser = user;
    }

    return user;
  }

  Future<bool> logOut(String token) async {
    Response response = await _dio.get(logOutUrl + token);

    print(response.data);
    if (response.data['status'].contains('success')) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendOTP(String mobileNo) async {
    FormData formData = FormData.fromMap({
      'mobileNo': int.parse(mobileNo),
    });

    Response response = await _dio.post(
      sendOTPUrl,
      data: formData,
    );

    if (json.decode(response.data)['type'].contains('success')) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> verifyOTP(String mobileNo, String otp) async {
    Response response =
        await _dio.post('$verifyOTPUrl&mobile=$mobileNo&otp=$otp');

    if (json.decode(response.data)['type'].contains('success')) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Product>> getProductsList(String token) async {
    productList.clear();
    Response response = await _dio.get(getProductsListUrl + token);

    print(response.data);
    for (var i = 0; i < response.data['products'].length; i++) {
      Product product = Product();
      product.mapToProduct(response.data['products'][i]);
      productList.add(product);
    }
    return productList;
  }

  Future<ProductDetails> getProductDetails(int productId, String token) async {
    ProductDetails details = ProductDetails();
    Response response =
        await _dio.get(getProductDetailsUrl + '$productId?api_token=$token');

    details.mapToProductDetails(response.data);

    return details;
  }

  Future<Map> placeOrder(
    int productId,
    String token,
    List<Map<String, dynamic>> ordersList,
  ) async {
    Map<String, dynamic> orderData = {};
    for (var i = 0; i < ordersList.length; i++) {
      orderData['orders[$i][size]'] = ordersList[i]['size'];
      orderData['orders[$i][quantity]'] = ordersList[i]['quantity'];
    }
    print(orderData);
    FormData formData = FormData.fromMap(orderData);

    Response response = await _dio.post(
      '$placeorderUrl/$productId?api_token=$token',
      data: formData,
    );

    return response.data;
  }

  Future<bool> addRemarks(
    int productId,
    String token,
    String remarks,
  ) async {
    FormData formData = FormData.fromMap({
      'remarks': remarks,
    });

    Response response = await _dio.post(
      '$addRemarkUrl/$productId?api_token=$token',
      data: formData,
    );

    if (response.data['remarks'].isNotEmpty)
      return true;
    else
      return false;
  }

  Future<List<Order>> getMyOrders(String token) async {
    List<Order> orderedItems = [];
    Response response = await _dio.get(getMyOrdersUrl + token);

    for (var i = 0; i < response.data.length; i++) {
      Order order = Order();
      order.mapToOrder(response.data[i]);
      orderedItems.add(order);
    }

    return orderedItems;
  }
}
