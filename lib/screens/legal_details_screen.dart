import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';

import '../HTTP_handler.dart';

class LegalDetailsScreen extends StatefulWidget {
  static const routeName = '/legal-details-screen';

  @override
  _LegalDetailsScreenState createState() => _LegalDetailsScreenState();
}

class _LegalDetailsScreenState extends State<LegalDetailsScreen> {
  String details;

  @override
  void initState() {
    super.initState();
    HTTPHandler().getLegalDetails().then((value) {
      setState(() {
        this.details = value;
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Legal Details')),
      body: (details == null)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Html(
                  data: details,
                  onLinkTap: (url) {
                    print("Opening $url...");
                    launch(url);
                  },
                ),
              ),
            ),
    );
  }
}
