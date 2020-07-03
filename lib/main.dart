import 'package:flexy/HTTP_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot_callback/screenshot_callback.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
import './screens/cart_screen.dart';
import './screens/view_update_profile_screen.dart';

import './providers/product_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ScreenshotCallback screenshotCallback;

  String text = "Ready..";

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    screenshotCallback = ScreenshotCallback();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token');
    screenshotCallback.addListener(() {
      print("ScreenShot Attempted");
      HTTPHandler().notifyAdmin(token);
    });
  }

  @override
  void dispose() {
    screenshotCallback.dispose();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ProductProvider(),
        ),
      ],
      child: MaterialApp(
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
          CartScreen.routeName: (ctx) => CartScreen(),
          ViewUpdateProfile.routeName: (ctx) => ViewUpdateProfile(),
        },
      ),
    );
  }
}
