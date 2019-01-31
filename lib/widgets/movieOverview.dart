import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:quiver/cache.dart';

import '../networking/dataFetch.dart';
import '../widgets/loadingWidget.dart';

class MovieOverview extends StatefulWidget {
  MovieOverview({this.movieData});

  final Map movieData;

  MovieOverviewState createState() =>
      MovieOverviewState(
        movieData: movieData,
      );
}

class MovieOverviewState extends State<MovieOverview> {
  MovieOverviewState({this.movieData});

  Map movieData;
  String genre = '',
      rated = '',
      releaseDate = '';
  bool _favourite = false;
  bool _loading = true;
  var _cacheManager;

  @override
  initState() {
    super.initState();
    _setCacheManager();
  }

  Future _setCacheManager() async {
    CacheManager.showDebugLogs = true;
    _cacheManager = await CacheManager.getInstance();
    var file = _cacheManager.putFile();
  }

  Future _fetchMovieDetails() async {
    var decodedJson = await DataFetch().fetchMovieDetails(movieData['title']);
    genre = decodedJson['Genre'];
    rated = decodedJson['Rated'];
    releaseDate = decodedJson['Released'];

    setState(() {
      _loading = false;
    });
  }

  _setFavourite() {
    return (
        GestureDetector(
            onTap: (() {
              _favourite = !_favourite;
            }),
            child: !_favourite
                ? Icon(
              Icons.favorite_border,
              color: Colors.black54,
              size: 35.0,
            )
                : Icon(
              Icons.favorite,
              color: Colors.red,
              size: 35.0,
            ))
    );
  }

  @override
  build(BuildContext context) {
    _fetchMovieDetails();
    final int index = movieData['item index'];

    return SingleChildScrollView(
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _setFavourite(),
              GestureDetector(
                  onTap: (() {}),
                  child: Icon(
                    Icons.share,
                    color: Colors.black54,
                    size: 35.0,
                  )),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 3,
                  padding: EdgeInsets.all(10.0),
                  alignment: Alignment.topLeft,
                  child: Hero(
                      tag: 'dash $index',
                      child: Image.network(movieData['poster']))),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 1.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                            left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
                        child: Text('Genre: $genre')),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
                        child: Text('Rated: $rated')),
                    Padding(
                        padding: EdgeInsets.only(
                            left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
                        child: Text('Release date: $releaseDate'))
                  ],
                ),
              ),
            ],
          ),
          _loading
              ? LoadingWidget(
            color: Colors.blue,
          )
              : Container(
            padding: EdgeInsets.all(10.0),
            alignment: Alignment.topLeft,
            child: Text(
              'Overview',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(5.0),
            child: Text(
              movieData['description'],
              style: TextStyle(fontSize: 15.0),
            ),
          ),
          Padding(
              padding:
              EdgeInsets.only(top: 20.0, bottom: 20.0, left: 50.0, right: 50.0),
              child: Divider(
                height: 2.0,
                indent: 0.0,
                color: Colors.grey,
              ))
        ]));
  }
}
