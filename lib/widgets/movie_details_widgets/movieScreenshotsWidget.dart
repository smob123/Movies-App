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
  List<Widget> _mediaList = new List<Widget>(); //list of different media widgets
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getScreenShots();
  }

  //gets the movie's trailer, and screenshots
  Future getScreenShots() async {
    //add the movie's trailer first
    _mediaList.add(VideoWidget(
      videoId: widget.movieId,
    ));

    //get the screenshots from the API
    var imgScreenshotsUrls = await DataFetch().getMovieScreenshots(widget.movieId);
    //base url for all the images
    final String baseUrl = 'https://image.tmdb.org/t/p/w500';

    for (int i = 0; i < imgScreenshotsUrls.length; i++) {
      //add each screenshot in a container, and then add it to the list
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
      child: _loading //check if still loading
          ? LoadingWidget(
              color: Colors.blue,
            )
          : Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Padding( //the section's header text
                      padding: EdgeInsets.only(left: 5.0, bottom: 10.0),
                      child: Text(
                        'Screenshots',
                        style: Theme.of(context).textTheme.headline,
                      )),
                  Container( //display the media as a horizontal list
                      constraints: BoxConstraints(maxHeight: 200.0),
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _mediaList,
                      ))
                ])),
    );
  }
}
