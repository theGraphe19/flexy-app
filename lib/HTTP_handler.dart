import 'dart:convert';

import 'package:dio/dio.dart';

import './models/user.dart';
import './credentials.dart';

class HTTPHandler {
  User currentUser = User();
  Dio _dio = Dio();

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
}
