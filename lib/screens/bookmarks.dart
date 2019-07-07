import 'package:flutter/material.dart';

import '../config/cacheHandler.dart';
import '../screens/movieDetails.dart';
import '../widgets/general_widgets/loadingWidget.dart';

class Bookmarks extends StatefulWidget {
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  List _bookmarkedMovies = [];
  Widget _bookmarksContainer; //stores a list of the bookmarked movies if they
  // exist, or return a text widget if there are no bookmarked movies

  CacheHandler _cacheHandler = new CacheHandler();
  bool _loading = true;

  void initState() {
    super.initState();
    _getBookmarks();
  }

  //gets bookmarked movies from the cache directory to display them on the screen
  _getBookmarks() async {
    _bookmarkedMovies = await _cacheHandler.getBookmarks();

    //if there are no bookmarked movies
    if (_bookmarkedMovies == null || _bookmarkedMovies.length == 0) {
      _bookmarksContainer = Center(
          //return a text widget
          child: Text(
        'You have no bookmarked movie',
        style: Theme.of(context).textTheme.title,
      ));

      //set loading to false, and exit the method
      setState(() {
        _loading = false;
      });
      return;
    }

    List<Widget> bookmarkList = [];

    for (Map movieData in _bookmarkedMovies) {
      //add all the bookmarks into a list od widgets
      bookmarkList.add(Container(
          padding: EdgeInsets.all(5.0),
          child: GestureDetector(
              onTap: () {
                Navigator.push( //navigate to the movie's details screen on tap
                    context,
                    MaterialPageRoute(
                        builder: (context) => MovieDetails(
                              movieData: movieData,
                            )));
              },
              child: Hero( //add a hero animation to the poster
                  tag: '${movieData['hero tag']}',
                  child: Image.network(
                    movieData['poster'],
                    fit: BoxFit.fill,
                  )))));
    }

    _addToGridView(bookmarkList);
  }

  //adds the bookmarked movies into a grid widget
  _addToGridView(List movies) {
    _bookmarksContainer = GridView.extent(
        childAspectRatio: MediaQuery.of(context).size.width /
            MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        //make sure that there are 3 movies in each row
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
