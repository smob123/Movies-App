import 'package:flutter/material.dart';

import '../../screens/movieDetails.dart';

class ListItem extends StatelessWidget {
  ListItem({this.movieData});

  final Map movieData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector( //make the item clickable
        onTap: () { //navigate to the details screen on tap
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
                image: DecorationImage( //background image
              image: NetworkImage(movieData['background url']),
              fit: BoxFit.fill,
            )),
            child: Container( //container for the movie's poster, and general details
              decoration: BoxDecoration(color: Colors.black38), //overlay over the background image
              padding: EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container( //container for the poster
                    padding: EdgeInsets.only(left: 5.0),
                    alignment: Alignment.bottomLeft,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Hero(
                        tag: '${movieData['hero tag']}',
                        child: Image.network(
                          movieData['poster'],
                          width: 150.0,
                        )),
                  ),
                  Container( //container for movie's general information
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(bottom: 50.0, right: 5.0),
                    width: MediaQuery.of(context).size.width / 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text( //the movie's title
                          movieData['title'],
                          style: Theme.of(context).textTheme.headline,
                          textAlign: TextAlign.center,
                        ),
                        Padding( //the movie's rating
                          padding: EdgeInsets.only(top: 5.0),
                          child: Text(
                            movieData['rating'] + ' / 10',
                            style: Theme.of(context).textTheme.title,
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
