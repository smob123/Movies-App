import 'package:flutter/material.dart';

import '../widgets/movie_details_widgets/header.dart';
import '../widgets/movie_details_widgets/movieCastWidget.dart';
import '../widgets/movie_details_widgets/movieOverview.dart';
import '../widgets/movie_details_widgets/movieScreenshotsWidget.dart';

class MovieDetails extends StatefulWidget {
  MovieDetails({this.movieData});

  final Map movieData;

  MovieDetailsState createState() => MovieDetailsState();
}

class MovieDetailsState extends State<MovieDetails> {
  @override
  build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.movieData['title']}'), //the movie's title
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SafeArea(
            child: ListView(
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.all(0.0),
                children: [
              Column(//add the screen's widget in a column
                  children: [
                Header(
                  title: widget.movieData['title'],
                  genres: widget.movieData['genre ids'],
                  backgroundUrl: widget.movieData['background url'],
                ),
                Container(
                  child: MovieOverview(
                    movieData: widget.movieData,
                  ),
                ),
                Padding(
                    //a divider between sections
                    padding: EdgeInsets.only(
                        top: 20.0, bottom: 20.0, left: 50.0, right: 50.0),
                    child: Divider(
                      height: 5.0,
                      indent: 0.0,
                      color: Colors.white70,
                    )),
                MovieScreenshotsWidget( //trailer, and screenshot list
                  movieId: widget.movieData['movieId'],
                ),
                Padding( //divider between sections
                    padding: EdgeInsets.only(
                        top: 20.0, bottom: 20.0, left: 50.0, right: 50.0),
                    child: Divider(
                      height: 5.0,
                      indent: 0.0,
                      color: Colors.white70,
                    )),
                CastWidget( //list of cast members
                  movieId: widget.movieData['movieId'],
                )
              ])
            ])));
  }
}
