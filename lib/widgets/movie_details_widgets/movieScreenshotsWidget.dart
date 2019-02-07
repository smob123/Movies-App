import 'package:flutter/material.dart';

import '../../networking/dataFetch.dart';
import '../general_widgets/loadingWidget.dart';
import './videoWidget.dart';

class MovieScreenshotsWidget extends StatefulWidget {
  MovieScreenshotsWidget({this.movieId});

  final String movieId;

  MovieScreenshotsWidgetState createState() =>
      MovieScreenshotsWidgetState();
}

class MovieScreenshotsWidgetState extends State<MovieScreenshotsWidget> {
  List<Widget> _mediaList = new List<Widget>();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getScreenShots();
  }

  Future getScreenShots() async {
    _mediaList.add(VideoWidget(
      videoId: widget.movieId,
    ));

    var imgScreenshotsUrls = await DataFetch().getMovieScreenshots(widget.movieId);
    final String baseUrl = 'https://image.tmdb.org/t/p/w500';

    for (int i = 0; i < imgScreenshotsUrls.length; i++) {
      _mediaList.add(Container(
          margin: EdgeInsets.only(right: 5.0),
          child: Image.network(
            baseUrl + imgScreenshotsUrls[i]['file_path'],
          )));
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
          : Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Padding(
                      padding: EdgeInsets.only(left: 5.0, bottom: 10.0),
                      child: Text(
                        'Screenshots',
                        style: Theme.of(context).textTheme.headline,
                      )),
                  Container(
                      constraints: BoxConstraints(maxHeight: 200.0),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _mediaList,
                      ))
                ])),
    );
  }
}
