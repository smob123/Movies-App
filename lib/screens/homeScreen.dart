/*
* this is the landing screen of the app
* */

import 'package:flutter/material.dart';

import '../networking/dataFetch.dart';
import '../widgets/home_screen_widgets/genreWidget.dart';
import '../widgets/home_screen_widgets/header.dart';
import '../widgets/home_screen_widgets/movieCategoryListWidget.dart';

class HomeScreen extends StatefulWidget {
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  @override
  build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: ListView( //display all screen widgets in a listview
        children: <Widget>[
          Header(),
          MovieCategoryList(
            category: 'Latest Movies',
            moviesList: DataFetch().getLatestMovies(),
          ), //latest movies widget
          MovieCategoryList(
            category: 'Trending',
            moviesList: DataFetch().getTrendingMovies(),
          ), //trending movies widget
          MovieCategoryList(
            category: 'Upcoming Movies',
            moviesList: DataFetch().getUpcomingMovies(),
          ), //upcoming movies widget
          GenreWidget() //a list of available movie genres to browse
        ],
      ),
    ));
  }
}
