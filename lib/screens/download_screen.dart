import 'dart:io';
import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_utils/file_utils.dart';

class FileDownloader extends StatefulWidget {
  final url;

  FileDownloader(this.url);

  @override
  _FileDownloaderState createState() => _FileDownloaderState();
}

class _FileDownloaderState extends State<FileDownloader> {
  bool downloading = false;
  var progress = "";
  var path = "No Data";
  var platformVersion = "Unknown";
  /*
  Permission permission1 = Permission.storage;
  */
  var _onPressed;
  static final Random random = Random();
  Directory externalDir;

  @override
  void initState() {
    super.initState();
    downloadFile();
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    // var checkPermission1 =
    //     await permission1.status;
    // // print(checkPermission1);
    // if (checkPermission1.isUndetermined) {
    //   await permission1.request();
    //   checkPermission1 = await SimplePermissions.checkPermission(permission1);
    // }
    if (/*await Permission.storage.request().isGranted*/ true) {
      String dirloc = "";
      if (Platform.isAndroid) {
        dirloc = "/sdcard/download/";
      } else {
        dirloc = (await getApplicationDocumentsDirectory()).path;
      }

      var randid = random.nextInt(10000);

      try {
        FileUtils.mkdir([dirloc]);
        await dio.download(widget.url, dirloc + randid.toString() + ".pdf",
            onReceiveProgress: (receivedBytes, totalBytes) {
          setState(() {
            downloading = true;
            print(
                ((receivedBytes / totalBytes) * 100).toStringAsFixed(0) + "%");
          });
        });
      } catch (e) {
        print(e);
      }
      downloading = false;
      progress = "Download Completed.";
      path = dirloc + randid.toString() + ".jpg";
      Navigator.of(context).pop(true);
    } else {
      progress = "Permission Denied!";
      _onPressed = () {
        downloadFile();
      };
      Navigator.of(context).pop(false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('File Downloader'),
        ),
        body: Center(
          child: downloading
              ? Container(
                  height: 120.0,
                  width: 200.0,
                  child: Card(
                    color: Colors.black,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          'Downloading File',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(path),
                    MaterialButton(
                      child: Text('Request Permission Again.'),
                      onPressed: _onPressed,
                      disabledColor: Colors.blueGrey,
                      color: Colors.pink,
                      textColor: Colors.white,
                      height: 40.0,
                      minWidth: 100.0,
                    ),
                  ],
                ),
        ),
      );
}
