import 'package:flutter/material.dart';

import '../../config/movieGenreIds.dart';

class Header extends StatefulWidget {
  Header({this.title, this.backgroundUrl, this.genres});

  final String title;
  final String backgroundUrl;
  final List genres;

  HeaderState createState() => HeaderState();
}

class HeaderState extends State<Header> {
  List<Widget> _genreWidgets = new List<Widget>();
  final Map _allMovieGenres = MovieGenreIds().getGenres();

  @override
  initState() {
    super.initState();
    _getMovieGenres();
  }

  _getMovieGenres() {
    List<Widget> genreItems = new List<Widget>();

    for (int i = 0; i < widget.genres.length; i++) {
      String currentGenre = _allMovieGenres[widget.genres[i].toString()];

      genreItems.add(Container(
          margin:
              EdgeInsets.only(left: 10.0, right: 5.0, top: 10.0, bottom: 10.0),
          padding:
              EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
          decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              border: Border.all(color: Colors.white)),
          child: Text(
            currentGenre,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
            ),
          )));
    }

    setState(() {
      _genreWidgets = genreItems;
    });
  }

  @override
  build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: NetworkImage(widget.backgroundUrl),
        fit: BoxFit.fill,
      )),
      child: Container(
          alignment: Alignment.bottomLeft,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.black26),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: <Widget>[
                    ConstrainedBox(
                      child: Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text(
                            widget.title,
                            style:
                                TextStyle(fontSize: 30.0, color: Colors.white),
                          )),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 1.3),
                    ),
                  ],
                ),
                ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                        maxHeight: 50.0),
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _genreWidgets)),
              ])),
    );
  }
}
