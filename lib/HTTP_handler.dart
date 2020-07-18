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
import './models/order_details.dart';

class HTTPHandler {
  Dio _dio = Dio();
  List<Product> productList = [];
  String baseURL = 'https://developers.thegraphe.com/flexy';

  Future<List<String>> getMobiles() async {
    try {
      List<String> mobiles = [];
      Response response = await _dio.get("$baseURL/getmobiles");

      for (var i = 0; i < response.data.length; i++)
        mobiles.add(response.data[i]['mobile']);

      return mobiles;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<String>> getEmails() async {
    try {
      List<String> emails = [];
      Response response = await _dio.get("$baseURL/getemails");

      for (var i = 0; i < response.data.length; i++)
        emails.add(response.data[i]['email']);

      return emails;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<Product>> searchData(String token) async {
    try {
      Response response =
          await _dio.get('$baseURL/searchprod?api_token=$token');

      List<Product> products = [];
      if (response.statusCode == 200) {
        for (var i = 0; i < response.data.length; i++) {
          products.add(Product.mapToDetails(response.data[i]));
        }

        print(products.toString());
        return products;
      }
      return null;
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
      });

      Response response = await _dio.post(
        "$baseURL/reg",
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

  Future<User> loginUser(String mobileNo) async {
    User user = User();
    try {
      FormData formData = FormData.fromMap({
        'mobileNo': mobileNo,
      });

      Response response = await _dio.post(
        "$baseURL/login",
        data: formData,
      );

      print(response.data['status']);
      if (response.data['status'].contains('success')) {
        user.mapToUser(response.data['user']);
      }

      return user;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> logOut(String token) async {
    try {
      Response response = await _dio.get("$baseURL/logout?api_token=$token");
      print(response.data);
      if (response.data['status'].contains('success')) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      throw (e);
    }
  }

  Future<bool> updateUser(User user, bool id, bool visiting) async {
    try {
      Map<String, dynamic> updateData = {
        'category': 1,
        'name': user.name,
        'mobileNo': user.mobileNo,
        'email': user.email,
        'designation': user.designation,
        'photoIdType': user.photoIdType,
        'photoLocation': user.photoLocation,
        'visitingCardLocation': user.visitingCardLocation,
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
      };
      if (id)
        updateData['photo_id'] = await MultipartFile.fromFile(
            user.photoLocation,
            filename: '${user.photoIdType}-${user.id}');

      if (visiting)
        updateData['visiting_card'] = await MultipartFile.fromFile(
            user.visitingCardLocation,
            filename: 'VisitingCard-${user.id}');

      FormData formData = FormData.fromMap(updateData);

      Response response = await _dio.post(
        "$baseURL/updateuser?api_token=${user.token}",
        data: formData,
      );

      print(response.data);
      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> sendOTP(String mobileNo) async {
    try {
      FormData formData = FormData.fromMap({
        'mobileNo': int.parse(mobileNo),
      });
      print(int.parse(mobileNo));

      Response response = await _dio.post(
        "$baseURL/sendOTP",
        data: formData,
      );

      print(response.data);

      if (json.decode(response.data)['type'].contains('success')) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> verifyOTP(String mobileNo, String otp) async {
    print(mobileNo + ' => ' + otp);
    try {
      Response response =
          await _dio.post('$verifyOTPUrl&mobile=$mobileNo&otp=$otp');

      print(response);

      if (json.decode(response.data)['type'].contains('success')) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<Category>> getCategoriesList(String token) async {
    try {
      Response response =
          await _dio.get('$baseURL/categories?api_token=$token');

      List<Category> categories = [];
      for (var i = 0; i < (response.data).length; i++)
        categories.add(Category.frommap((response.data)[i]));

      print(categories);
      return categories;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<Product>> getProductsList(
      BuildContext context, String token, String categoryId) async {
    try {
      productList.clear();
      Response response = await _dio
          .get('$baseURL/prodpercategory/$categoryId?api_token=$token');

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
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<ProductDetails> getProductDetails(int productId, String token) async {
    try {
      Response response =
          await _dio.get('$baseURL/proddetails/$productId?api_token=$token');

      print(response.data);
      ProductDetails details =
          ProductDetails.mapToProductDetails(response.data);

      return details;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Map> placeOrder(
    int productId,
    String token,
    String color,
    List<Map<String, dynamic>> ordersList,
  ) async {
    try {
      Map<String, dynamic> orderData = {'order_color': color};
      for (var i = 0; i < ordersList.length; i++) {
        orderData['orders[$i][size]'] = ordersList[i]['size'];
        orderData['orders[$i][quantity]'] = ordersList[i]['quantity'];
      }
      print("------>this<-------");
      print(orderData);
      FormData formData = FormData.fromMap(orderData);

      Response response = await _dio.post(
        "$baseURL/placeorder/$productId?api_token=$token",
        data: formData,
      );

      return response.data;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<int> addRemarks(
    String productId,
    String token,
    String remarks,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'remarks': remarks,
      });

      Response response = await _dio.post(
        "$baseURL/addremarks/$productId?api_token=$token",
        data: formData,
      );

      print(response.data);

      if (response.data['status'].contains('error')) {
        return -1;
      } else if (response.data['status'].isNotEmpty)
        return 1;
      else
        return 0;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<int> updateRemark(
    String productId,
    String token,
    String remarks,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'remarks': remarks,
      });

      Response response = await _dio.post(
        "$baseURL/editremarks/$productId?api_token=$token",
        data: formData,
      );

      print(response.data);

      if (response.data['status'].contains('error')) {
        return -1;
      } else if (response.data['status'].isNotEmpty)
        return 1;
      else
        return 0;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<bool> addToCart(
    String token,
    String productId,
    String size,
    String qty,
    String color,
  ) async {
    try {
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
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> updateCart(
    String token,
    String productId,
    String size,
    String qty,
    String color,
  ) async {
    try {
      FormData formData = FormData.fromMap({
        'size': size,
        'quantity': qty,
        'color': color,
      });

      Response response = await _dio.post(
        '$baseURL/editorder/$productId?api_token=$token',
        data: formData,
      );

      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> removeFromCart(
    String token,
    String id,
  ) async {
    try {
      Response response = await _dio.get(
        '$baseURL/remcartitem/$id?api_token=$token',
      );
      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> placeOrderFromCart(
    String token,
  ) async {
    try {
      Response response = await _dio.get(
        '$baseURL/cartorder?api_token=$token',
      );
      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> notifyAdmin(
    String token,
  ) async {
    try {
      Response response = await _dio.get(
        '$baseURL/notify?api_token=$token',
      );
      if (response.statusCode == 200)
        return true;
      else
        return false;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<Cart>> getCartItems(String token) async {
    try {
      List<Cart> cartItems = [];

      Response response = await _dio.get('$baseURL/viewcart?api_token=$token');

      for (var i = 0; i < (response.data).length; i++)
        cartItems.add(Cart.fromMap((response.data)[i]));

      print(cartItems);
      return cartItems;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<Order>> getMyOrders(String token) async {
    try {
      List<Order> orderedItems = [];
      Response response = await _dio.get("$baseURL/myorders?api_token=$token");

      print(response.data.keys);
      for (String i in response.data.keys) {
        orderedItems
            .add(Order(int.parse(i), response.data[i][0]['created_at']));
      }
      print(orderedItems.toString());
      return orderedItems.reversed.toList();
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<OrderDetails>> getOrderDetails(String token, int orderId) async {
    try {
      List<OrderDetails> orderedItems = [];
      Response response = await _dio.get("$baseURL/myorders?api_token=$token");

      for (String i in response.data.keys) {
        if (int.parse(i) == orderId) {
          for (var j = 0; j < response.data[i].length; j++) {
            orderedItems.add(
                OrderDetails.mapToOrder(response.data[i][j], int.parse(i)));
          }
          break;
        }
      }
      print(orderedItems.toString());
      return orderedItems;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<List<Bill>> getBills(String token, String orderId) async {
    try {
      List<Bill> bills = [];
      Response response =
          await _dio.get('$baseURL/showbill/$orderId?api_token=$token');

      //print(response.data);
      for (var i = 0; i < response.data['bills'].length; i++)
        bills.add(Bill.mapToBill(response.data['bills'][i]));
      print(bills.toString());
      return bills;
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<Map<dynamic, dynamic>> getAdminContactDetails() async {
    try {
      Response response = await _dio.get('$baseURL/contactadmin');

      return response.data;
    } catch (e) {
      print(e);
      throw e;
    }
  }
}
