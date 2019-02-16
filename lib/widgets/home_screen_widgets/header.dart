import 'dart:math';

import 'package:flutter/material.dart';

import '../../networking/dataFetch.dart';
import '../../screens/bookmarks.dart';
import '../../screens/movieDetails.dart';
import '../../screens/searchScreen.dart';

class Header extends StatefulWidget {
  HeaderState createState() => HeaderState();
}

class HeaderState extends State<Header> {
  List _topMovieData;
  bool _loading = true;
  Map _movieData;

  void initState() {
    super.initState();
    _getMovieBackground();
  }

  _getMovieBackground() async {
    _topMovieData = await DataFetch().getTrendingMovies();

    var random = new Random();
    int index = random.nextInt(4);

    String movieId = _topMovieData[index]['id'].toString();
    String title = _topMovieData[index]['title'];
    String desc = _topMovieData[index]['overview'];
    final String backgroundBaseUrl = 'https://image.tmdb.org/t/p/original';
    final String posterBaseUrl = 'https://image.tmdb.org/t/p/w500';
    final String movieBackgroundPath =
        backgroundBaseUrl + _topMovieData[index]['backdrop_path'];
    String moviePosterPath =
        posterBaseUrl + _topMovieData[index]['poster_path'];
    String rating = _topMovieData[index]['vote_average'].toString();
    List genreIds = _topMovieData[index]['genre_ids'];

    _movieData = {
      'movieId': movieId,
      'title': title,
      'poster': moviePosterPath,
      'background url': movieBackgroundPath,
      'description': desc,
      'rating': rating,
      'genre ids': genreIds
    };

    setState(() {
      _loading = false;
    });
  }

  @override
  build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 25.0),
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                  onTap: (() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Bookmarks()));
                  }),
                  child: Container(
                    margin: EdgeInsets.only(left: 5.0),
                    child: Icon(
                      Icons.bookmark,
                      color: Colors.white70,
                      size: 30.0,
                    ),
                  )),
              Container(
                width: MediaQuery.of(context).size.width / 1.6,
                child: TextField(
                  style: Theme.of(context).textTheme.title,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white54),
                    hintText: 'Search Movies...',
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    ),
                  ),
                  onSubmitted: ((e) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen(
                                  searchTerm: e,
                                )));
                  }),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 5.0),
                child: Icon(
                  Icons.settings,
                  color: Colors.white70,
                  size: 30.0,
                ),
              )
            ],
          ),
          _loading
              ? Container()
              : GestureDetector(
                  onTap: (() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MovieDetails(
                                  movieData: _movieData,
                                )));
                  }),
                  child: Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 4),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 3,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(_movieData['background url']),
                              fit: BoxFit.fill)),
                      child: Container(
                        alignment: Alignment.topLeft,
                        padding: EdgeInsets.all(10.0),
                        color: Colors.black54,
                        child: Text(
                          _movieData['title'],
                          style: TextStyle(fontSize: 25.0),
                        ),
                      )))
        ]));
  }
}
