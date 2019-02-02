import 'package:flutter/material.dart';

import '../networking/dataFetch.dart';
import '../screens/movieDetails.dart';
import '../widgets/general_widgets/loadingWidget.dart';

class SearchScreen extends StatefulWidget {
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Widget _emptyWidget, _searchItemsWidget;
  Widget _movieList;
  bool _loading = false;
  final List<Widget> _posterList = new List<Widget>();
  ScrollController _controller;
  int apiPageNumber = 1;
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    _controller = new ScrollController()
      ..addListener(() {
        if (_controller.offset == _controller.position.maxScrollExtent) {
          apiPageNumber++;
          print(apiPageNumber);
          _searchForMovies(searchTerm);
        }
      });

    _emptyWidget = Container(
      alignment: Alignment.center,
      child: _loading
          ? LoadingWidget(
              color: Colors.white,
            )
          : Text(
              'Type a search term',
              style: TextStyle(color: Colors.white70),
            ),
    );
  }

  _newSearch(String term) {
    _posterList.clear();
    apiPageNumber = 1;
    searchTerm = term;
    _searchForMovies(searchTerm);
    _controller.jumpTo(0.0);
  }

  Future _searchForMovies(String term) async {
    setState(() {
      _loading = true;
    });
    List searchedMovieList =
        await DataFetch().searchForMovies(term, apiPageNumber);

    if (searchedMovieList == null) {
      return;
    }

    final String posterBaseUrl = 'https://image.tmdb.org/t/p/w500';
    final String backgroundBaseUrl = 'https://image.tmdb.org/t/p/original';

    for (int i = 0; i < searchedMovieList.length; i++) {
      String movieId = searchedMovieList[i]['id'].toString();
      String backgroundPath = searchedMovieList[i]['backdrop_path'];
      String background = '$backgroundBaseUrl$backgroundPath';
      String title = searchedMovieList[i]['title'];
      String desc = searchedMovieList[i]['overview'];
      String posterPath = searchedMovieList[i]['poster_path'];
      String imgUrl = '$posterBaseUrl$posterPath';
      String rating = searchedMovieList[i]['vote_average'].toString();
      List genreIds = searchedMovieList[i]['genre_ids'];

      List<String> data = new List<String>();

      data.addAll([movieId, backgroundPath, title, desc, posterPath, rating]);

      if (!data.contains(null)) {
        Map movieData = {
          'movieId': movieId,
          'title': title,
          'poster': imgUrl,
          'background url': background,
          'description': desc,
          'rating': rating,
          'genre ids': genreIds
        };

        _addMovie(movieData, i + _posterList.length);
      }
    }
  }

  _addMovie(Map movieData, int animationIndex) {
    _posterList.add(Container(
        padding: EdgeInsets.all(5.0),
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MovieDetails(
                            movieData: movieData,
                          )));
            },
            child: Hero(
                tag: 'dash $animationIndex',
                child: Image.network(
                  movieData['poster'],
                  fit: BoxFit.fill,
                )))));

    _movieList = GridView.extent(
        controller: _controller,
        childAspectRatio: MediaQuery.of(context).size.width /
            MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        maxCrossAxisExtent: MediaQuery.of(context).size.width / 3,
        children: List.generate(_posterList.length, (index) {
          return _posterList[index];
        }));

    _searchItemsWidget = Container(child: _movieList);

    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
                icon: Icon(
                  Icons.search,
                  color: Colors.white70,
                ),
                hintText: 'Search Movies',
                hintStyle: TextStyle(color: Colors.white70)),
            style: TextStyle(color: Colors.white, fontSize: 20.0),
            onSubmitted: (val) => _newSearch(val),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / 1.29,
                maxWidth: MediaQuery.of(context).size.width),
            child: _movieList == null ? _emptyWidget : _searchItemsWidget,
          )
        ],
      ),
    );
  }
}
