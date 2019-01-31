import 'package:flutter/material.dart';

import '../networking/dataFetch.dart';
import '../widgets/loadingWidget.dart';
import '../widgets/movieItem.dart';

class TrendingMovies extends StatefulWidget {
  _TrendingMoviesState createState() => _TrendingMoviesState();
}

class _TrendingMoviesState extends State<TrendingMovies> {
  List<MovieItem> _movieList = new List<MovieItem>();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchMovies();
  }

  Future _fetchMovies() async {
    List movieDataList = await DataFetch().getTrendingMovies();
    final String posterBaseUrl = 'https://image.tmdb.org/t/p/w500';
    final String backgroundBaseUrl = 'https://image.tmdb.org/t/p/original';

    for (int i = 0; i < movieDataList.length; i++) {
      String movieId = movieDataList[i]['id'].toString();
      String backgroundPath = movieDataList[i]['backdrop_path'];
      String background = '$backgroundBaseUrl$backgroundPath';
      String title = movieDataList[i]['title'];
      String desc = movieDataList[i]['overview'];
      String posterPath = movieDataList[i]['poster_path'];
      String imgUrl = '$posterBaseUrl$posterPath';
      String rating = movieDataList[i]['vote_average'].toString();

      List<String> data = new List<String>();

      data.addAll([movieId, backgroundPath, title, desc, posterPath, rating]);

      if (!data.contains(null)) {
        Map _currentMovieData = {
          'movieId': movieId,
          'item index': i,
          'title': title,
          'poster': imgUrl,
          'still shot': background,
          'description': desc,
          'rating': rating
        };

        _movieList.add(MovieItem(movieData: _currentMovieData));
      }
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  build(BuildContext context) {
    return _loading
        ? LoadingWidget(
            color: Colors.white,
          )
        : ListView(
            children: _movieList,
          );
  }
}
