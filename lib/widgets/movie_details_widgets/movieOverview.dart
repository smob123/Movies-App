import 'package:flutter/material.dart';

import '../../config/cacheHandler.dart';
import '../../networking/dataFetch.dart';
import '../../widgets/general_widgets/loadingWidget.dart';

class MovieOverview extends StatefulWidget {
  MovieOverview({this.movieData});

  final Map movieData;

  MovieOverviewState createState() => MovieOverviewState();
}

class MovieOverviewState extends State<MovieOverview> {
  String _releaseDate = '', _runTime = '';
  bool _loading = true;
  bool _bookMarked = false;
  final CacheHandler _cacheHandler = new CacheHandler();

  @override
  void initState() {
    super.initState();
    _isBookmarked();
    _fetchMovieDetails();
  }

  Future _fetchMovieDetails() async {
    var decodedJson =
        await DataFetch().fetchMovieDetails(widget.movieData['movieId']);
    _releaseDate = decodedJson['release_date'];
    _runTime = '${decodedJson['runtime'].toString()}';

    _runTime != 'null' ? _runTime += ' minutes' : _runTime = 'N/A';

    setState(() {
      _loading = false;
    });
  }

  _isBookmarked() async {
    bool movieIsBookmarked = await _cacheHandler.getBookmark(widget.movieData);

    if (movieIsBookmarked) {
      setState(() {
        _bookMarked = true;
      });
    }
  }

  _bookmarkIconState() {
    IconData bookmarkIcon =
        _bookMarked ? Icons.bookmark : Icons.bookmark_border;
    return Icon(
      bookmarkIcon,
      color: Colors.white70,
      size: 40.0,
    );
  }

  _bookmarkCacheState() {
    if (!_bookMarked) {
      _cacheHandler.addBookmark(widget.movieData);
    } else {
      _cacheHandler.removeBookmark(widget.movieData);
    }

    setState(() {
      _bookMarked = !_bookMarked;
    });
  }

  @override
  build(BuildContext context) {
    return Column(children: [
      Container(
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(right: 10.0, top: 10.0),
          child: GestureDetector(
            child: _bookmarkIconState(),
            onTap: () => _bookmarkCacheState(),
          )),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: MediaQuery.of(context).size.width / 3,
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.topLeft,
              child: Hero(
                  tag: '${widget.movieData['hero tag']}',
                  child: Image.network(widget.movieData['poster']))),
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            child: Column(
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.rate_review,
                          color: Colors.white70,
                          size: 25.0,
                        ),
                        Text(' ${widget.movieData['rating']} / 10',
                            style: TextStyle(
                              fontSize: 18.0,
                            )),
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
                    child: Row(children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.white70,
                        size: 25.0,
                      ),
                      Text(
                        ' $_runTime',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      )
                    ])),
                Padding(
                    padding: EdgeInsets.only(
                        left: 10.0, top: 5.0, right: 5.0, bottom: 5.0),
                    child: Row(children: [
                      Icon(
                        Icons.date_range,
                        color: Colors.white70,
                        size: 25.0,
                      ),
                      Text(
                        ' $_releaseDate',
                      )
                    ]))
              ],
            ),
          ),
        ],
      ),
      Padding(
          padding:
              EdgeInsets.only(top: 20.0, bottom: 20.0, left: 50.0, right: 50.0),
          child: Divider(
            height: 5.0,
            indent: 0.0,
            color: Colors.white70,
          )),
      _loading
          ? LoadingWidget(
              color: Colors.blue,
            )
          : Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.topLeft,
              child: Text(
                'Story',
                style: Theme.of(context).textTheme.headline,
              ),
            ),
      Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(10.0),
        child: Text(
          widget.movieData['description'],
          style: TextStyle(color: Colors.white54),
        ),
      ),
    ]);
  }
}
