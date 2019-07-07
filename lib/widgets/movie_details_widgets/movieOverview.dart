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
  final CacheHandler _cacheHandler = new CacheHandler(); //stores the movie in the app's cache if it gets bookmarked

  @override
  void initState() {
    super.initState();
    _isBookmarked();
    _fetchMovieDetails();
  }

  //fetches information about the movie
  Future _fetchMovieDetails() async {
    //grab the data from the api
    var decodedJson =
        await DataFetch().fetchMovieDetails(widget.movieData['movieId']);
    //store it into the variables
    _releaseDate = decodedJson['release_date'];
    _runTime = '${decodedJson['runtime'].toString()}';

    //check if the fetched data is not null
    _runTime != 'null' ? _runTime += ' minutes' : _runTime = 'N/A';

    setState(() {
      _loading = false;
    });
  }

  //checks if the movie was bookmarked previously
  _isBookmarked() async {
    //check if the movie exists in the cache directory
    bool movieIsBookmarked = await _cacheHandler.getBookmark(widget.movieData);

    if (movieIsBookmarked) {
      setState(() {
        _bookMarked = true;
      });
    }
  }

  //changes the bookmark icon based on whether the movie is bookmarked or not
  _bookmarkIconState() {
    IconData bookmarkIcon =
        _bookMarked ? Icons.bookmark : Icons.bookmark_border;
    return Icon(
      bookmarkIcon,
      color: Colors.white70,
      size: 40.0,
    );
  }

  //handles adding, and removing the movie from the cache directory
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
      Container( //container for the bookmark icon
          alignment: Alignment.centerRight,
          margin: EdgeInsets.only(right: 10.0, top: 10.0),
          child: GestureDetector( //makes the icon clickable
            child: _bookmarkIconState(),
            onTap: () => _bookmarkCacheState(),
          )),
      Row( //row for the movie's general details
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container( //container for the movie's poster
              width: MediaQuery.of(context).size.width / 3,
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.topLeft,
              child: Hero(
                  tag: '${widget.movieData['hero tag']}', //add the image's hero tag to run the hero animation
                  child: Image.network(widget.movieData['poster']))),
          Container( //container for the movie's information
            width: MediaQuery.of(context).size.width / 1.5,
            child: Column(
              children: <Widget>[
                Padding( //contains the movie's rating
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
                Padding( //contains the movie's runtime
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
                Padding( //contains the movie's release date
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
      Padding( //divider between sections
          padding:
              EdgeInsets.only(top: 20.0, bottom: 20.0, left: 50.0, right: 50.0),
          child: Divider(
            height: 5.0,
            indent: 0.0,
            color: Colors.white70,
          )),
      _loading //check if in loading state
          ? LoadingWidget(
              color: Colors.blue,
            )
          : Container( //movie's story section's header
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.topLeft,
              child: Text(
                'Story',
                style: Theme.of(context).textTheme.headline,
              ),
            ),
      Container( //contains the description of the movie's story
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
