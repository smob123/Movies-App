import 'package:flutter/material.dart';

import '../widgets/general_widgets/loadingWidget.dart';
import '../widgets/movie_list_screen_widgets/listItem.dart';

class MovieTypesList extends StatefulWidget {
  MovieTypesList({this.moviesList});

  final List<Map> moviesList;

  _MovieTypesListState createState() => _MovieTypesListState();
}

class _MovieTypesListState extends State<MovieTypesList> {
  List<ListItem> _movieList = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _addMovies();
  }

  Future _addMovies() async {
    widget.moviesList.forEach((item) {
      _movieList.add(ListItem(movieData: item));
    });

    setState(() {
      _loading = false;
    });
  }

  @override
  build(BuildContext context) {
    return Scaffold(
        body: _loading
            ? LoadingWidget(
                color: Colors.white,
              )
            : ListView(
                children: _movieList,
              ));
  }
}
