import 'package:flutter/material.dart';

import '../networking/dataFetch.dart';
import '../widgets/loadingWidget.dart';
import '../widgets/videoWidget.dart';

class MovieScreenshotsWidget extends StatefulWidget {
  MovieScreenshotsWidget({this.movieId});

  final String movieId;

  MovieScreenshotsWidgetState createState() =>
      MovieScreenshotsWidgetState(movieId: movieId);
}

class MovieScreenshotsWidgetState extends State<MovieScreenshotsWidget> {
  MovieScreenshotsWidgetState({this.movieId});

  final String movieId;
  List<Widget> _mediaList = new List<Widget>();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getScreenShots();
  }

  Future getScreenShots() async {
    _mediaList.add(VideoWidget(
      videoId: movieId,
    ));

    var imgScreenshotsUrls = await DataFetch().getMovieScreenshots(movieId);
    final String baseUrl = 'https://image.tmdb.org/t/p/w500';

    for (int i = 0; i < imgScreenshotsUrls.length; i++) {
      _mediaList
          .add(Image.network(baseUrl + imgScreenshotsUrls[i]['file_path']));
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  build(BuildContext context) {
    return Container(
      child: _loading
          ? LoadingWidget(
              color: Colors.blue,
            )
          : ListView(
              scrollDirection: Axis.vertical,
              children: _mediaList,
            ),
    );
  }
}
