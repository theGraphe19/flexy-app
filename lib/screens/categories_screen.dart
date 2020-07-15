import 'package:flutter/material.dart';

import './products_screen.dart';
import '../models/user.dart';
import '../HTTP_handler.dart';
import '../utils/drawer.dart';
import '../widgets/loading_body.dart';
import '../models/category.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/categories-screen';

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  User _currentUser;
  bool categoryListHandler = false;
  List<Category> categoriesList;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HTTPHandler _handler = HTTPHandler();

  void _showAbout(BuildContext context, String about) {
    Future.delayed(Duration(seconds: 3), () {
      print('now');
      return showModalBottomSheet(
        context: context,
        barrierColor: Colors.black.withAlpha(1),
        backgroundColor: Colors.transparent,
        builder: (context) => Stack(
          children: <Widget>[
            Opacity(
              opacity: 0.45,
              child: Container(
                height: 250,
                color: Colors.black,
              ),
            ),
            Container(
              height: 250,
              margin: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'About Us : ',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                  Divider(),
                  SizedBox(height: 10.0),
                  Text(
                    about,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    _currentUser = ModalRoute.of(context).settings.arguments as User;

    if (_currentUser.status != 1)
      _handler.getAdminContactDetails().then((Map value) {
        _showAbout(context, value['about']);
      });

    if (!categoryListHandler) {
      categoryListHandler = true;
      if (_currentUser.status == 1)
        _handler.getCategoriesList(_currentUser.token).then((cat) {
          categoriesList = cat;
          setState(() {});
        }).catchError((e) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
              'Network error!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xff6c757d),
            duration: Duration(seconds: 3),
          ));
        });
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            print('more pressed');
            _scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text('Categories'),
      ),
      drawer: SideDrawer(_currentUser, _scaffoldKey).drawer(context),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            (_currentUser.status == 1)
                ? (categoriesList == null)
                    ? LoadingBody()
                    : Expanded(
                        child: ListView.builder(
                          itemCount: categoriesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  ProductsScreen.routeName,
                                  arguments: <String, dynamic>{
                                    'user': _currentUser,
                                    'category_id': categoriesList[index].id,
                                  },
                                );
                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height / 3,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Image.network(
                                      'http://developers.thegraphe.com/flexy/storage/app/categories/${categoriesList[index].image}',
                                      height:
                                          MediaQuery.of(context).size.height /
                                                  3 -
                                              5,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        (_currentUser.status == 0)
                            ? 'assets/images/pending.png'
                            : 'assets/images/rejected.png',
                        height: 70.0,
                        width: 70.0,
                      ),
                      Text((_currentUser.status == 0)
                          ? 'Please wait until allowed by Admin!'
                          : 'You have been banned by admin!'),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
