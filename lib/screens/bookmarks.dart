import 'package:flutter/material.dart';

import '../config/cacheHandler.dart';
import '../screens/movieDetails.dart';
import '../widgets/general_widgets/loadingWidget.dart';

class Bookmarks extends StatefulWidget {
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  List _bookmarkedMovies = [];
  Widget _bookmarksContainer;
  CacheHandler _cacheHandler = new CacheHandler();
  bool _loading = true;

  void initState() {
    super.initState();
    _getBookmarks();
  }

  _getBookmarks() async {
    _bookmarkedMovies = await _cacheHandler.getBookmarks();

    if (_bookmarkedMovies == null || _bookmarkedMovies.length == 0) {
      _bookmarksContainer = Center(
          child: Text(
        'You have no bookmarked movie',
        style: Theme.of(context).textTheme.title,
      ));

      setState(() {
        _loading = false;
      });
      return;
    }

    List<Widget> bookmarkList = [];

    for (Map movieData in _bookmarkedMovies) {
      bookmarkList.add(Container(
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
    }

    _addToGridView(bookmarkList);
  }

  _addToGridView(List movies) {
    _bookmarksContainer = GridView.extent(
        childAspectRatio: MediaQuery.of(context).size.width /
            MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        maxCrossAxisExtent: MediaQuery.of(context).size.width / 3,
        children: List.generate(movies.length, (index) {
          return movies[index];
        }));

    setState(() {
      _loading = false;
    });
  }

  build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
                title: Text('Bookmarks'),
                backgroundColor: Colors.transparent,
                elevation: 0.0),
            body: _loading
                ? Center(
                    child: LoadingWidget(
                    color: Colors.white70,
                  ))
                : _bookmarksContainer));
  }
}
