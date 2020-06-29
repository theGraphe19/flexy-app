import 'package:flutter/material.dart';

import '../models/product.dart';

class CartBottomSheet {
  void showBottomSheet(BuildContext context, Product product) =>
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    product.name,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15.0,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
              Text('Size selector dropdown'),
              Text('quantity selector drop down'),
              Text('confirm button'),
            ],
          ),
        ),
      );
}
