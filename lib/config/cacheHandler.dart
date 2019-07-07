import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class CacheHandler {
  var _cacheDir;
  File _cacheFile;

  //get the app's cache directory
  _getCacheDir() async {
    _cacheDir = (await getTemporaryDirectory()).path;
    _cacheFile = new File('$_cacheDir/app_cache.tmp');
  }

  //add a movie's data to the cache file
  addBookmark(Map movieData) {
    //get the cache data
    String cacheData = _readCache();
    //stores the json encoded as a string from the cache
    String cachedJsonString;
    //stores the decoded string as an actual json object
    var cacheJson;

    //if cache exists
    if (cacheData != null) {
      //get the data as a string
      cachedJsonString = json.decode(cacheData);
      //convert the string to a json object
      cacheJson = json.decode(cachedJsonString);
    } else {
      //otherwise create an empty json object
      cacheJson = {};
    }

    //if the json has a child "bookmarks"
    if (cacheJson['bookmarks'] != null) {
      //add the current movie to it
      cacheJson['bookmarks'].add(movieData);
    } else {
      //otherwise create one, and add the movie's data as its first element
      cacheJson['bookmarks'] = [movieData];
    }

    //write the new json object in the cache directory
    _writeCache(json.encode(cacheJson));
  }

  //checks if a specific bookmark exists or not
  getBookmark(Map data) async {
    await _getCacheDir();
    String cacheData = _readCache();
    bool exists = false;

    //if there is cache data
    if (cacheData != null) {
      //get the cache's json object
      var cachedJsonString = json.decode(cacheData);
      var cachedJson = json.decode(cachedJsonString);

      //try to find the movie by ID
      for (var movie in cachedJson['bookmarks']) {
        if (movie['movieId'] == data['movieId']) {
          exists = true;
          break;
        }
      }
    }

    //return whether the movie exists or not
    return exists;
  }

  //returns all the stored bookmarks if they exist
  getBookmarks() async {
    await _getCacheDir();
    String cacheData = _readCache();
    if (cacheData != null) {
      String cacheJsonString = json.decode(cacheData);
      var cacheJson = json.decode(cacheJsonString);

      return cacheJson['bookmarks'];
    }
  }

  //removes a specific bookmark
  removeBookmark(Map data) {
    //get the cache's json object
    String cacheJsonString = json.decode(_readCache());
    Map cacheJson = json.decode(cacheJsonString);

    //find the movie by ID, and remove it
    cacheJson['bookmarks']
        .removeWhere((movie) => movie['movieId'] == data['movieId']);

    //rewrite the cache
    _writeCache(json.encode(cacheJson));
  }

  //writes the data as a string into a cache file
  _writeCache(String data) {
    var dataJson = json.encode(data);
    _cacheFile.writeAsStringSync(dataJson);
  }

  //returns the cache data from the cache file
  String _readCache() {
    try {
      String cacheData = _cacheFile.readAsStringSync();
      return cacheData;
    } catch (ioException) {
      print('Cache file was not found');
    }

    return null;
  }
}
