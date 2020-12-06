import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/wishlist_provider.dart';
import '../widgets/product_item.dart';
import '../models/user.dart';

class WishlistBottomSheet {
  BuildContext context;
  GlobalKey<ScaffoldState> scaffoldKey;
  User user;
  WishlistProvider _wishlistProvider;

  WishlistBottomSheet({
    @required this.context,
    @required this.scaffoldKey,
    @required this.user,
  }) {
    _wishlistProvider = Provider.of<WishlistProvider>(context);
  }

  void fireWishlist() {
    scaffoldKey.currentState.showBottomSheet((BuildContext context) {
      return Container(
        width: double.infinity,
        height: 450.0,
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Wishlist'),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
            ),
            Divider(),
            Expanded(
              child: (_wishlistProvider.wishList == null ||
                      _wishlistProvider.wishList.length == 0)
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
                            'No items added yet!',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _wishlistProvider.wishList.length,
                      itemBuilder: (BuildContext context, int index) {
                        print(_wishlistProvider
                            .wishList[index].product.product.name);
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: ProductItem(
                            _wishlistProvider.wishList[index].product.product,
                            user,
                            _wishlistProvider.wishList[index].category,
                            scaffoldKey,
                            true,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }
}
