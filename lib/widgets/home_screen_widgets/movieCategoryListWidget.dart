/*
* This is a widget that displays highlighted movies
* It only shows up to 10 movies, and the user can click to see more highlighted movies
*/

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../screens/movieDetails.dart';
import '../../screens/movieTypesList.dart';
import '../../widgets/general_widgets/loadingWidget.dart';

class MovieCategoryList extends StatefulWidget {
  MovieCategoryList({this.category, this.moviesList});

  final String category; //a header to display what the movies are featured for
  var moviesList; //the method that returns the desired movies list

  MovieCategoryListState createState() => MovieCategoryListState();
}

class MovieCategoryListState extends State<MovieCategoryList> {
  List<Map> _movieData =
      []; //stores all the movies that are fetched from the api
  bool _loading = true; //waits for the data fetching to finish

  void initState() {
    super.initState();
    _getMoviesList();
  }

  Future _getMoviesList() async {
    List mList = await widget
        .moviesList; //make the api call, and store the returned movie data
    final String posterBaseUrl =
        'https://image.tmdb.org/t/p/w500'; //base image url from the TMDB that returns images with 500px width
    final String backgroundBaseUrl =
        'https://image.tmdb.org/t/p/original'; //base image url from TMDB that returns images with their original size

    mList.forEach((item) {
      var uuid = Uuid(); //create a random id to add to the hero widget's tag
      String heroTag =
          'dash ${uuid.v4().toString()}'; //set the hero widget's tag

      /*store all the required data from the api*/
      String movieId = item['id'].toString();
      String backgroundPath = item['backdrop_path'];
      String background = '$backgroundBaseUrl$backgroundPath';
      String title = item['title'];
      String desc = item['overview'];
      String posterPath = item['poster_path'];
      String imgUrl = '$posterBaseUrl$posterPath';
      String rating = item['vote_average'].toString();
      List genreIds = item['genre_ids'];

      Map currentMovieData = {
        'hero tag': heroTag,
        'movieId': movieId,
        'title': title,
        'poster': imgUrl,
        'background url': background,
        'description': desc,
        'rating': rating,
        'genre ids': genreIds
      };

      bool dataIsValid = true; //checks if the data fetched from api is valid

      currentMovieData.forEach((key, value) {
        //if any of the value is null
        if (value.toString().contains('null')) {
          dataIsValid = false; //the data is not valid
        }
      });

      //only if the data is valid
      if (dataIsValid) {
        _movieData.add(currentMovieData); //add it to the movie list
      }
    });

    setState(() {
      _loading = false; //exit the loading state, and display the widget
    });
  }

  @override
  build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.only(top: 10.0, bottom: 20.0, left: 10.0, right: 10.0),
        child: Column(children: [
          Container(
              //contains the header, and the "see more" button
              padding: EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    //the header
                    widget.category,
                    style: Theme.of(context).textTheme.headline,
                  ),
                  GestureDetector(
                      //the "see more" button
                      onTap:
                          ( //when tapped navigate to the movie type list screen
                              () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MovieTypesList(
                                      moviesList: _movieData,
                                      movieTypes: widget.category,
                                    )));
                      }),
                      child: Text(
                        'See more',
                      ))
                ],
              )),
          Container(
              //the list of movie posters
              height: 250.0,
              child: _loading //if loading
                  ? LoadingWidget(
                      //display the loading wiget
                      color: Colors.white70,
                    )
                  : //otherwise display the fetched movies list
                  ListView.builder(
                      scrollDirection: Axis.horizontal,
                      //make it scroll horizontally
                      itemCount: (_movieData.length / 2).round(),
                      //only show half of the fetched movies (at most 10)
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            //wrap each movie poster in a gesture detector widget
                            onTap:
                                ( //when tapped navigate to the movie details screen
                                    () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MovieDetails(
                                            movieData: _movieData[index],
                                          )));
                            }),
                            child: Container(
                                margin: EdgeInsets.only(right: 10.0),
                                child: Hero(
                                    tag: '${_movieData[index]['hero tag']}',
                                    child: Image.network(
                                      _movieData[index]['poster'],
                                      fit: BoxFit.fill,
                                    ))));
                      },
                    )),
        ]));
  }
}
