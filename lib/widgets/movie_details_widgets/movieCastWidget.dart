import 'package:flutter/material.dart';

import '../../networking/dataFetch.dart';

class CastWidget extends StatefulWidget {
  CastWidget({this.movieId});

  final String movieId;

  CastWidgetState createState() => CastWidgetState();
}

class CastWidgetState extends State<CastWidget> {
  List<Widget> _castList = new List<Widget>();

  @override
  void initState() {
    super.initState();
    _getMovieCast();
  }

  //gets the movie's cast from the API
  Future _getMovieCast() async {
    List castData = await DataFetch().getMoviesCast(widget.movieId);
    List<Widget> c = new List<Widget>();

    for (int i = 0; i < castData.length; i++) {
      //get the image of the cast member
      var castImage = castData[i]['profile_path'];

      //add a widget for each cast member containing the person's image, and name
      c.add(Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(right: 20.0),
          child: Column(children: [
            Container( //container for the image
                alignment: Alignment.center,
                height: 150.0,
                child: castImage != null
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w500$castImage',
                      )
                    : Image.asset(
                        'assets/images/clap_board.png',
                      )),
            Padding( //contains the cast member's name
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
              castData[i]['name'],
              style: TextStyle(color: Colors.white54),
            ))])));
    }

    setState(() {
      _castList = c;
    });
  }

  @override
  build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(left: 5.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text( //the section's header
                'Cast',
                style: Theme.of(context).textTheme.headline,
              ),
              Container( //container for the list of cast members
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 5.0),
                  height: MediaQuery.of(context).size.height / 3,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.only(left: 5.0, top: 10.0),
                      children: _castList))
            ]));
  }
}
