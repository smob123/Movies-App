import 'package:flutter/material.dart';

import '../../config/movieGenreIds.dart';

class Header extends StatefulWidget {
  Header({this.title, this.backgroundUrl, this.genres});

  final String title; //the title of the movie
  final String backgroundUrl; //the header's background image
  final List genres; //the movie's genres

  HeaderState createState() => HeaderState();
}

class HeaderState extends State<Header> {
  List<Widget> _genreWidgets =
      new List<Widget>(); //stores genres in a list of small widgets
  final Map _allMovieGenres = MovieGenreIds().getGenres(); //gets genres by ID

  @override
  initState() {
    super.initState();
    _getMovieGenres();
  }

  _getMovieGenres() {
    List<Widget> genreItems = new List<Widget>();

    for (int i = 0; i < widget.genres.length; i++) {
      //get the current genre by id
      String currentGenre = _allMovieGenres[widget.genres[i].toString()];

      genreItems.add(
          //wrapper around the text; ie, the current genre's name
          Container(
              margin: EdgeInsets.only(
                  left: 10.0, right: 5.0, top: 10.0, bottom: 10.0),
              padding: EdgeInsets.only(
                  top: 5.0, bottom: 5.0, left: 10.0, right: 10.0),
              decoration: BoxDecoration(
                  color: Colors.black54, //add a black background
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
      height: MediaQuery.of(context).size.height / 2,
      decoration: BoxDecoration(
          image:
              //background image
              DecorationImage(
        image: NetworkImage(widget.backgroundUrl),
        fit: BoxFit.fill,
      )),
      child: Container( //container for the movie's title, and genres (displayed on top of the background image)
          alignment: Alignment.bottomLeft,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Colors.black26), //overlay to make text readable
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container( //container for the movie's title
                  alignment: Alignment.topLeft,
                  child:
                    ConstrainedBox( //make sure that the text does not go off screen
                      child: Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text(
                            widget.title,
                            style:
                                TextStyle(fontSize: 30.0, color: Colors.white),
                          )),
                      constraints: BoxConstraints( //the text can only take up to 70% of the screen's width
                          maxWidth: MediaQuery.of(context).size.width * 0.7),
                    ),
                ),
                ConstrainedBox( //make sure that the genres' list constrains do not go off screen
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
