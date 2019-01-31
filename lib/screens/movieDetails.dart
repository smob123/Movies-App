import 'package:flutter/material.dart';

import '../widgets/movieOverview.dart';
import '../widgets/movieScreenshotsWidget.dart';

class MovieDetails extends StatefulWidget {
  MovieDetails({this.movieData});

  final Map movieData;

  MovieDetailsState createState() => MovieDetailsState(movieData: movieData);
}

class MovieDetailsState extends State<MovieDetails>
    with SingleTickerProviderStateMixin {
  MovieDetailsState({this.movieData});

  final Map movieData;
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Container(
        alignment: Alignment.topLeft,
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(movieData['still shot']),
                fit: BoxFit.fill)),
      ),
      ConstrainedBox(
          constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 1.5),
          child: Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size(45.0, 45.0),
                  child: Container(
                      height: 45.0,
                      color: Colors.grey,
                      child: TabBar(
                          controller: _controller,
                          indicatorColor: Colors.black38,
                          indicatorWeight: 5.0,
                          tabs: [Icon(Icons.info), Icon(Icons.perm_media)]))),
              body: TabBarView(controller: _controller, children: [
                MovieOverview(
                  movieData: movieData,
                ),
                MovieScreenshotsWidget(movieId: movieData['movieId'])
              ])))
    ]));
  }
}
