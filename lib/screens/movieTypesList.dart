import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../widgets/general_widgets/loadingWidget.dart';
import '../widgets/movie_list_screen_widgets/listItem.dart';

class MovieTypesList extends StatefulWidget {
  MovieTypesList({this.movieTypes, this.moviesList, this.fetchMoviesUrl});

  final String movieTypes;
  final List<Map> moviesList;
  var fetchMoviesUrl;

  _MovieTypesListState createState() => _MovieTypesListState();
}

class _MovieTypesListState extends State<MovieTypesList> {
  List<ListItem> _movieList = []; //stores all the fetched movies in a list of widgets
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    //check if the movies were previously fetched
    widget.moviesList != null ? _addMovies() : _getMoviesFromUrl();
  }

  //adds fetched movies to the widget list
  _addMovies() async {
    widget.moviesList.forEach((item) {
      _movieList.add(ListItem(movieData: item));
    });

    setState(() {
      _loading = false;
    });
  }

  //makes an API request to fetch movies
  _getMoviesFromUrl() async {
    //make the api request
    List movieList = await widget.fetchMoviesUrl;

    //base url for posters, and background images with a given size
    final String posterBaseUrl = 'https://image.tmdb.org/t/p/w500';
    final String backgroundBaseUrl = 'https://image.tmdb.org/t/p/original';

    for (int i = 0; i < movieList.length; i++) {
      //create a unique id for each poster's hero tag
      var uuid = Uuid();
      String heroTag = 'dash ${uuid.v4().toString()}';

      //format, and store the data that was fetched from the API
      String movieId = movieList[i]['id'].toString();
      String backgroundPath = movieList[i]['backdrop_path'];
      String background = '$backgroundBaseUrl$backgroundPath';
      String title = movieList[i]['title'];
      String desc = movieList[i]['overview'];
      String posterPath = movieList[i]['poster_path'];
      String imgUrl = '$posterBaseUrl$posterPath';
      String rating = movieList[i]['vote_average'].toString();
      List genreIds = movieList[i]['genre_ids'];

      //store it in a map
      Map movieData = {
        'hero tag': heroTag,
        'movieId': movieId,
        'title': title,
        'poster': imgUrl,
        'background url': background,
        'description': desc,
        'rating': rating,
        'genre ids': genreIds
      };

      //if none of the passed values is null
      if (!movieData.containsValue(null)) {
        //add the data into a widget
        _movieList.add(ListItem(
          movieData: movieData,
        ));
      }
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.movieTypes}'), //the genre, or section of the movies in the list
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: _loading
            ? LoadingWidget(
                color: Colors.white,
              )
            : SafeArea(
                child: ListView(
                children: _movieList,
              )));
  }
}
