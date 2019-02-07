import 'package:flutter/material.dart';

import '../../config/movieGenreIds.dart';
import '../../networking/dataFetch.dart';
import '../../screens/movieTypesList.dart';

class GenreWidget extends StatefulWidget {
  _GenreWidgetState createState() => _GenreWidgetState();
}

class _GenreWidgetState extends State<GenreWidget> {
  List<Widget> _genreList = [];

  @override
  void initState() {
    super.initState();
    _getMovieGenres();
  }

  Future _getMovieGenres() async {
    Map genreMap = MovieGenreIds().getGenres();
    List genreList = genreMap.keys.toList(growable: false);

    for (String genreId in genreList) {
      _genreList.add(GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MovieTypesList(
                          fetchMoviesUrl: DataFetch().getMoviesByGenre(genreId),
                        )));
          },
          child: (Container(
            alignment: Alignment.center,
            color: Colors.black38,
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.all(10.0),
            child: Text(
              '${genreMap[genreId]}',
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
          'Genres',
          style: Theme.of(context).textTheme.headline,
        ),
      ),
      ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 2),
          child: Container(
            child: GridView.count(
              scrollDirection: Axis.horizontal,
              childAspectRatio: 0.5,
              crossAxisCount: 3,
              children: _genreList,
            ),
          ))
    ]);
  }
}
