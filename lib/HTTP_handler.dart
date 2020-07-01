import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './credentials.dart';
import './providers/product_provider.dart';
import './models/user.dart';
import './models/product.dart';
import './models/product_details.dart';
import './models/order.dart';
import './models/bill.dart';
import './models/category.dart';
import './models/cart.dart';

class HTTPHandler {
  User currentUser = User();
  Dio _dio = Dio();
  List<Product> productList = [];
  String baseURL = 'https://developers.thegraphe.com/flexy';

  Future<List<String>> getMobiles() async {
    try {
      List<String> mobiles = [];
      Response response = await _dio.get(getMobilesUrl);

      for (var i = 0; i < response.data.length; i++)
        mobiles.add(response.data[i]['mobile']);

      return mobiles;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<String> registerUser(User user) async {
    print(user.photoLocation);
    print(user.visitingCardLocation);
    try {
      FormData formData = FormData.fromMap({
        'category': 1,
        'name': user.name,
        'mobileNo': user.mobileNo,
        'email': user.email,
        'designation': user.designation,
        'photoIdType': user.photoIdType,
        'photoLocation': user.photoLocation,
        'visitingCardLocation': user.visitingCardLocation,
        'photo_id': await MultipartFile.fromFile(user.photoLocation,
            filename: '${user.photoIdType}-${user.id}'),
        'visiting_card': await MultipartFile.fromFile(user.visitingCardLocation,
            filename: 'VisitingCard-${user.id}'),
        'firmName': user.firmName,
        'firmNomenclature': user.firmNomenclature,
        'tradeCategory': user.tradeCategory,
        'noOfStores': user.noOfStores,
        'landlineNo': user.landlineNo,
        'gstNo': user.gstNo,
        'companyAddress': user.companyAddress,
        'city': user.city,
        'state': user.state,
        'pincode': user.pincode,
        'agentName': user.agentName,
        'purchasePerson': user.purchasePerson,
        'password': user.password,
      });

      Response response = await _dio.post(
        registerUrl,
        data: formData,
      );

      print(response.statusCode);
      if (response.data['status']
          .contains('success')) if (response.data['user']['api_token'] != null)
        return response.data['user']['api_token'];
      else
        return null;
      else
        return null;
    } catch (e) {
      return null;
    }
  }

  Future<User> loginUser(String email, String password) async {
    User user = User();
    try {
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
    } catch (e) {
      throw e;
    }
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
    print(int.parse(mobileNo));

    Response response = await _dio.post(
      sendOTPUrl,
      data: formData,
    );

    print(response.data);

    if (json.decode(response.data)['type'].contains('success')) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> verifyOTP(String mobileNo, String otp) async {
    print(mobileNo + ' => ' + otp);
    Response response =
        await _dio.post('$verifyOTPUrl&mobile=$mobileNo&otp=$otp');

    print(response);

    if (json.decode(response.data)['type'].contains('success')) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Category>> getCategoriesList(String token) async {
    Response response = await _dio.get('$baseURL/categories?api_token=$token');

    List<Category> categories = [];
    for (var i = 0; i < (response.data).length; i++)
      categories.add(Category.frommap((response.data)[i]));

    print(categories);
    return categories;
  }

  Future<List<Product>> getProductsList(
      BuildContext context, String token, String categoryId) async {
    productList.clear();
    Response response =
        await _dio.get('$baseURL/prodpercategory/$categoryId?api_token=$token');

    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);

    print(response.data);
    for (var i = 0; i < (response.data).length; i++) {
      Product product = Product();
      product.mapToProduct((response.data)[i]);
      productList.add(product);
    }

    productProvider.clear();
    productProvider.addItem(productList);
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

  Future<bool> addToCart(
    String token,
    String productId,
    String size,
    int qty,
    String color,
  ) async {
    FormData formData = FormData.fromMap({
      'size': size,
      'quantity': qty,
      'color': color,
    });

    Response response = await _dio.post(
      '$baseURL/addtocart/$productId?api_token=$token',
      data: formData,
    );

    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<bool> removeFromCart(
      String token,
      String id,
      ) async {
    Response response = await _dio.get(
      '$baseURL/remcartitem/$id?api_token=$token',
    );
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<bool> updateProfile(
      String token,
      String noOfStores,
      String city,
      String state
      ) async {
    FormData formData = FormData.fromMap({
      'noOfStores': noOfStores,
      'city': city,
      'state': state,
    });

    Response response = await _dio.post(
      '$baseURL/updateuser?api_token=$token',
      data: formData,
    );

    if (response.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<List<Cart>> getCartItems(String token) async {
    List<Cart> cartItems = [];

    Response response = await _dio.get('$baseURL/viewcart?api_token=$token');

    for (var i = 0; i < (response.data).length; i++)
      cartItems.add(Cart.fromMap((response.data)[i]));

    print(cartItems);
    return cartItems;
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

  Future<List<Bill>> getBills(String token, String orderId) async {
    List<Bill> bills = [];
    Response response = await _dio.get('$billUrl/$orderId?api_token=$token');

    //print(response.data);
    for (var i = 0; i < response.data['bills'].length; i++)
      bills.add(Bill.mapToBill(response.data['bills'][i]));
    print(bills.toString());
    return bills;
  }

  Future<int> requestPwdChangeOTP(String mobileNo) async {
    FormData formData = FormData.fromMap({
      'mobileNo': mobileNo,
    });

    Response response = await _dio.post(
      forgetPwdOTP,
      data: formData,
    );

    print((response.data)['uid']);

    if ((response.data).containsKey('uid')) {
      return (response.data)['uid'];
    } else {
      return null;
    }
  }

  Future<bool> changePassword(int uid, String password) async {
    FormData formData = FormData.fromMap({
      'password': password,
    });

    Response response = await _dio.post(
      '$changePwdUrl?id=$uid',
      data: formData,
    );

    print(response.data);

    if ((response.data)['status'].contains('success')) {
      return true;
    } else {
      return false;
    }
  }
}
