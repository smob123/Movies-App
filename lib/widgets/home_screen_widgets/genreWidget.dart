/*
* this widget is a list of all the available movie genres for users to browse from
*/

import 'package:flutter/material.dart';

import '../../config/movieGenreIds.dart';
import '../../networking/dataFetch.dart';
import '../../screens/movieTypesList.dart';

class GenreWidget extends StatefulWidget {
  _GenreWidgetState createState() => _GenreWidgetState();
}

class _GenreWidgetState extends State<GenreWidget> {
  List<Widget> _genreList = []; //list of all movie genres

  @override
  void initState() {
    super.initState();
    _getMovieGenres();
  }

  /*
  * get the genre names, and ids from the config file, and create a gesture detector for each of them
  * then add it to the array
  */

  Future _getMovieGenres() async {
    Map genreMap = MovieGenreIds().getGenres();
    List genreList = genreMap.keys
        .toList(growable: false); //convert the genres map to a fixed array

    for (String genreId in genreList) {
      _genreList.add(GestureDetector(
          onTap:
              () //when tapped, navigate to the movie type list screen to view all movies that satisfy the current genre
              {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MovieTypesList(
                          fetchMoviesUrl: DataFetch().getMoviesByGenre(genreId),
                          //method to fetch all movies in the specified genre
                          movieTypes: genreMap[genreId], //genre's title
                        )));
          },
          child: (Container(
            alignment: Alignment.center,
            color: Colors.black38,
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(10.0),
            child: Text(
              '${genreMap[genreId]}', //the genre's title
              textAlign: TextAlign.center,
            ),
          ))));
    }
  }

  build(BuildContext context) {
    return Column(children: [
      Container(
        alignment: Alignment.topLeft,
        margin: EdgeInsets.only(left: 5.0),
        child: Text(
          //header text
          'Genres',
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      ConstrainedBox(
          //set the widget's max height to half of the screen's height
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
          child: Container(
            child: GridView.count(
              //display the array's content as a gridview
              scrollDirection: Axis.horizontal,
              childAspectRatio: 0.5,
              crossAxisCount: 3,
              children: _genreList,
            ),
          ))
    ]);
  }
}
