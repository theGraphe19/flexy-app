import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import './credentials.dart';
import './models/user.dart';
import './models/product.dart';
import './models/product_details.dart';
import './models/order.dart';
import './models/bill.dart';

class HTTPHandler {
  User currentUser = User();
  Dio _dio = Dio();
  List<Product> productList = [];

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

  Future<List<Bill>> getBills(String token, String orderId) async {
    List<Bill> bills = [];
    Response response = await _dio.get('$billUrl/$orderId?api_token=$token');

    //print(response.data);
    for (var i = 0; i < response.data['bills'].length; i++)
      bills.add(Bill.mapToBill(response.data['bills'][i]));
    print(bills.toString());
    return bills;
  }

  Future downloadBillIOS(
    String fileName,
    String billId,
    String token,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    // final directory = await getApplicationDocumentsDirectory();
    // CancelToken cancelToken = CancelToken();
    // try {
    //   await _dio.download(
    //     '$billDownloadUrl/$billId?api_token=$token',
    //     '${directory.path}/flexy/$fileName',
    //     onReceiveProgress: showDownloadProgress,
    //     cancelToken: cancelToken,
    //   );
    // } catch (e) {
    //   print(e);
    // }

    try {
      Response response = await _dio.get(
        '$billDownloadUrl/$billId?api_token=$token',
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );
      print(response.headers);
      print('Path : ${directory.path}');
      File file = File('${directory.path}/flexy/$fileName');
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      print('download complete');
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
}
