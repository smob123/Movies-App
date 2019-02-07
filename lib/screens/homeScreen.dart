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
      child: ListView(
        children: <Widget>[
          Header(),
          MovieCategoryList(
            category: 'Latest Movies',
            moviesList: DataFetch().getLatestMovies(),
          ),
          MovieCategoryList(
            category: 'Trending',
            moviesList: DataFetch().getTrendingMovies(),
          ),
          MovieCategoryList(
            category: 'Upcoming Movies',
            moviesList: DataFetch().getUpcomingMovies(),
          ),
          GenreWidget()
        ],
      ),
    ));
  }
}
