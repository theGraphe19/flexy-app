import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order.dart';
import '../models/bill.dart';
import '../widgets/loading_body.dart';
import '../HTTP_handler.dart';
import '../widgets/bill_item.dart';

class BillScreen extends StatefulWidget {
  static const routeName = '/bill-screen';

  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  Order order;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String token;
  List<Bill> bills;

  bool _tokenController = false;

  void _getToken() async {
    _tokenController = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    if (token != null) {
      print('retreived token : $token');

      await HTTPHandler().getBills(token, order.id.toString()).then((value) {
        bills = value;
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    order = ModalRoute.of(context).settings.arguments as Order;
    if (!_tokenController) _getToken();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Bill'),
      ),
      body: (token == null)
          ? LoadingBody()
          : Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: (bills.isEmpty)
                  ? Center(
                      child: Text(
                        'Bill not uploaded yet!',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 25.0,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: bills.length,
                      itemBuilder: (BuildContext context, int index) =>
                          BillItem(
                        bills[index],
                        order,
                        token,
                        scaffoldKey,
                      ),
                    ),
            ),
    );
  }
}
