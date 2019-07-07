/*
* this is the main screen's header
* It's responsible for navigating to the bookmarks screen, search screen, and the settings screen
* It also suggests a random trending movie
 */

import 'dart:math';

import 'package:flutter/material.dart';

import '../../networking/dataFetch.dart';
import '../../screens/bookmarks.dart';
import '../../screens/movieDetails.dart';
import '../../screens/searchScreen.dart';
import '../../screens/settings/settings.dart';

class Header extends StatefulWidget {
  HeaderState createState() => HeaderState();
}

class HeaderState extends State<Header> {
  List _topMoviesData; //list of the top trending movies fetched from the api
  bool _loading = true; //checks if data has been fetched from api
  Map _movieData; //all movie related data that will be displayed on the header,
  // and the movie details screen when the header is clicked

  void initState() {
    super.initState();
    _getTrendingMovie();
  }

  /*fetches all trending movies, and picks a random one to be displayed on the header*/
  _getTrendingMovie() async {
    _topMoviesData = await DataFetch()
        .getTrendingMovies(); //fetch trending movie from the api

    var random = new Random();
    int index = random.nextInt(5); //pick one of the top five trending movies

    /*get all the movie's required data*/
    String movieId = _topMoviesData[index]['id'].toString();
    String title = _topMoviesData[index]['title'];
    String desc = _topMoviesData[index]['overview'];
    final String backgroundBaseUrl = 'https://image.tmdb.org/t/p/original';
    final String posterBaseUrl = 'https://image.tmdb.org/t/p/w500';
    final String movieBackgroundPath =
        backgroundBaseUrl + _topMoviesData[index]['backdrop_path'];
    String moviePosterPath =
        posterBaseUrl + _topMoviesData[index]['poster_path'];
    String rating = _topMoviesData[index]['vote_average'].toString();
    List genreIds = _topMoviesData[index]['genre_ids'];

    //store the data to display it
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
            //top bar
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                  //button to bookmarked movies screen
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
                //search bar
                width: MediaQuery.of(context).size.width / 1.6,
                child: TextField(
                  style: Theme.of(context).textTheme.title,
                  decoration: InputDecoration(
                    //search bar's appearance
                    hintStyle: TextStyle(color: Colors.white54),
                    hintText: 'Search Movies...',
                    contentPadding: EdgeInsets.all(10.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(50.0)), //round borders
                    ),
                  ),
                  onSubmitted: ((e) {
                    //when the user submits their search term
                    Navigator.push(
                        //navigate to the search screen
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen(
                                  searchTerm: e,
                                )));
                  }),
                ),
              ),
              GestureDetector(
                  //button to navigate to the settings screen
                  onTap: (() {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Settings()));
                  }),
                  child: Container(
                    margin: EdgeInsets.only(right: 5.0),
                    child: Icon(
                      Icons.settings,
                      color: Colors.white70,
                      size: 30.0,
                    ),
                  ))
            ],
          ),
          _loading //if the widget is loading
              ? Container() //display an empty container
              : GestureDetector(
                  //otherwise display a random trending movie
                  onTap:
                      ( //when clicked navigate to move details screen to display the movie's info
                          () {
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
                              //add the movie's background image as the container's decoration image
                              image: NetworkImage(_movieData['background url']),
                              fit: BoxFit.fill)),
                      child: Container(
                        //text container to display the movie's name
                        alignment: Alignment.topLeft,
                        //align the text to the left of the container
                        padding: EdgeInsets.all(10.0),
                        //add some padding to the text
                        color: Colors.black54,
                        //make the container's background color semi-transparent black
                        child: Text(
                          //the movie's title
                          _movieData['title'],
                          style: TextStyle(fontSize: 25.0),
                        ),
                      )))
        ]));
  }
}
