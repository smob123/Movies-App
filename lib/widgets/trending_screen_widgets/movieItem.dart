import 'package:flutter/material.dart';

import '../../screens/movieDetails.dart';

class MovieItem extends StatelessWidget {
  MovieItem({this.movieData});

  final Map movieData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MovieDetails(
                        movieData: movieData,
                      )));
        },
        child: Container(
            height: 350.0,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(movieData['background url']),
              //card background image
              fit: BoxFit.fill,
            )),
            child: Container(
              decoration: BoxDecoration(color: Colors.black38),
              padding: EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 5.0),
                    alignment: Alignment.bottomLeft,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Hero(
                        tag: 'dash ${movieData['movieId']}',
                        child: Image.network(movieData['poster'], width: 150.0,)),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 50.0, right: 5.0),
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          movieData['title'],
                          style: TextStyle(
                              fontFamily: 'Yantramanav',
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: Colors.white,
                              letterSpacing: 1.0),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0),
                          child: Text(
                            movieData['rating'] + ' / 10',
                            style: TextStyle(
                              fontFamily: 'Yantramanav',
                              fontSize: 15.0,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
