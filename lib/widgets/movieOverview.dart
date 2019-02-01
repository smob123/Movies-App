import 'package:flutter/material.dart';

import '../networking/dataFetch.dart';
import '../widgets/loadingWidget.dart';

class MovieOverview extends StatefulWidget {
  MovieOverview({this.movieData});

  final Map movieData;

  MovieOverviewState createState() => MovieOverviewState(
        movieData: movieData,
      );
}

class MovieOverviewState extends State<MovieOverview> {
  MovieOverviewState({this.movieData});

  Map movieData;
  String genre = '', rated = '', releaseDate = '';
  bool _loading = true;
  List<Widget> _castWidget = new List<Widget>();

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails();
  }

  Future _fetchMovieDetails() async {
    var decodedJson = await DataFetch().fetchMovieDetails(movieData['title']);
    genre = decodedJson['Genre'];
    rated = decodedJson['Rated'];
    releaseDate = decodedJson['Released'];

    _getMovieCast();
  }

  Future _getMovieCast() async {
    List castData = await DataFetch().getMoviesCast(movieData['movieId']);
    List<Widget> c = new List<Widget>();

    for (int i = 0; i < castData.length; i++) {
      var castImage = castData[i]['profile_path'];

      c.add(Container(
          height: 200.0,
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(right: 20.0),
          child: Column(children: [
            Container(
              alignment: Alignment.center,
                height: 100.0,
                child: castImage != null
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w500$castImage',
                        width: 100.0,
                      )
                    : Image.asset(
                        'assets/images/clap_board.png',
                        width: 100.0,
                      )),
            Padding(
                padding: EdgeInsets.only(top: 5.0),
                child: Text(
                  castData[i]['name'],
                  style: TextStyle(letterSpacing: 0.5),
                ))
          ])));
    }

    setState(() {
      _castWidget = c;
      _loading = false;
    });
  }

  @override
  build(BuildContext context) {
    final int index = movieData['item index'];

    return SingleChildScrollView(
        child: Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: MediaQuery.of(context).size.width / 3,
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.topLeft,
              child: Hero(
                  tag: 'dash $index',
                  child: Image.network(movieData['poster']))),
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
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
            height: 5.0,
            indent: 0.0,
            color: Colors.black54,
          )),
      Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.only(left: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Cast',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            Container(
                height: MediaQuery.of(context).size.height / 4,
                padding: EdgeInsets.only(top: 20.0),
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 5.0),
                    children: _castWidget))
          ],
        ),
      )
    ]));
  }
}
