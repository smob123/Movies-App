import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../networking/dataFetch.dart';
import '../screens/movieDetails.dart';
import '../widgets/general_widgets/loadingWidget.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({this.searchTerm});

  final String searchTerm;

  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Widget _searchResultsWidget;
  bool _loading = false;
  final List<Widget> _posterList = new List<Widget>();
  ScrollController _controller;
  TextEditingController _textEditingController;
  int apiPageNumber = 1;
  String searchTerm = '';

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  _initializeControllers() {
    _controller = new ScrollController()
      ..addListener(() {
        if (_controller.offset == _controller.position.maxScrollExtent) {
          apiPageNumber++;
          _searchForMovies(searchTerm);
        }
      });

    _textEditingController = new TextEditingController(text: widget.searchTerm);

    _newSearch(widget.searchTerm);
  }

  _newSearch(String term) {
    setState(() {
      _loading = true;
    });

    _posterList.clear();
    apiPageNumber = 1;
    searchTerm = term;
    _searchForMovies(searchTerm);
    try {
      _controller.jumpTo(0.0);
    } catch (e) {}
  }

  Future _searchForMovies(String term) async {
    List searchedMovieList =
        await DataFetch().searchForMovies(term, apiPageNumber);

    if (searchedMovieList == null || searchedMovieList.length < 1) {
      print(searchedMovieList);
      setState(() {
        _loading = false;
      });

      return;
    }

    final String posterBaseUrl = 'https://image.tmdb.org/t/p/w500';
    final String backgroundBaseUrl = 'https://image.tmdb.org/t/p/original';

    for (int i = 0; i < searchedMovieList.length; i++) {
      var uuid = Uuid();
      String heroTag = 'dash ${uuid.v4().toString()}';

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
          'hero tag': heroTag,
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

  _addMovie(Map movieData, int heroTag) {
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
                tag: '${movieData['hero tag']}',
                child: Image.network(
                  movieData['poster'],
                  fit: BoxFit.fill,
                )))));

    _searchResultsWidget = GridView.extent(
        controller: _controller,
        childAspectRatio: MediaQuery.of(context).size.width /
            MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        maxCrossAxisExtent: MediaQuery.of(context).size.width / 3,
        children: List.generate(_posterList.length, (index) {
          return _posterList[index];
        }));

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
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
              margin: EdgeInsets.only(bottom: 5.0, top: 10.0),
              width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.of(context).size.height / 15,
              child: TextField(
                controller: _textEditingController,
                style: Theme.of(context).textTheme.title,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white54),
                  hintText: 'Search Movies...',
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                ),
                onSubmitted: (val) => _newSearch(val),
              )),
          _loading
              ? LoadingWidget(
                  color: Colors.white70,
                )
              : ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height / 1.13,
                      maxWidth: MediaQuery.of(context).size.width),
                  child: Container(child: _searchResultsWidget),
                )
        ],
      ),
    )));
  }
}
