import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../screens/movieDetails.dart';
import '../../screens/movieTypesList.dart';
import '../../widgets/general_widgets/loadingWidget.dart';

class MovieCategoryList extends StatefulWidget {
  MovieCategoryList({this.category, this.moviesList});

  final String category;
  var moviesList;

  MovieCategoryListState createState() => MovieCategoryListState();
}

class MovieCategoryListState extends State<MovieCategoryList> {
  List<Map> _movieData = [];
  bool _loading = true;

  void initState() {
    super.initState();
    _getMoviesList();
  }

  Future _getMoviesList() async {
    List mList = await widget.moviesList;
    final String posterBaseUrl = 'https://image.tmdb.org/t/p/w500';
    final String backgroundBaseUrl = 'https://image.tmdb.org/t/p/original';

    mList.forEach((item) {
      var uuid = Uuid();
      String heroTag = 'dash ${uuid.v4().toString()}';

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

      bool dataIsValid = true;

      currentMovieData.forEach((key, value) {
        if(value.toString().contains('null')) {
          dataIsValid = false;
        }
      });

      if (dataIsValid) {
        _movieData.add(currentMovieData);
      }
    });

    setState(() {
      _loading = false;
    });
  }

  @override
  build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.only(top: 10.0, bottom: 20.0, left: 10.0, right: 10.0),
        child: Column(children: [
          Container(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.category,
                    style: Theme.of(context).textTheme.headline,
                  ),
                  GestureDetector(
                      onTap: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MovieTypesList(
                                      moviesList: _movieData,
                                    )));
                      }),
                      child: Text(
                        'See more',
                        style: TextStyle(),
                      ))
                ],
              )),
          Container(
              height: 250.0,
              child: _loading
                  ? LoadingWidget(
                      color: Colors.white70,
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: (_movieData.length / 2).round(),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: (() {
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
