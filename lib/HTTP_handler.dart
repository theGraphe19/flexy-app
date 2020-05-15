import 'package:dio/dio.dart';

import './models/user.dart';
import './credentials.dart';

class HTTPHandler {
  User currentUser = User();

  Future<User> loginUser(String email, String password) async {
    User user = User();
    FormData formData = FormData.fromMap({
      'email': email,
      'password': password,
    });

    Response response = await Dio().post(
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
}
