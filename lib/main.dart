import 'package:flutter/material.dart';

import './screens/start_screen.dart';
import './screens/registration_form_page1.dart';
import './screens/registration_form_page2.dart';
import './screens/registration_form_page3.dart';
import './screens/otp_verification_screen.dart';
import './screens/login_screen.dart';
import './screens/categories_screen.dart';
import './screens/products_screen.dart';
import './screens/product_details_screen.dart';
import './screens/orders_screen.dart';
import './screens/my_orders_screen.dart';
import './screens/bill_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StartScreen(),
      routes: {
        StartScreen.routeName: (ctx) => StartScreen(),
        RegistrationFormPag1.routeName: (ctx) => RegistrationFormPag1(),
        RegistrationFormPart2.routeName: (ctx) => RegistrationFormPart2(),
        RegistrationFormPage3.routeName: (ctx) => RegistrationFormPage3(),
        OTPVerificationScreen.routeName: (ctx) => OTPVerificationScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen(),
        CategoriesScreen.routeName: (ctx) => CategoriesScreen(),
        ProductsScreen.routeName: (ctx) => ProductsScreen(),
        ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
        OrdersScreen.routeName: (ctx) => OrdersScreen(),
        MyOrdersScreen.routeName: (ctx) => MyOrdersScreen(),
        BillScreen.routeName: (ctx) => BillScreen(),
      },
    );
  }
}
