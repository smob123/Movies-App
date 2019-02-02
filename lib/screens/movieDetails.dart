import 'package:flutter/material.dart';

import '../widgets/movie_details_widgets/movieOverview.dart';
import '../widgets/movie_details_widgets/header.dart';
import '../widgets/movie_details_widgets/movieCastWidget.dart';
import '../widgets/movie_details_widgets/movieScreenshotsWidget.dart';

class MovieDetails extends StatefulWidget {
  MovieDetails({this.movieData});

  final Map movieData;

  MovieDetailsState createState() => MovieDetailsState(movieData: movieData);
}

class MovieDetailsState extends State<MovieDetails> {
  MovieDetailsState({this.movieData});

  final Map movieData;

  @override
  build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 29, 29, 39),
        body: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.all(0.0),
            children: [
              Column(children: [
                Header(
                  title: movieData['title'],
                  genres: movieData['genre ids'],
                  backgroundUrl: movieData['background url'],
                ),
                Container(
                  child: MovieOverview(
                    movieData: movieData,
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: 20.0, bottom: 20.0, left: 50.0, right: 50.0),
                    child: Divider(
                      height: 5.0,
                      indent: 0.0,
                      color: Colors.white70,
                    )),
                MovieScreenshotsWidget(
                  movieId: movieData['movieId'],
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: 20.0, bottom: 20.0, left: 50.0, right: 50.0),
                    child: Divider(
                      height: 5.0,
                      indent: 0.0,
                      color: Colors.white70,
                    )),
                CastWidget(
                  movieId: movieData['movieId'],
                )
              ])
            ]));
  }
}
