import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../models/order_details.dart';
import '../models/bill.dart';
import '../widgets/loading_body.dart';
import '../HTTP_handler.dart';

/*
  <a target="_blank" href="https://icons8.com/icons/set/road-closure">Road Closure icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
  <a target="_blank" href="https://icons8.com/icons/set/stack-of-money">Stack of Money icon</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>
 */

class BillScreen extends StatefulWidget {
  static const routeName = '/bill-screen';

  @override
  _BillScreenState createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  OrderDetails order;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  String token;
  Bill bill;

  bool _tokenController = false;

  void _getToken() async {
    _tokenController = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    if (token != null) {
      print('retreived token : $token');

      await HTTPHandler()
          .getBills(
        token,
        order.billId,
      )
          .then((value) {
        bill = value;
        setState(() {});
      }).catchError((e) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'Network error!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xff6c757d),
          duration: Duration(seconds: 3),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    order = ModalRoute.of(context).settings.arguments as OrderDetails;
    if (!_tokenController) _getToken();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Bill'),
      ),
      body: (token == null)
          ? LoadingBody()
          : Container(
              padding: const EdgeInsets.all(10.0),
              child: (bill == null)
                  ? Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 70.0,
                            width: 70.0,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: Image.asset('assets/images/wait.png'),
                          ),
                          Text(
                            'Bill not uploaded yet!',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: bill.bills.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: ListTile(
                            leading:
                                Image.asset('assets/images/bill_download.png'),
                            title: Text(bill.bills[index]),
                            trailing: GestureDetector(
                              onTap: () async {
                                try {
                                  String dirloc = "";
                                  if (Platform.isAndroid) {
                                    dirloc = "/sdcard/download/";
                                  } else {
                                    dirloc =
                                        (await getApplicationDocumentsDirectory())
                                            .path;
                                  }
                                  print(bill.bills[index]);
                                  print(dirloc);
                                  Response response = await Dio().get(
                                    'https://developers.thegraphe.com/flexy/storage/app/bills/${bill.bills[index]}',
                                    onReceiveProgress: showDownloadProgress,
                                    options: Options(
                                      responseType: ResponseType.bytes,
                                      followRedirects: false,
                                      validateStatus: (status) {
                                        return status < 500;
                                      },
                                    ),
                                  );
                                  print(response.headers);
                                  File file =
                                      File("$dirloc/${bill.bills[index]}");
                                  var raf = file.openSync(mode: FileMode.write);
                                  raf.writeFromSync(response.data);
                                  await raf.close();
                                  print('saved');
                                  scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      'Saved in $dirloc',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Color(0xff6c757d),
                                    duration: Duration(seconds: 3),
                                  ));
                                } catch (e) {
                                  print(e);
                                  scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      'Network error!',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: Color(0xff6c757d),
                                    duration: Duration(seconds: 3),
                                  ));
                                }
                              },
                              child: Icon(
                                Icons.file_download,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
}
