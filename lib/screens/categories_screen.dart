import 'package:flexy/models/category.dart';
import 'package:flutter/material.dart';

import './products_screen.dart';
import '../models/user.dart';
import '../HTTP_handler.dart';

class CategoriesScreen extends StatefulWidget {
  static const routeName = '/categories-screen';

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  User _currentUser;
  bool categoryListHandler = false;
  List<Category> categoriesList;

  @override
  Widget build(BuildContext context) {
    _currentUser = ModalRoute.of(context).settings.arguments as User;

    if (!categoryListHandler) {
      categoryListHandler = true;
      if (_currentUser.status == 1)
        HTTPHandler().getCategoriesList(_currentUser.token).then((cat) {
          categoriesList = cat;
          setState(() {});
        });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Text(
                'About Flexy : ',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
            ),
            SizedBox(height: 10.0),
            Divider(),
            Container(
              width: double.infinity,
              child: Text(
                'Categories : ',
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10.0),
            (_currentUser.status == 1)
                ? (categoriesList == null)
                    ? CircularProgressIndicator()
                    : Expanded(
                        child: ListView.builder(
                          itemCount: categoriesList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(categoriesList[index].name),
                              trailing: Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  ProductsScreen.routeName,
                                  arguments: <String, dynamic>{
                                    'user': _currentUser,
                                    'category_id': categoriesList[index].id,
                                  },
                                );
                              },
                            );
                          },
                        ),
                      )
                : Text((_currentUser.status == 0)
                    ? 'Please wait until allowed by Admin!'
                    : 'You have been banned by admin!'),
          ],
        ),
      ),
    );
  }
}