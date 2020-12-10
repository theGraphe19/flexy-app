import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';

class ImageZoomScreen extends StatefulWidget {
  static const routeName = '/image-zoom-screen';

  @override
  _ImageZoomScreenState createState() => _ImageZoomScreenState();
}

class _ImageZoomScreenState extends State<ImageZoomScreen> {
  int imageIndex;
  List images;
  var currentActiveIndex = 0;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  PageController _pageController;
  bool isExecutingFirst = false;

  void initializePlayer() async {
    for (String s in images) {
      List ext = s.split('.');
      if (ext.contains('mp4')) {
        _controller = VideoPlayerController.network(
          'https://developers.thegraphe.com/flexy/storage/app/product_images/${s}',
        );
        await _controller.setLooping(true);

        _initializeVideoPlayerFuture = _controller.initialize();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context).settings.arguments as List;
    imageIndex = data[0];
    images = data[1];
    if (!isExecutingFirst) {
      currentActiveIndex = imageIndex;
      isExecutingFirst = true;
    }
    _pageController = PageController(initialPage: imageIndex, keepPage: false);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height - 40,
            child: PageView.builder(
              controller: _pageController,
              itemCount: images.length,
              onPageChanged: (int currentIndex) {
                setState(() {
                  currentActiveIndex = currentIndex;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                List<String> ext =
                    (images[currentActiveIndex] as String).split('.');
                print(ext[ext.length - 1]);
                if (ext[ext.length - 1] == 'mp4') {
                  return FutureBuilder(
                    future: _initializeVideoPlayerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return AspectRatio(
                          aspectRatio: 0.5,
                          child: VideoPlayer(_controller),
                        );
                      } else {
                        return Center(
                            child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                        ));
                      }
                    },
                  );
                } else
                  return Hero(
                    tag: images[currentActiveIndex],
                    child: Container(
                      width: double.infinity,
                      height: 400.0,
                      color: Colors.white,
                      child: Center(
                        child: PhotoView(
                          backgroundDecoration:
                              BoxDecoration(color: Colors.white),
                          imageProvider: NetworkImage(
                            'https://developers.thegraphe.com/flexy/storage/app/product_images/${images[currentActiveIndex]}',
                          ),
                        ),
                      ),
                    ),
                  );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                for (var i = 0; i < images.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 10.0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (currentActiveIndex == i)
                            ? Theme.of(context).colorScheme.secondary
                            : Colors.grey,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
