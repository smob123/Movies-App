import 'package:flutter/material.dart';

class Header extends StatefulWidget {
  Header({this.title, this.backgroundUrl, this.genres});

  final String title;
  final String backgroundUrl;
  final List genres;

  HeaderState createState() =>
      HeaderState(title: title, backgroundUrl: backgroundUrl, genres: genres);
}

class HeaderState extends State<Header> {
  final String title;
  final List genres;
  List<Widget> _genreWidgets = new List<Widget>();
  final String backgroundUrl;
  final Map _allMovieGenres = {
    "28": "Action",
    "12": "Adventure",
    "16": "Animation",
    "35": "Comedy",
    "80": "Crime",
    "99": "Documentary",
    "18": "Drama",
    "10751": "Family",
    "14": "Fantasy",
    "36": "History",
    "27": "Horror",
    "10402": "Music",
    "9648": "Mystery",
    "10749": "Romance",
    "878": "Science Fiction",
    "10770": "TV Movie",
    "53": "Thriller",
    "10752": "War",
    "37": "Western"
  };

  HeaderState({this.title, this.genres, this.backgroundUrl});

  @override
  initState() {
    super.initState();
    _getMovieGenres();
  }

  _getMovieGenres() {
    List<Widget> genreItems = new List<Widget>();

    for (int i = 0; i < genres.length; i++) {
      String currentGenre = _allMovieGenres[genres[i].toString()];

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
              fontFamily: 'Yantramanav',
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
        image: NetworkImage(backgroundUrl),
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
                            title,
                            style: TextStyle(
                                fontSize: 30.0,
                                fontFamily: 'Yantramanav',
                                letterSpacing: 0.5,
                                color: Colors.white),
                          )),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width / 1.3),
                    ),
                  ],
                ),
                ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width, maxHeight: 50.0),
                    child: ListView(scrollDirection: Axis.horizontal, children: _genreWidgets)),
              ])),
    );
  }
}
