import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/config.dart';

class DataFetch {
  final String _apiKey = apiData['api key'];

  Future getTrendingMovies() async {
    var res = await http.get(
        'https://api.themoviedb.org/3/trending/movie/week?api_key=$_apiKey');

    if (res.statusCode == 200) {
      var decodedJson = json.decode(res.body);

      return decodedJson['results'];
    }
  }

  Future getUpcomingMovies() async {
    var dateTime = DateTime.now();
    String todaysDate = dateTime.toString().substring(0, 10);

    var res = await http.get(
        'https://api.themoviedb.org/3/discover/movie?api_key=$_apiKey&primary_release_date.gte=$todaysDate');

    if (res.statusCode == 200) {
      var decodedJson = json.decode(res.body);

      return decodedJson['results'];
    }
  }

  Future getLatestMovies() async {
    var dateTime = DateTime.now();
    String todaysDate = dateTime.toString().substring(0, 10);
    String lastMonthsDate =
        dateTime.subtract(Duration(days: 31)).toString().substring(0, 10);

    var res = await http.get(
        'https://api.themoviedb.org/3/discover/movie?api_key=$_apiKey&primary_release_date.lte=$todaysDate&primary_release_date.gte=$lastMonthsDate');

    if (res.statusCode == 200) {
      var decodedJson = json.decode(res.body);

      return decodedJson['results'];
    }
  }

  Future fetchMovieDetails(String movieId) async {
    var res = await http
        .get('http://api.themoviedb.org/3/movie/$movieId?api_key=$_apiKey');

    if (res.statusCode == 200) {
      var decodedJson = json.decode(res.body);
      return decodedJson;
    }
  }

  Future getMoviesCast(String movieId) async {
    var res = await http.get(
        'http://api.themoviedb.org/3/movie/$movieId/casts?api_key=$_apiKey');

    if (res.statusCode == 200) {
      var decodedJson = json.decode(res.body);

      return decodedJson['cast'];
    }
  }

  Future getMovieScreenshots(String movieId) async {
    var res = await http.get(
        'http://api.themoviedb.org/3/movie/$movieId/images?api_key=$_apiKey');

    if (res.statusCode == 200) {
      var decodedJson = json.decode(res.body);
      return decodedJson['backdrops'];
    }
  }

  Future getMovieTrailer(movieId) async {
    var res = await http.get(
        'http://api.themoviedb.org/3/movie/$movieId/videos?api_key=$_apiKey');

    if (res.statusCode == 200) {
      var decodedJson = json.decode(res.body);

      if (decodedJson['results'].length > 0) {
        var videoId = decodedJson['results'][0]['key'];
        return videoId;
      }
    }
  }

  Future searchForMovies(String term, int pageNum) async {
    var res = await http.get(
        'https://api.themoviedb.org/3/search/movie?api_key=$_apiKey&query=$term&page=$pageNum');

    if (res.statusCode == 200) {
      var decodedJson = json.decode(res.body);

      if (pageNum <= decodedJson['total_pages']) {
        return decodedJson['results'];
      }
    }
  }

  Future getMoviesByGenre(String genreId) async {
    var res = await http.get(
        'https://api.themoviedb.org/3/discover/movie?api_key=$_apiKey&with_genres=$genreId&sort_by=popularity.desc&page=1');

    if (res.statusCode == 200) {
      var decodedJson = json.decode(res.body);

      return decodedJson['results'];
    }
  }
}
