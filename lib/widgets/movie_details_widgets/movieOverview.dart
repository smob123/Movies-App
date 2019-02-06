import 'package:flutter/material.dart';

import '../../networking/dataFetch.dart';
import '../../widgets/general_widgets/loadingWidget.dart';

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
  String releaseDate = '', runTime = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchMovieDetails();
  }

  Future _fetchMovieDetails() async {
    var decodedJson = await DataFetch().fetchMovieDetails(movieData['movieId']);
    releaseDate = decodedJson['release_date'];
    runTime = '${decodedJson['runtime'].toString()}';

    runTime != 'null' ? runTime += ' minutes' : runTime = 'N/A';

    setState(() {
      _loading = false;
    });
  }

  @override
  build(BuildContext context) {
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              width: MediaQuery.of(context).size.width / 3,
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.topLeft,
              child: Hero(
                  tag: '${movieData['hero tag']}',
                  child: Image.network(movieData['poster']))),
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
                        Text(' ${movieData['rating']} / 10',
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
                        ' $runTime',
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
                        ' $releaseDate',
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
          movieData['description'],
          style: TextStyle(color: Colors.white54),
        ),
      ),
    ]);
  }
}
