import 'package:flutter/material.dart';

import '../../networking/dataFetch.dart';

class CastWidget extends StatefulWidget {
  CastWidget({this.movieId});

  final String movieId;

  CastWidgetState createState() => CastWidgetState(movieId: movieId);
}

class CastWidgetState extends State<CastWidget> {
  CastWidgetState({this.movieId});

  final String movieId;
  List<Widget> _castList = new List<Widget>();

  @override
  void initState() {
    super.initState();
    _getMovieCast();
  }

  Future _getMovieCast() async {
    List castData = await DataFetch().getMoviesCast(movieId);
    List<Widget> c = new List<Widget>();

    for (int i = 0; i < castData.length; i++) {
      var castImage = castData[i]['profile_path'];

      c.add(Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(right: 20.0),
          child: Column(children: [
            Container(
                alignment: Alignment.center,
                height: 150.0,
                child: castImage != null
                    ? Image.network(
                        'https://image.tmdb.org/t/p/w500$castImage',
                      )
                    : Image.asset(
                        'assets/images/clap_board.png',
                      )),
            Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
              castData[i]['name'],
              style: TextStyle(letterSpacing: 0.5, color: Colors.white54),
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
              Text(
                'Cast',
                style: TextStyle(fontSize: 25.0, color: Colors.white70),
              ),
              Container(
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
